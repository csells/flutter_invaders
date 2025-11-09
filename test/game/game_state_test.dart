import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState', () {
    test('initializes in title state with default values', () {
      final state = GameState();
      expect(state.currentScreen, GameScreen.title);
      expect(state.waveNumber, 1);
      expect(state.score, 0);
      expect(state.player.lives, 3);
      expect(state.aliens.activeAlienCount, 55);
    });

    test('reset restores baseline values and positions', () {
      final state = GameState();
      state.currentScreen = GameScreen.playing;
      state.score = 123;
      state.player.lives = 1;
      state.registerAlienHit(state.aliens.activeAliens.first);
      state.reset();

      expect(state.currentScreen, GameScreen.title);
      expect(state.waveNumber, 1);
      expect(state.score, 0);
      expect(state.player.lives, 3);
      expect(state.aliens.activeAlienCount, 55);
    });
  });
}
