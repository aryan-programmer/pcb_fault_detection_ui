import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:path/path.dart' as path;
import 'package:pcb_fault_detection_ui/src/data/project_data.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/widgets/benchmark_accordion_panel.dart';
import 'package:pcb_fault_detection_ui/src/widgets/pcb_accordion_panel.dart';
import 'package:provider/provider.dart';

class ProjectView extends StatefulObserverWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    if (store.projectFolder == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "No project opened.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FilledButton.tonalIcon(
                onPressed: () => store.closeProject(),
                label: const Text("Open"),
                icon: const Icon(Icons.input),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Opened project: ${path.basename(store.projectFolder!)}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[100]!,
                ),
                onPressed: () => store.closeProject(),
                label: const Text("Close"),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        Expanded(
          child: MultiSplitView(
            axis: Axis.horizontal,
            initialAreas: [
              Area(
                flex: 2,
                max: 3.5,
                min: 1,
                builder: (context, area) => BenchmarkImageArea(),
              ),
              Area(
                flex: 2,
                max: 3.5,
                min: 1,
                builder: (context, area) => TestCompareImageArea(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BenchmarkImageArea extends StatelessObserverWidget {
  const BenchmarkImageArea({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    final projectData = store.projectData ?? ProjectData();
    final benchmarkImageFolderName = projectData.benchmarkDataFolder;
    final benchmarkImagePath = store.benchmarkImagePath;
    final benchmarkImageData = store.benchmarkImageData;
    return Container(
      padding: const EdgeInsets.all(4.0),
      child:
          (benchmarkImageFolderName == null ||
              benchmarkImagePath == null ||
              benchmarkImageData == null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BenchmarkCardListTile(),
                Text(
                  "No benchmark file selected.",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            )
          : BenchmarkAccordionPanel(
              benchmarkImageFolderName: benchmarkImageFolderName,
              benchmarkImagePath: benchmarkImagePath,
              benchmarkImageData: benchmarkImageData,
              setThreshold: store.setBenchmarkImageDetectionThreshold,
              setComponents: store.setBenchmarkImageComponents,
              removeComponent: store.removeBenchmarkImageComponent,
            ),
    );
  }
}

class TestCompareImageArea extends StatelessObserverWidget {
  const TestCompareImageArea({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    // Read for mobx
    store.images;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Navigator(
        initialRoute: "main",
        onGenerateRoute: (settings) {
          WidgetBuilder? builder;
          final name = settings.name;
          if (name != null) {
            if (name == "main") {
              builder = (context) => TestCompareImagesList();
            } else {
              final uri = Uri.parse(name);
              if (uri.pathSegments.length == 2 &&
                  uri.pathSegments.first == 'image') {
                final id = uri.pathSegments[1];
                final imageDataStore = store.images[id];
                if (imageDataStore != null) {
                  builder = (context) => PcbAccordionPanel(
                    imageFolderName: id,
                    imagePath: imageDataStore.imagePath ?? '',
                    imageDataStore: imageDataStore,
                  );
                }
              }
            }
          }

          builder ??= (context) => TextButton(
            child: const Text("404 Not Found. Press to go back."),
            onPressed: () => Navigator.of(context).pop(),
          );
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}

class TestCompareImagesList extends StatelessObserverWidget {
  const TestCompareImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.center,
            child: FilledButton.tonal(
              onPressed: () => store.onOpenImageFile(),
              child: const Text("Add new image"),
            ),
          ),
        ),
        for (final entry in store.images.entries)
          ListTile(
            title: Text(entry.key),
            onTap: () {
              Navigator.of(context).pushNamed('image/${entry.key}');
            },
            trailing: IconButton.filledTonal(
              style: FilledButton.styleFrom(backgroundColor: Colors.red[100]!),
              onPressed: () => entry.value.deleteImage(),
              icon: const Icon(Icons.delete),
            ),
          ),
      ],
    );
  }
}
