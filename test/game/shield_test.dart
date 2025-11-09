import 'package:flutter_invaders/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shield progresses through damage states', () {
    final shield = Shield(position: const Vector2(20, 180));
    expect(shield.state, ShieldState.pristine);
    shield.takeDamage();
    expect(shield.state, ShieldState.chipped);
    shield.takeDamage();
    expect(shield.state, ShieldState.cracked);
    shield.takeDamage();
    expect(shield.state, ShieldState.destroyed);
    shield.takeDamage();
    expect(shield.state, ShieldState.destroyed);
  });
}
