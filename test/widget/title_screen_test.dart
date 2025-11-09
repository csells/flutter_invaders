import 'package:flutter/services.dart';
import 'package:flutter_invaders/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('title screen shows instructions and transitions on SPACE', (
    tester,
  ) async {
    await tester.pumpWidget(const SpaceInvadersApp());
    expect(find.text('SPACE INVADERS'), findsOneWidget);
    expect(find.text('PRESS SPACE TO START'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.text('PRESS SPACE TO START'), findsNothing);
  });
}
