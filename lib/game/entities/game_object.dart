import '../core/rect_int.dart';
import '../core/vector2.dart';

abstract class GameObject {
  GameObject({
    required this.position,
    required this.size,
    this.isActive = true,
  });

  Vector2 position;
  final Vector2 size;
  bool isActive;

  RectInt get bounds =>
      RectInt(left: position.x, top: position.y, width: size.x, height: size.y);

  void deactivate() => isActive = false;
}
