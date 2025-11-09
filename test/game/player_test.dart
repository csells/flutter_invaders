import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player', () {
    test('starts with three lives at bottom center', () {
      final player = Player();
      expect(player.lives, 3);
      expect(player.position.y, closeTo(GameDimensions.playerY, 0.001));
      expect(
        player.position.x,
        closeTo((GameDimensions.playfieldWidth - player.size.x) / 2, 0.001),
      );
    });

    test('moveLeft and moveRight adjust position within bounds', () {
      final player = Player();
      player.moveLeft();
      expect(
        player.position.x,
        closeTo(
          (GameDimensions.playfieldWidth - player.size.x) / 2 - player.speed,
          0.001,
        ),
      );

      player.moveRight();
      player.moveRight();
      expect(
        player.position.x,
        closeTo(
          (GameDimensions.playfieldWidth - player.size.x) / 2 + player.speed,
          0.001,
        ),
      );
    });

    test('enforces boundaries', () {
      final player = Player();
      player.position = const Vector2(0, GameDimensions.playerY);
      player.moveLeft();
      expect(player.position.x, 0);

      player.position = Vector2(
        GameDimensions.playfieldWidth - player.size.x,
        GameDimensions.playerY,
      );
      player.moveRight();
      expect(player.position.x, GameDimensions.playfieldWidth - player.size.x);
    });

    test('shoot creates bullet and enforces single bullet rule', () {
      final player = Player();
      final bullet = player.shoot();
      expect(bullet, isNotNull);
      expect(player.activeBullet, isNotNull);
      expect(player.shoot(), isNull);

      player.clearBullet();
      expect(player.shoot(), isNotNull);
    });

    test('losing life decreases lives and detects death', () {
      final player = Player();
      player.loseLife();
      player.loseLife();
      player.loseLife();
      expect(player.lives, 0);
      expect(player.isAlive, isFalse);
    });
  });
}
