import 'dart:math' as math;

import '../constants.dart';
import '../core/vector2.dart';
import 'bullet.dart';
import 'game_object.dart';

class Player extends GameObject {
  Player()
      : lives = PlayerConfig.startingLives,
        speed = PlayerConfig.speed,
        super(
          position: const Vector2(
            (GameDimensions.playfieldWidth - 14) / 2,
            GameDimensions.playerY,
          ),
          size: const Vector2(14, 8),
        );

  int lives;
  final double speed;
  Bullet? activeBullet;

  bool get isAlive => lives > 0;

  void moveLeft() {
    position = Vector2(_clampToBounds(position.x - speed), position.y);
  }

  void moveRight() {
    position = Vector2(_clampToBounds(position.x + speed), position.y);
  }

  Bullet? shoot() {
    if (activeBullet != null) {
      return null;
    }
    final bullet = Bullet(
      position: Vector2(position.x + size.x / 2 - 1, position.y - 4),
      size: const Vector2(2, 4),
      velocity: const Vector2(0, -BulletConfig.playerSpeed),
      owner: BulletOwner.player,
    );
    activeBullet = bullet;
    return bullet;
  }

  void clearBullet() => activeBullet = null;

  void loseLife() {
    if (lives == 0) {
      return;
    }
    lives -= 1;
  }

  void reset() {
    lives = PlayerConfig.startingLives;
    position = Vector2(
      (GameDimensions.playfieldWidth - size.x) / 2,
      GameDimensions.playerY,
    );
    activeBullet = null;
  }

  double _clampToBounds(double x) {
    final maxX = GameDimensions.playfieldWidth - size.x;
    return math.max(0, math.min(x, maxX));
  }
}
