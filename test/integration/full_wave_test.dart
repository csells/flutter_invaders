import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('clearing a wave spawns a new one and increments wave number', () {
    final state = GameState();
    state.currentScreen = GameScreen.playing;
    state.aliens.activeAliens
        .toList()
        .forEach(state.registerAlienHit);

    state.stepFrame();

    expect(state.waveNumber, 2);
    expect(state.aliens.activeAlienCount, 55);
  });
}
