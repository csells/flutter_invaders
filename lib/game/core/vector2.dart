import 'dart:math' as math;

import 'package:meta/meta.dart';

@immutable
class Vector2 {
  const Vector2(this.x, this.y);

  final double x;
  final double y;

  static const zero = Vector2(0, 0);

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);

  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);

  Vector2 scale(double factor) => Vector2(x * factor, y * factor);

  Vector2 clamp(double min, double max) => Vector2(
        _clampComponent(x, min, max),
        _clampComponent(y, min, max),
      );

  double distanceTo(Vector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  Vector2 translate(double dx, double dy) => Vector2(x + dx, y + dy);

  @override
  bool operator ==(Object other) =>
      other is Vector2 &&
      (x - other.x).abs() < 0.0001 &&
      (y - other.y).abs() < 0.0001;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vector2(x: $x, y: $y)';

  static double _clampComponent(double value, double min, double max) =>
      math.max(min, math.min(value, max));
}
