use std::{
	ops::DerefMut,
	sync::{
		atomic::{AtomicU32, Ordering},
		Arc,
	},
};

use derivative::Derivative;
use flutter_rust_bridge::frb;
use image::{imageops::FilterType, DynamicImage, RgbImage};
use ndarray::{s, ArrayBase, ArrayView, Axis, ShapeBuilder};
use ort::{
	execution_providers::{DirectMLExecutionProvider, ExecutionProvider},
	inputs,
	util::Mutex,
	value::Tensor,
};
use rayon::iter::{IntoParallelIterator, ParallelIterator};
use tracing::{event, Level};

use crate::api::{
	error::YoloError,
	slicing::{get_slice_bboxes, SliceData, SliceInputParams},
	utils::{
		error, info, non_maximum_suppression, BoundingBox, DropTimer,
		NonMaxSuppressionIteratorAdapterExtension, VecU8Wrapper, YoloEntityOutput,
		YOLO_INPUT_IMAGE_HEIGHT, YOLO_INPUT_IMAGE_WIDTH,
	},
};

#[frb(opaque)]
#[derive(Derivative)]
#[derivative(Debug)]
pub struct YoloModelSession {
	#[derivative(Debug = "ignore")]
	pub(crate) session: Arc<Mutex<ort::session::Session>>,
	pub num_labels: usize,
	pub iou_threshold: f32,
	pub slice_iou_threshold: f32,
}

impl YoloModelSession {
	pub(crate) fn new(
		session: ort::session::Session,
		num_labels: usize,
		iou_threshold: f32,
		slice_iou_threshold: f32,
	) -> Self {
		Self {
			session: Arc::new(Mutex::new(session)),
			num_labels,
			iou_threshold,
			slice_iou_threshold,
		}
	}

	pub fn from_memory(
		bytes: VecU8Wrapper,
		num_labels: usize,
		iou_threshold: f32,
		slice_iou_threshold: f32,
	) -> Result<Self, YoloError> {
		let mut session_builder = ort::session::Session::builder()
			.map_err(|err| {
				error!("{err:?}");
				err
			})
			.map_err(YoloError::OrtSessionBuildError)?;

		// let tensor_rt = TensorRTExecutionProvider::default();
		// if let Err(err) = tensor_rt.register(&mut session_builder) {
		// 	error!("Failed to register Nvidia TensorRT: {err:?}");
		// } else {
		// 	info!("Registered Nvidia TensorRT successfully.");
		// }

		// let cuda = CUDAExecutionProvider::default();
		// if let Err(err) = cuda.register(&mut session_builder) {
		// 	error!("Failed to register Nvidia CUDA: {err:?}");
		// } else {
		// 	event!(Level::INFO, "YOLO: Registered Nvidia CUDA successfully.");
		// }

		let directml = DirectMLExecutionProvider::default();
		if let Err(err) = directml.register(&mut session_builder) {
			error!("Failed to register Microsoft DirectML: {err:?}");
		} else {
			info!("Registered Microsoft DirectML successfully.");
		}

		// let open_vino = OpenVINOExecutionProvider::default();
		// if !open_vino.is_available().unwrap() {
		// 	error!("Please compile ONNX Runtime with OpenVINO!");
		// } else if let Err(err) = open_vino.register(&mut session_builder) {
		// 	error!("Failed to register OpenVINO: {err:?}");
		// } else {
		// 	event!(Level::INFO, "YOLO: Registered OpenVINO successfully.");
		// }

		let session = session_builder
			.commit_from_memory(&bytes.v)
			.map_err(|err| {
				event!(Level::INFO, "YOLO: {err:?}");
				err
			})
			.map_err(YoloError::OrtSessionLoadError)?;

		Ok(Self::new(
			session,
			num_labels,
			iou_threshold,
			slice_iou_threshold,
		))
	}

	pub fn sliced_inference(
		&self,
		image: VecU8Wrapper,
		image_width: u32,
		image_height: u32,
		keep_original: bool,
		slice_options: Vec<SliceInputParams>,
	) -> Result<Vec<YoloEntityOutput>, YoloError> {
		let _timer = DropTimer::new_with_log("sliced_inference".into());
		let orig_size = image.v.len();
		let Some(original_image_buffer) = RgbImage::from_vec(image_width, image_height, image.v) else {
			return Err(YoloError::ImageDimensionsToSmall(
				image_width as usize,
				image_height as usize,
				orig_size,
			));
		};
		let original_image = DynamicImage::ImageRgb8(original_image_buffer);

		// let slice_to_tensor_number = AtomicU32::new(0);
		let num_slices = AtomicU32::new(0);

		let res: Vec<YoloEntityOutput> = slice_options
			.into_par_iter()
			.flat_map(
				|SliceInputParams {
				   slice_width,
				   slice_height,
				   overlap_width_ratio,
				   overlap_height_ratio,
				 }| {
					// The inference is not the bottleneck, the image to tensor conversion is the bottleneck, so we are parallelizing here.

					let scaled_width =
						f32::ceil((image_width * YOLO_INPUT_IMAGE_WIDTH) as f32 / slice_width as f32) as u32;
					let scaled_height =
						f32::ceil((image_height * YOLO_INPUT_IMAGE_HEIGHT) as f32 / slice_height as f32) as u32;
					let scaled_image =
						original_image.resize_exact(scaled_width, scaled_height, FilterType::Lanczos3);

					let scaled_slice_bboxes = get_slice_bboxes(
						SliceInputParams {
							slice_width: YOLO_INPUT_IMAGE_WIDTH,
							slice_height: YOLO_INPUT_IMAGE_HEIGHT,
							overlap_width_ratio,
							overlap_height_ratio,
						},
						scaled_width,
						scaled_height,
					);

					num_slices.fetch_add(scaled_slice_bboxes.len() as u32, Ordering::Relaxed);

					// let slice_to_tensor_number = &slice_to_tensor_number;
					scaled_slice_bboxes.into_par_iter().map(move |scaled_slice_bbox| {
						// let id = slice_to_tensor_number.fetch_add(1, Ordering::Relaxed);
						// let _t = DropTimer::new_with_log(format!("Image Slice to Array: {id}").into());

						let BoundingBox { x1, x2, y1, y2 } = scaled_slice_bbox;
						let original_slice_bbox = BoundingBox {
							x1: x1 * slice_width / 640,
							y1: y1 * slice_height / 640,
							x2: x2 * slice_width / 640,
							y2: y2 * slice_height / 640,
						};

						let flat_samples_u8 = scaled_image.as_flat_samples_u8().unwrap();
						let full_tensor_view_u8 =
							flat_samples_into_ndarray(&flat_samples_u8, scaled_width, scaled_height);
						let x1 = x1 as usize;
						let y1 = y1 as usize;
						let box_w = scaled_slice_bbox.width() as usize;
						let box_h = scaled_slice_bbox.height() as usize;
						let part_view =
							full_tensor_view_u8.slice(s![.., .., y1..(y1 + box_h), x1..(x1 + box_w)]);
						let tensor = u8_color_array_to_f32_norm(part_view);

						SliceData {
							tensor,
							original_bbox: original_slice_bbox,
							// id,
						}
					})
				},
			)
			.chain(
				(if keep_original { Some(true) } else { None })
					.into_par_iter()
					.map(|_v| {
						num_slices.fetch_add(1, Ordering::Relaxed);
						// let id = slice_to_tensor_number.fetch_add(1, Ordering::Relaxed);
						// let _t = DropTimer::new(format!("Image Slice to Array: {id}").into());
						let scaled_image = original_image.resize_exact(
							YOLO_INPUT_IMAGE_WIDTH,
							YOLO_INPUT_IMAGE_HEIGHT,
							FilterType::Lanczos3,
						);
						let flat_samples_u8 = scaled_image.as_flat_samples_u8().unwrap();
						let tensor_view_u8 = flat_samples_into_ndarray(
							&flat_samples_u8,
							YOLO_INPUT_IMAGE_WIDTH,
							YOLO_INPUT_IMAGE_HEIGHT,
						);
						let tensor = u8_color_array_to_f32_norm(tensor_view_u8);

						SliceData {
							tensor,
							original_bbox: BoundingBox {
								x1: 0,
								y1: 0,
								x2: image_width,
								y2: image_height,
							},
							// id,
						}
					}),
			)
			.map_with(
				self.session.clone(),
				|arc_session,
				 SliceData {
				   tensor,
				   original_bbox,
				   //  id,
				 }| {
					// let _t = DropTimer::new(format!("Full inference for slice: {id}").into());

					let tensor_from_array = Tensor::from_array(tensor).map_err(YoloError::OrtInputError)?;
					let inputs = inputs!["images" => tensor_from_array];
					let output = {
						// let _t = DropTimer::new(format!("Locked inference for slice: {id}").into());
						let mut session_lock = arc_session.lock();
						let outputs = session_lock
							.deref_mut()
							.run(inputs)
							.map_err(YoloError::OrtInferenceError)?;
						outputs["output0"]
							.try_extract_array::<f32>()
							.map_err(YoloError::OrtExtractSensorError)?
							.reversed_axes()
							.into_owned()
					};
					let output_boxes = output.slice(s![.., .., 0]);
					let slice_w = original_bbox.width();
					let slice_h = original_bbox.height();
					let BoundingBox {
						x1: slice_x1,
						y1: slice_y1,
						..
					} = original_bbox;
					Ok(
						output_boxes
							.axis_iter(Axis(0))
							.filter_map(|row| {
								let (class_id, prob) = row
									.iter()
									.skip(4) // skip bounding box coordinates
									.enumerate()
									.map(|(index, value)| (index, *value))
									.reduce(|accum, row| if row.1 > accum.1 { row } else { accum })?;

								let xc = row[0_usize] / (YOLO_INPUT_IMAGE_WIDTH as f32) * (slice_w as f32);
								let yc = row[1_usize] / (YOLO_INPUT_IMAGE_HEIGHT as f32) * (slice_h as f32);
								let w = row[2_usize] / (YOLO_INPUT_IMAGE_WIDTH as f32) * (slice_w as f32);
								let h = row[3_usize] / (YOLO_INPUT_IMAGE_HEIGHT as f32) * (slice_h as f32);

								Some(YoloEntityOutput {
									bounding_box: BoundingBox {
										x1: slice_x1 + (xc - w / 2.).max(0.0) as u32,
										y1: slice_y1 + (yc - h / 2.).max(0.0) as u32,
										x2: slice_x1 + (xc + w / 2.).max(0.0) as u32,
										y2: slice_y1 + (yc + h / 2.).max(0.0) as u32,
									},
									class_id: class_id.try_into().unwrap_or(u8::MAX),
									confidence: prob,
								})
							})
							.non_maximum_suppression_collect(self.slice_iou_threshold)
							.into_par_iter(),
					)
				},
			)
			.filter_map(|res: Result<_, YoloError>| match res {
				Ok(r) => Some(r),
				Err(err) => {
					error!("{err:?}");
					None
				}
			})
			.flatten()
			.collect();

		info!("Number of slices: {0}", num_slices.load(Ordering::Relaxed));

		// Thresholding is done by the UI layer.
		Ok(non_maximum_suppression(res, self.iou_threshold))
	}
}

fn u8_color_array_to_f32_norm(
	part_view: ArrayBase<ndarray::ViewRepr<&u8>, ndarray::Dim<[usize; 4]>>,
) -> ArrayBase<ndarray::OwnedRepr<f32>, ndarray::Dim<[usize; 4]>> {
	let mut tensor = ArrayBase::zeros((
		1,
		3,
		YOLO_INPUT_IMAGE_HEIGHT as usize,
		YOLO_INPUT_IMAGE_WIDTH as usize,
	));
	ndarray::Zip::from(&mut tensor)
		.and(&part_view)
		.par_for_each(|f, &u| {
			*f = (u as f32) / 255.0;
		});
	tensor
}

fn flat_samples_into_ndarray<'a>(
	flat_samples_u8: &'a image::FlatSamples<&[u8]>,
	w: u32,
	h: u32,
) -> ArrayBase<ndarray::ViewRepr<&'a u8>, ndarray::Dim<[usize; 4]>> {
	let slice: &[u8] = flat_samples_u8.as_slice();
	let (a, b, c) = flat_samples_u8.strides_cwh();
	let mut full_tensor_view_u8 =
		ArrayView::from_shape((1, 3, w as usize, h as usize).strides((1, a, b, c)), slice).unwrap();
	full_tensor_view_u8.swap_axes(2, 3);
	full_tensor_view_u8
}

// fn image_to_yolo_array<
// 	V: num_traits::AsPrimitive<f32>,
// 	T: GenericImageView<Pixel = image::Rgba<V>>,
// >(
// 	image_view: T,
// ) -> ArrayBase<ndarray::OwnedRepr<f32>, ndarray::Dim<[usize; 4]>> {
// 	let mut input = ArrayBase::zeros((
// 		1,
// 		3,
// 		YOLO_INPUT_IMAGE_HEIGHT as usize,
// 		YOLO_INPUT_IMAGE_WIDTH as usize,
// 	));

// 	for (x, y, Rgba([r, g, b, _])) in image_view.pixels() {
// 		let x = x as usize;
// 		let y = y as usize;

// 		input[[0, 0, y, x]] = r.as_() / 255.;
// 		input[[0, 1, y, x]] = g.as_() / 255.;
// 		input[[0, 2, y, x]] = b.as_() / 255.;
// 	}
// 	input
// }

// fn image_to_yolo_array_with_loop(
// 	image_view: SubImage<&DynamicImage>,
// ) -> ArrayBase<ndarray::OwnedRepr<f32>, ndarray::Dim<[usize; 4]>> {
// 	let mut input = ArrayBase::zeros((
// 		1,
// 		3,
// 		YOLO_INPUT_IMAGE_HEIGHT as usize,
// 		YOLO_INPUT_IMAGE_WIDTH as usize,
// 	));

// 	for y in 0..(YOLO_INPUT_IMAGE_HEIGHT as usize) {
// 		for x in 0..(YOLO_INPUT_IMAGE_WIDTH as usize) {
// 			let Rgba([r, g, b, _]) = image_view.get_pixel(x as u32, y as u32);
// 			input[[0, 0, y, x]] = (r as f32) / 255.;
// 			input[[0, 1, y, x]] = (g as f32) / 255.;
// 			input[[0, 2, y, x]] = (b as f32) / 255.;
// 		}
// 	}
// 	input
// }

// fn image_to_yolo_array_unsafe(
// 	image_view: SubImage<&DynamicImage>,
// ) -> ArrayBase<ndarray::OwnedRepr<f32>, ndarray::Dim<[usize; 4]>> {
// 	let mut input = ArrayBase::zeros((
// 		1,
// 		3,
// 		YOLO_INPUT_IMAGE_HEIGHT as usize,
// 		YOLO_INPUT_IMAGE_WIDTH as usize,
// 	));

// 	#[derive(Debug, Clone, Copy)]
// 	struct WrapperType(*mut f32);
// 	unsafe impl Sync for WrapperType {}
// 	unsafe impl Send for WrapperType {}
// 	let ptr = WrapperType(input.as_mut_ptr());

// 	let height = YOLO_INPUT_IMAGE_HEIGHT as usize;
// 	let width = YOLO_INPUT_IMAGE_WIDTH as usize;

// 	// Process pixels in parallel and collect the results
// 	image_view
// 		.pixels()
// 		.par_bridge()
// 		.for_each(|(x, y, Rgba([r, g, b, _]))| {
// 			#[allow(clippy::redundant_locals)]
// 			let ptr = ptr;
// 			let x = x as usize;
// 			let y = y as usize;
// 			let r_norm = (r as f32) / 255.0;
// 			let g_norm = (g as f32) / 255.0;
// 			let b_norm = (b as f32) / 255.0;

// 			// Calculate offsets for each channel: [batch, channel, height, width]
// 			// Channel 0 (R): offset = 0 * height * width + y * width + x
// 			// Channel 1 (G): offset = 1 * height * width + y * width + x
// 			// Channel 2 (B): offset = 2 * height * width + y * width + x
// 			let r_offset = /*************************/ y * width + x;
// 			let g_offset = /********/ height * width + y * width + x;
// 			let b_offset = /****/ 2 * height * width + y * width + x;

// 			unsafe {
// 				*ptr.0.add(r_offset) = r_norm;
// 				*ptr.0.add(g_offset) = g_norm;
// 				*ptr.0.add(b_offset) = b_norm;
// 			}
// 		});

// 	input
// }
