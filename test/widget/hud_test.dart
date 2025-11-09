import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_invaders/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hud displays score text and lives icons', (tester) async {
    await tester.pumpWidget(const SpaceInvadersApp());
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.text('SCORE: 0000'), findsOneWidget);
    expect(find.byKey(const Key('lives-indicator')), findsOneWidget);
  });
}
