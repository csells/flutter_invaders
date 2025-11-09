import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Vector2', () {
    test('supports addition and subtraction', () {
      const a = Vector2(10, 5);
      const b = Vector2(-2, 3);
      expect(a + b, const Vector2(8, 8));
      expect(a - b, const Vector2(12, 2));
    });

    test('scales and clamps values', () {
      const a = Vector2(2, -3);
      expect(a.scale(4), const Vector2(8, -12));
      expect(a.clamp(-2, 2), const Vector2(2, -2));
    });

    test('calculates distance', () {
      const a = Vector2.zero;
      const b = Vector2(3, 4);
      expect(a.distanceTo(b), closeTo(5, 0.001));
    });
  });

  group('RectInt', () {
    test('computes bounds and center', () {
      const rect = RectInt(left: 10, top: 20, width: 30, height: 40);
      expect(rect.right, 40);
      expect(rect.bottom, 60);
      expect(rect.center, const Vector2(25, 40));
    });

    test('detects intersection', () {
      const a = RectInt(left: 0, top: 0, width: 10, height: 10);
      const b = RectInt(left: 5, top: 5, width: 10, height: 10);
      const c = RectInt(left: 20, top: 20, width: 5, height: 5);
      expect(a.intersects(b), isTrue);
      expect(a.intersects(c), isFalse);
    });
  });
}
