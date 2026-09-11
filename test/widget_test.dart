import 'package:flutter_test/flutter_test.dart';
import 'package:fawj_prototype/app/app.dart';

void main() {
  testWidgets('pilgrim home displays the emergency action', (tester) async {
    await tester.pumpWidget(const FawjApp());

    expect(find.text('BUTUH\nBANTUAN'), findsOneWidget);
    expect(find.text('Rombongan Saya'), findsOneWidget);
  });
}
