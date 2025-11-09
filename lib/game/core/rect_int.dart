import 'vector2.dart';

class RectInt {
  const RectInt({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  double get right => left + width;
  double get bottom => top + height;
  Vector2 get center => Vector2(left + width / 2, top + height / 2);

  bool intersects(RectInt other) {
    if (right <= other.left) return false;
    if (other.right <= left) return false;
    if (bottom <= other.top) return false;
    if (other.bottom <= top) return false;
    return true;
  }

  RectInt translate(double dx, double dy) =>
      RectInt(left: left + dx, top: top + dy, width: width, height: height);
}
