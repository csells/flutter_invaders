import '../core/vector2.dart';
import 'game_object.dart';

enum ShieldState { pristine, chipped, cracked, destroyed }

class Shield extends GameObject {
  Shield({required super.position}) : super(size: const Vector2(22, 16));

  ShieldState state = ShieldState.pristine;

  bool get isDestroyed => state == ShieldState.destroyed;

  void takeDamage() {
    switch (state) {
      case ShieldState.pristine:
        state = ShieldState.chipped;
        return;
      case ShieldState.chipped:
        state = ShieldState.cracked;
        return;
      case ShieldState.cracked:
        state = ShieldState.destroyed;
        isActive = false;
        return;
      case ShieldState.destroyed:
        return;
    }
  }
}
