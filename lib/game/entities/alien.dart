import '../core/vector2.dart';
import 'game_object.dart';

enum AlienType { squid, crab, octopus }

enum AlienDirection { left, right }

extension AlienTypeData on AlienType {
  int get points {
    switch (this) {
      case AlienType.squid:
        return 30;
      case AlienType.crab:
        return 20;
      case AlienType.octopus:
        return 10;
    }
  }

  Vector2 get size {
    switch (this) {
      case AlienType.squid:
        return const Vector2(8, 8);
      case AlienType.crab:
        return const Vector2(11, 8);
      case AlienType.octopus:
        return const Vector2(12, 8);
    }
  }
}

class Alien extends GameObject {
  Alien({required this.type, required super.position}) : super(size: type.size);

  final AlienType type;

  bool get isAlive => isActive;

  int get points => type.points;

  void destroy() => deactivate();
}
