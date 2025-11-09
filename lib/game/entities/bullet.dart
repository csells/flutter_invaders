import '../constants.dart';
import '../core/vector2.dart';
import 'game_object.dart';

enum BulletOwner { player, alien }

enum AlienShotType { rolling, plunger, squiggly }

class Bullet extends GameObject {
  Bullet({
    required super.position,
    required super.size,
    required this.velocity,
    required this.owner,
    this.shotType,
  });

  final Vector2 velocity;
  final BulletOwner owner;
  final AlienShotType? shotType;

  void step() {
    position = position + velocity;
  }

  bool get isOffScreen =>
      position.y + size.y < 0 || position.y > GameDimensions.playfieldHeight;
}
