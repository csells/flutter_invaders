import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('player death triggers game over screen', () {
    final state = GameState();
    state.currentScreen = GameScreen.playing;
    state.player.lives = 1;
    state.registerPlayerHit();
    state.stepFrame();
    expect(state.currentScreen, GameScreen.gameOver);
  });

  test('alien invasion triggers game over regardless of lives', () {
    final state = GameState();
    state.currentScreen = GameScreen.playing;
    for (final alien in state.aliens.activeAliens) {
      alien.position = Vector2(
        alien.position.x,
        GameDimensions.invasionThreshold + 1,
      );
    }
    state.stepFrame();
    expect(state.currentScreen, GameScreen.gameOver);
    expect(state.player.lives, 3);
  });
}
