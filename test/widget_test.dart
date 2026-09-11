import 'package:fawj_prototype/app/app.dart';
import 'package:fawj_prototype/app/prototype_controller.dart';
import 'package:fawj_prototype/app/prototype_shell.dart';
import 'package:fawj_prototype/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pilgrim home displays the emergency action', (tester) async {
    await tester.pumpWidget(const FawjApp());

    expect(find.text('BUTUH\nBANTUAN'), findsOneWidget);
    expect(find.text('Rombongan Saya'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Perjalanan'), findsOneWidget);
    expect(find.text('Travel'), findsNothing);
  });

  testWidgets('staff mode uses product navigation rather than role tabs', (tester) async {
    final controller = PrototypeController();
    controller.chooseViewerRole(ViewerRole.staff);
    controller.selectNavigation(0);

    await tester.pumpWidget(MaterialApp(
      theme: buildAppTheme(),
      home: PrototypeShell(controller: controller),
    ));

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Operasional'), findsOneWidget);
    expect(find.text('Travel'), findsNothing);
    controller.dispose();
  });
}
