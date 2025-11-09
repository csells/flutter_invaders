import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('player bullet destroys alien, adds score, and speeds up formation', () {
    final state = GameState();
    state.currentScreen = GameScreen.playing;
    final targetAlien = state.aliens.activeAliens.first;
    final initialDelay = state.alienStepDelay;

    final bullet = state.player.shoot()!;
    bullet.position = Vector2(
      targetAlien.position.x,
      targetAlien.position.y + targetAlien.size.y + 1,
    );
    state.playerBullet = bullet;

    state.stepFrame();

    expect(targetAlien.isAlive, isFalse);
    expect(state.score, targetAlien.points);
    expect(state.playerBullet, isNull);
    expect(state.alienStepDelay, lessThan(initialDelay));
  });
}
