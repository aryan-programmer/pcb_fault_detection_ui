# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "rust_lib_pcb_fault_detection_ui")
project(${PROJECT_NAME} LANGUAGES CXX)

include("../cargokit/cmake/cargokit.cmake")
apply_cargokit(${PROJECT_NAME} ../../../../../../rust rust_lib_pcb_fault_detection_ui "")

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
#C:/local/onnxruntime-win-x64-1.22.0/lib
#C:/local/onnxruntime-win-x64-1.22.0/lib/onnxruntime_providers_cuda.dll
#C:/local/onnxruntime-win-x64-1.22.0/lib/onnxruntime_providers_tensorrt.dll;
set(rust_lib_pcb_fault_detection_ui_bundled_libraries
  "${${PROJECT_NAME}_cargokit_lib};C:/local/onnxruntime-win-x64-1.22.0/lib/DirectML.dll;C:/local/onnxruntime-win-x64-1.22.0/lib/onnxruntime_providers_shared.dll;C:/local/onnxruntime-win-x64-1.22.0/lib/onnxruntime_providers_shared.lib;C:/local/onnxruntime-win-x64-1.22.0/lib/onnxruntime.dll"
  PARENT_SCOPE
)
