enum GameInput { left, right, fire }

class InputState {
  bool left = false;
  bool right = false;
  bool fire = false;

  void set(GameInput input, {required bool isPressed}) {
    switch (input) {
      case GameInput.left:
        left = isPressed;
        return;
      case GameInput.right:
        right = isPressed;
        return;
      case GameInput.fire:
        fire = isPressed;
        return;
    }
  }
}
