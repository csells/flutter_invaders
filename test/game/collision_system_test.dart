import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestObject extends GameObject {
  _TestObject(Vector2 position, Vector2 size)
    : super(position: position, size: size, isActive: true);
}

void main() {
  test('collision system detects overlaps', () {
    final a = _TestObject(Vector2.zero, const Vector2(10, 10));
    final b = _TestObject(const Vector2(5, 5), const Vector2(10, 10));
    final c = _TestObject(const Vector2(20, 20), const Vector2(5, 5));

    expect(CollisionSystem.overlaps(a, b), isTrue);
    expect(CollisionSystem.overlaps(a, c), isFalse);
  });
}
