import '../core/vector2.dart';
import 'game_object.dart';

class Ufo extends GameObject {
  Ufo()
      : isVisible = false,
        super(position: const Vector2(-20, 32), size: const Vector2(16, 8));

  bool isVisible;
  int shotCounter = 0;

  void spawn() {
    isVisible = true;
    position = const Vector2(-20, 32);
  }

  void despawn() {
    isVisible = false;
  }

  void step() {
    if (!isVisible) return;
    position = position.translate(2, 0);
  }
}
