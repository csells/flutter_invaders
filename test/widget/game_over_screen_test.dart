import 'package:flutter/services.dart';
import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_invaders/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('game over screen displays final score and restarts', (
    tester,
  ) async {
    await tester.pumpWidget(const SpaceInvadersApp());
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();

    final state = tester
        .state<GameViewState>(find.byType(GameView))
        .controller
        .state;
    state.score = 1234;
    state.currentScreen = GameScreen.gameOver;
    tester.state<GameViewState>(find.byType(GameView)).controller.refresh();
    await tester.pump();

    expect(find.text('GAME OVER'), findsOneWidget);
    expect(find.text('FINAL SCORE: 1234'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(state.currentScreen, GameScreen.playing);
  });
}
