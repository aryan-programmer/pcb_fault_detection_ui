use std::env;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
	env::set_var("RUST_BACKTRACE", "1");
	env::set_var("RUST_LOG", "ort=debug");
	if let Err(err) = tracing_subscriber::fmt()
		.with_max_level(tracing::Level::DEBUG)
		.try_init()
	{
		println!("Tracing subscriber already set: {err:?}")
	}
	// Default utilities - feel free to customize
	flutter_rust_bridge::setup_default_user_utils();
}
