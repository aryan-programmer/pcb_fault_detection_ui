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
        children: <Widget>[
          Text(
            "No project opened.",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Opened project: ${path.basename(store.projectFolder!)}",
          style: Theme.of(context).textTheme.headlineMedium,
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        ExpansionPanelList.radio(
          initialOpenPanelValue: 0,
          children: [
            ExpansionPanelRadio(
              value: 0,
              headerBuilder: (BuildContext context, bool isExpanded) =>
                  ListTile(
                    title: Text("Benchmark image"),
                    subtitle: Text("Long press to change"),
                    onLongPress: store.onOpenBenchmarkFile,
                  ),
              body: Container(
                padding: EdgeInsets.all(8.0),
                child:
                    (benchmarkImageFolderName == null ||
                        benchmarkImagePath == null ||
                        benchmarkImageData == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TestCompareImageArea extends StatelessObserverWidget {
  const TestCompareImageArea({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Align(
          alignment: Alignment.center,
          child: FilledButton.tonal(
            onPressed: () => store.onOpenImageFile(),
            child: Text("Add new image"),
          ),
        ),
        ExpansionPanelList.radio(
          children: [
            for (final entry in store.images.entries)
              ExpansionPanelRadio(
                value: entry.key,
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    ListTile(title: Text(entry.key)),
                body: Container(
                  padding: EdgeInsets.all(8.0),
                  child: PcbAccordionPanel(
                    imageFolderName: entry.key,
                    imagePath: entry.value.imagePath ?? '',
                    imageDataStore: entry.value,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
