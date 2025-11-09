class GameDimensions {
  static const double playfieldWidth = 224;
  static const double playfieldHeight = 256;
  static const double playerY = 230;
  static const double shieldY = 188;
  static const double alienTop = 60;
  static const double alienHorizontalSpacing = 16;
  static const double alienVerticalSpacing = 14;
  static const double alienVerticalDrop = 8;
  static const double invasionThreshold = 220;
}

class GameTimings {
  static const double frameDurationSeconds = 1 / 60;
}

class PlayerConfig {
  static const double speed = 2;
  static const int startingLives = 3;
}

class BulletConfig {
  static const double playerSpeed = 4;
  static const double alienSpeed = 3;
}
