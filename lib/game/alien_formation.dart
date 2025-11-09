import 'dart:math' as math;

import 'constants.dart';
import 'core/rect_int.dart';
import 'core/vector2.dart';
import 'entities/alien.dart';

class AlienFormation {
  AlienFormation() : alienRows = _createGrid();
  final List<List<Alien?>> alienRows;
  AlienDirection direction = AlienDirection.right;

  static List<List<Alien?>> _createGrid() {
    final rows = <List<Alien?>>[];
    final rowTypes = [
      AlienType.squid,
      AlienType.crab,
      AlienType.crab,
      AlienType.octopus,
      AlienType.octopus,
    ];

    for (var row = 0; row < 5; row++) {
      final aliens = <Alien?>[];
      for (var col = 0; col < 11; col++) {
        final x = 20 + col * GameDimensions.alienHorizontalSpacing;
        final y =
            GameDimensions.alienTop + row * GameDimensions.alienVerticalSpacing;
        aliens.add(Alien(type: rowTypes[row], position: Vector2(x, y)));
      }
      rows.add(aliens);
    }
    return rows;
  }

  Iterable<Alien> get activeAliens sync* {
    for (final row in alienRows) {
      for (final alien in row) {
        if (alien != null && alien.isAlive) {
          yield alien;
        }
      }
    }
  }

  int get activeAlienCount => activeAliens.length;

  void moveHorizontal(double step) {
    final delta = direction == AlienDirection.right ? step : -step;
    for (final alien in activeAliens) {
      alien.position = alien.position.translate(delta, 0);
    }
  }

  void moveVertical(double distance) {
    for (final alien in activeAliens) {
      alien.position = alien.position.translate(0, distance);
    }
  }

  void reverseDirection() {
    direction = direction == AlienDirection.left
        ? AlienDirection.right
        : AlienDirection.left;
  }

  bool willHitEdge(double step) {
    final aliens = activeAliens.toList();
    if (aliens.isEmpty) return false;
    final delta = direction == AlienDirection.right ? step : -step;
    final leftMost = aliens.map((a) => a.position.x).reduce(math.min);
    final rightMost = aliens
        .map((a) => a.position.x + a.size.x)
        .reduce(math.max);
    final nextLeft = leftMost + delta;
    final nextRight = rightMost + delta;
    if (direction == AlienDirection.right) {
      return nextRight >= GameDimensions.playfieldWidth - 2;
    }
    return nextLeft <= 2;
  }

  RectInt get bounds {
    final aliens = activeAliens.toList();
    if (aliens.isEmpty) {
      return const RectInt(left: 0, top: 0, width: 0, height: 0);
    }
    final left = aliens.map((a) => a.position.x).reduce(math.min);
    final top = aliens.map((a) => a.position.y).reduce(math.min);
    final right = aliens.map((a) => a.position.x + a.size.x).reduce(math.max);
    final bottom = aliens.map((a) => a.position.y + a.size.y).reduce(math.max);
    return RectInt(
      left: left,
      top: top,
      width: right - left,
      height: bottom - top,
    );
  }

  Alien? lowestAlienInColumn(int column) {
    Alien? candidate;
    for (final row in alienRows) {
      final alien = row[column];
      if (alien != null && alien.isAlive) {
        if (candidate == null || alien.position.y > candidate.position.y) {
          candidate = alien;
        }
      }
    }
    return candidate;
  }
}
