use flutter_rust_bridge::frb;

#[frb(unignore, dart_metadata=("freezed"))]
#[derive(thiserror::Error, Debug)]
pub enum YoloError {
	#[error("build session: {0}")]
	OrtSessionBuildError(ort::Error),
	#[error("load session: {0}")]
	OrtSessionLoadError(ort::Error),
	#[error("load model: {0}")]
	OrtInputError(ort::Error),
	#[error("run inference: {0}")]
	OrtInferenceError(ort::Error),
	#[error("extract sensor: {0}")]
	OrtExtractSensorError(ort::Error),
	#[error("mutex lock poisoned")]
	MutexLockPoisonedError,
	#[error("image dimensions do not match the buffer size: Image(w={0},h={1}) != Buffer(sz={2})")]
	ImageDimensionsToSmall(usize, usize, usize),
	#[error("image to tensor conversion failed")]
	ImageToTensorConversionFailed,
}

impl YoloError {
	#[frb(sync)]
	pub fn to_string_(&self) -> String {
		format!("{self:?}")
	}
}
