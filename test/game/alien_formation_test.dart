import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlienFormation', () {
    test('initializes 55 active aliens in a 5x11 grid', () {
      final formation = AlienFormation();
      expect(formation.alienRows.length, 5);
      expect(formation.alienRows.every((row) => row.length == 11), isTrue);
      expect(formation.activeAlienCount, 55);
      expect(formation.direction, AlienDirection.right);
    });

    test('moveHorizontal shifts all aliens', () {
      final formation = AlienFormation();
      final firstAlien = formation.alienRows.first.first!;
      final initialX = firstAlien.position.x;
      formation.moveHorizontal(2);
      expect(firstAlien.position.x, initialX + 2);
    });

    test('moveVertical drops aliens by 8 pixels', () {
      final formation = AlienFormation();
      final firstAlien = formation.alienRows.first.first!;
      final initialY = firstAlien.position.y;
      formation.moveVertical(8);
      expect(firstAlien.position.y, initialY + 8);
    });

    test('willHitEdge detects screen boundaries', () {
      final formation = AlienFormation();
      var guard = 0;
      while (!formation.willHitEdge(2) && guard < 200) {
        formation.moveHorizontal(2);
        guard++;
      }
      expect(formation.willHitEdge(2), isTrue);
    });
  });
}
