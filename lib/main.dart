import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pcb_fault_detection_ui/src/models/pcb_components_model.dart';
import 'package:pcb_fault_detection_ui/src/models/track_defects_model.dart';
import 'package:pcb_fault_detection_ui/src/rust/frb_generated.dart';
import 'package:pcb_fault_detection_ui/src/store/project.store.dart';
import 'package:pcb_fault_detection_ui/src/widgets/project_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<PcbComponentsModel?>(
          initialData: null,
          create: (context) async => await PcbComponentsModel.load(),
          catchError: (context, error) {
            log(error.toString());
            return null;
          },
        ),
        FutureProvider<TrackDefectsModel?>(
          initialData: null,
          create: (context) async => await TrackDefectsModel.load(),
          catchError: (context, error) {
            log(error.toString());
            return null;
          },
        ),
        Provider<ProjectStore>(create: (_) => ProjectStore()),
      ],
      child: MaterialApp(
        title: 'PCB Fault Detection UI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.black),
            trackColor: WidgetStateProperty.all(Colors.green),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        home: const MainHomePage(title: 'PCB Fault Detection UI'),
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  final String title;

  const MainHomePage({super.key, required this.title});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  Timer? timer;
  ProjectStore? store;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 3),
      (Timer t) => store?.saveToFile(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ProjectStore>(context);
    this.store = store;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_rounded),
            tooltip: 'Open Project',
            onPressed: store.onOpenProject,
          ),
        ],
      ),
      body: ProjectView(),
    );
  }
}
