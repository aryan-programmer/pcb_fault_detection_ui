use flutter_rust_bridge::frb;
use ndarray::Array4;

use crate::api::utils::{info, BoundingBox, SliceBoundingBox};

/// Generate slice bounding boxes for an image
pub(crate) fn get_slice_bboxes(
	SliceInputParams {
		slice_width,
		slice_height,
		overlap_width_ratio,
		overlap_height_ratio,
	}: SliceInputParams,
	image_width: u32,
	image_height: u32,
) -> Vec<SliceBoundingBox> {
	// Early return for edge cases
	if slice_width == 0
		|| slice_height == 0
		|| image_width == 0
		|| image_height == 0
		|| image_width <= slice_width
		|| image_height <= slice_height
	{
		return Vec::new();
	}

	// Clamp overlap ratios to valid range [0.0, 1.0)
	let overlap_width_ratio = overlap_width_ratio.clamp(0.0, 0.99);
	let overlap_height_ratio = overlap_height_ratio.clamp(0.0, 0.99);

	// Determine slice parameters
	// Calculate step sizes (distance between slice origins)
	let ideal_split_w = (slice_width as f32 * (1.0 - overlap_width_ratio)).max(1.0);
	let ideal_split_h = (slice_height as f32 * (1.0 - overlap_height_ratio)).max(1.0);

	// Ensure minimum step size of 1 to prevent infinite loops
	let split_w = ((image_width as f32 / (image_width as f32 / ideal_split_w).ceil()).ceil()) as u32;
	let split_h =
		((image_height as f32 / (image_height as f32 / ideal_split_h).ceil()).ceil()) as u32;
	let x_overlap = slice_width - split_w;
	let y_overlap = slice_height - split_h;

	let mut slice_bboxes =
		Vec::with_capacity(((image_width / split_w + 1) * (image_height / split_h + 1)) as _);

	let mut y_min = 0;
	let mut y_max = 0;

	// Generate slices row by row
	while y_max < image_height {
		let mut x_min = 0;
		let mut x_max = 0;
		y_max = y_min + slice_height;

		// Generate slices column by column within current row
		while x_max < image_width {
			x_max = x_min + slice_width;

			// Handle edge cases where slice extends beyond image boundaries
			let (final_x_max, final_y_max, final_x_min, final_y_min) =
				if y_max > image_height || x_max > image_width {
					let final_x_max = image_width.min(x_max);
					let final_y_max = image_height.min(y_max);
					let final_x_min = final_x_max.saturating_sub(slice_width);
					let final_y_min = final_y_max.saturating_sub(slice_height);
					(final_x_max, final_y_max, final_x_min, final_y_min)
				} else {
					(x_max, y_max, x_min, y_min)
				};

			slice_bboxes.push(SliceBoundingBox::new(
				final_x_min,
				final_y_min,
				final_x_max,
				final_y_max,
			));

			// Move to next column with overlap
			x_min = x_max.saturating_sub(x_overlap);
		}

		// Move to next row with overlap
		y_min = y_max.saturating_sub(y_overlap);
	}

	let num_bboxes = slice_bboxes.len();

	info!(
		"get_slice_bboxes(SliceInputParams {{
		slice_width: {slice_width},
		slice_height: {slice_height},
		overlap_width_ratio: {overlap_width_ratio},
		overlap_height_ratio: {overlap_height_ratio},
	}},
	image_width: {image_width},
	image_height: {image_height}): {{
	ideal_split_w: {ideal_split_w},
	ideal_split_h: {ideal_split_h},
	split_w: {split_w},
	split_h: {split_h},
	x_overlap: {x_overlap},
	y_overlap: {y_overlap},
	num_bboxes: {num_bboxes}
}}"
	);

	slice_bboxes
}

#[derive(Debug, Clone, Copy)]
#[frb(json_serializable, dart_metadata=("freezed"))]
pub struct SliceInputParams {
	pub slice_width: u32,
	pub slice_height: u32,
	pub overlap_width_ratio: f32,
	pub overlap_height_ratio: f32,
}

#[derive(Debug, Clone)]
pub(crate) struct SliceData {
	pub(crate) tensor: Array4<f32>, // 1*(channels=3)*640*640
	// pub(crate) orig_slice_bbox: SliceBoundingBox,
	pub(crate) rel_bbox: BoundingBox,
	pub(crate) scaled_width: u32,
	pub(crate) scaled_height: u32,
	// pub(crate) id: u32, // For tracking & timing
}
