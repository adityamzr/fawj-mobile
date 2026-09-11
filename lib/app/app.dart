import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'prototype_controller.dart';
import 'prototype_shell.dart';

class FawjApp extends StatefulWidget {
  const FawjApp({super.key});

  @override
  State<FawjApp> createState() => _FawjAppState();
}

class _FawjAppState extends State<FawjApp> {
  late final PrototypeController controller;

  @override
  void initState() {
    super.initState();
    controller = PrototypeController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAWJ Prototype',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: PrototypeShell(controller: controller),
    );
  }
}
