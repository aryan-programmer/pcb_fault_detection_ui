#![allow(unused_macros)]
use std::{borrow::Cow, fmt::Display, time::Instant};

use flutter_rust_bridge::frb;
use rayon::slice::ParallelSliceMut;

#[derive(Debug, Clone, Copy)]
pub enum MatchMetric {
	IOU,
	IOS,
}

#[derive(Debug, Clone)]
pub struct VecU8Wrapper {
	pub v: Vec<u8>,
}

#[derive(Debug, Clone, Copy)]
#[frb(json_serializable, dart_metadata=("freezed"))]
pub struct BoundingBox {
	pub x1: u32,
	pub y1: u32,
	pub x2: u32,
	pub y2: u32,
}

#[derive(Debug, Clone, Copy)]
#[frb(json_serializable, dart_metadata=("freezed"))]
pub struct YoloEntityOutput {
	pub bounding_box: BoundingBox,
	/// The label of the detected entity.
	///
	/// You can check the metadata of the model with
	/// [Netron](https://netron.app) to get the labels.
	pub class_id: u8,
	/// The confidence of the detected entity.
	pub confidence: f32,
}

impl BoundingBox {
	#[frb(sync)]
	pub fn new(x1: u32, y1: u32, x2: u32, y2: u32) -> Self {
		Self { x1, y1, x2, y2 }
	}

	#[frb(sync)]
	pub fn width(&self) -> u32 {
		self.x2.saturating_sub(self.x1)
	}

	#[frb(sync)]
	pub fn height(&self) -> u32 {
		self.y2.saturating_sub(self.y1)
	}

	#[frb(sync)]
	pub fn area(&self) -> f32 {
		((self.width() as f32) * (self.height() as f32)).abs()
	}

	#[frb(sync)]
	pub fn intersection(&self, box2: &BoundingBox) -> f32 {
		let left = self.x1.max(box2.x1);
		let top = self.y1.max(box2.y1);
		let right = self.x2.min(box2.x2);
		let bottom = self.y2.min(box2.y2);

		if right > left && bottom > top {
			((right - left) as f32) * ((bottom - top) as f32)
		} else {
			0.0
		}
	}

	#[frb(sync)]
	pub fn union(&self, box2: &BoundingBox) -> f32 {
		self.area() + box2.area() - self.intersection(box2)
	}

	#[frb(sync)]
	pub fn iou(&self, box2: &BoundingBox) -> f32 {
		let intersection = self.intersection(box2);
		if intersection == 0.0 {
			return 0.0;
		}

		let union = self.union(box2);
		if union == 0.0 {
			0.0
		} else {
			intersection / union
		}
	}

	#[frb(sync)]
	pub fn ios(&self, box2: &BoundingBox) -> f32 {
		let intersection = self.intersection(box2);
		if intersection == 0.0 {
			return 0.0;
		}

		let smaller = self.area().min(box2.area());
		if smaller == 0.0 {
			0.0
		} else {
			intersection / smaller
		}
	}

	#[frb(sync)]
	pub fn metric(&self, box2: &BoundingBox, metric: MatchMetric) -> f32 {
		match metric {
			MatchMetric::IOU => self.iou(box2),
			MatchMetric::IOS => self.ios(box2),
		}
	}

	#[frb(sync)]
	pub fn is_valid(&self) -> bool {
		self.x2 > self.x1 && self.y2 > self.y1
	}
}

pub(crate) fn sort_predictions(predictions: &mut [YoloEntityOutput]) {
	// Sort by confidence descending
	predictions.par_sort_unstable_by(|a, b| b.confidence.total_cmp(&a.confidence));
}

pub(crate) fn non_maximum_suppression(
	mut boxes: Vec<YoloEntityOutput>,
	metric_type: MatchMetric,
	threshold: f32,
) -> Vec<YoloEntityOutput> {
	// Early return if no boxes are provided
	if boxes.is_empty() {
		return Vec::new();
	}

	// Sort boxes by confidence descending using sort_unstable_by for better performance
	sort_predictions(&mut boxes);

	non_maximum_suppression_with_sorted_boxes(boxes, metric_type, threshold)
}

pub(crate) fn non_maximum_suppression_with_sorted_boxes(
	boxes: Vec<YoloEntityOutput>,
	metric_type: MatchMetric,
	iou_threshold: f32,
) -> Vec<YoloEntityOutput> {
	let mut result = Vec::with_capacity(boxes.len());

	// Iterate through each box and select it if it doesn't overlap significantly with already selected boxes
	for current in boxes.into_iter() {
		// Check if the current box has a high IoU with any box in the result
		// Using `iter().all()` ensures we short-circuit on the first overlap found
		if result.iter().all(|selected: &YoloEntityOutput| {
			selected
				.bounding_box
				.metric(&current.bounding_box, metric_type)
				< iou_threshold
		}) {
			result.push(current);
		}
	}

	result.shrink_to_fit();

	result
}

#[frb(ignore)]
pub(crate) trait NonMaxSuppressionIteratorAdapterExtension
where
	Self: Sized + Iterator<Item = YoloEntityOutput>,
{
	#[frb(ignore)]
	fn non_maximum_suppression_collect(
		self,
		metric: MatchMetric,
		threshold: f32,
	) -> Vec<YoloEntityOutput> {
		non_maximum_suppression(self.collect(), metric, threshold)
	}
}

#[frb(ignore)]
impl<T: Sized + Iterator<Item = YoloEntityOutput>> NonMaxSuppressionIteratorAdapterExtension for T {}

pub const YOLO_INPUT_IMAGE_WIDTH: u32 = 640;
pub const YOLO_INPUT_IMAGE_HEIGHT: u32 = 640;

#[derive(Debug, Clone)]
pub(crate) struct DropTimer<'a> {
	start: Instant,
	name: Cow<'a, str>,
}

impl Drop for DropTimer<'_> {
	fn drop(&mut self) {
		info!("{self}");
	}
}

impl Display for DropTimer<'_> {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		let seconds = self.start.elapsed().as_secs_f32();
		if seconds > 10.0 {
			write!(f, "{0} elapsed: {1}s", self.name, seconds)
		} else {
			write!(f, "{0} elapsed: {1}ms", self.name, seconds * 1000.0)
		}
	}
}

impl<'a> DropTimer<'a> {
	pub(crate) fn new_with_log(name: Cow<'a, str>) -> Self {
		info!("{name} started");
		Self {
			start: Instant::now(),
			name,
		}
	}

	#[allow(dead_code)]
	pub(crate) fn new(name: Cow<'a, str>) -> Self {
		Self {
			start: Instant::now(),
			name,
		}
	}
}

macro_rules! tracing_span {
	() => {
		let span = ::tracing::span!(::tracing::Level::INFO, "pcb");
		let _enter = span.enter();
	};
}

macro_rules! trace {
	($($arg:tt)+) => {{
		crate::api::utils::tracing_span!();
		tracing::trace!($($arg)+);
	}}
}
macro_rules! debug {
	($($arg:tt)+) => {{
		crate::api::utils::tracing_span!();
		tracing::debug!($($arg)+);
	}}
}
macro_rules! info {
	($($arg:tt)+) => {{
		crate::api::utils::tracing_span!();
		tracing::info!($($arg)+);
	}}
}
macro_rules! warning {
	($($arg:tt)+) => {{
		crate::api::utils::tracing_span!();
		tracing::warn!($($arg)+);
	}}
}
macro_rules! error {
	($($arg:tt)+) => {{
		crate::api::utils::tracing_span!();
		tracing::error!($($arg)+);
	}}
}
#[allow(unused_imports)]
pub(crate) use debug;
pub(crate) use error;
pub(crate) use info;
#[allow(unused_imports)]
pub(crate) use trace;
pub(crate) use tracing_span;
#[allow(unused_imports)]
pub(crate) use warning;
