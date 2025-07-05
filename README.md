# pcb_fault_detection_ui

A Flutter desktop application that allows you to find defects in PCB by using their images.

This project leverages Flutter for GUI and Rust for the ML inference logic, utilizing the capabilities of the [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge) framework.

It uses 2 YOLOv11 models:

- One to detect defects in the PCB copper tracks.
- Another to detect components soldered onto the PCB track.

The two models are mutually exclusive, i.e. if an image is select as a track image, then it cannot also be selected as a component image. This is because a components image leads to many false positives when run on the track model.

The copper track defect model executed directly on selected images (after slicing).

The components are first detected on the image of a known good benchmark PCB. Then images of other PCBs are selected which are compared with the benchmark to find defects. This also uses slicing.

## Slicing

The images are sliced into smaller square sub-images and then sent to the model for inference, as this enables it to detect small components/track defects. The results are then stitched together to get the final result. This is called [Slicing Aided Hyper Inference (SAHI)](https://ieeexplore.ieee.org/document/9897990). Much of the code for this has been translated from [python SAHI implementation](https://github.com/obss/sahi), but translated to Rust.

## Why are you using Rust, and where are you using it?

Here, we use Rust to actually execute the ML model inference using the Rust [ort 2.0.0-rc.10](https://ort.pyke.io/) library. The models are stored in the ONNX format, which is compatible with Ort, as it internally uses the ONNX Runtime library.

Also, we use Rust, and the [image](https://docs.rs/image/latest/image/) and [ndarray](https://docs.rs/ndarray/latest/ndarray/) libraries for the image slicing.

Finally, we use the Rust [rayon](https://docs.rs/rayon/latest/rayon/) library, for easy & simple parallelism. It allows us to directly & easily run parallel operation on streams of data like (map, filter_map, flatten, sort, etc.) by using it's parallel iterators.

Note: We have only compiled Ort with DirectML support as the only execution provider, along with the CPU fallback of course. The reason for this is because the CUDA binaries needlessly inflated the final application, when most devices we will demonstrate it on will not have a CUDA compatible GPU (including the PC that this was developed on). So, for the sake of simplicity, other execution providers are not included. However, the Ort library makes it very easy to add execution providers as necessary, so if needed they can be added. The code for the using them is also included, but commented out.

## Demonstration

View the demo at https://youtu.be/tCxNRT4C0cI