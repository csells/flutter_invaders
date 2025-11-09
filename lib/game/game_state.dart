import 'dart:math';

import 'alien_formation.dart';
import 'collision_system.dart';
import 'constants.dart';
import 'core/vector2.dart';
import 'entities/alien.dart';
import 'entities/bullet.dart';
import 'entities/player.dart';
import 'entities/shield.dart';
import 'entities/ufo.dart';
import 'game_screen.dart';
import 'input_state.dart';

class GameState {
  GameState() {
    _bootstrap();
  }

  GameScreen currentScreen = GameScreen.title;
  int score = 0;
  int waveNumber = 1;
  final Player player = Player();
  Bullet? _playerBullet;
  final List<Bullet> alienBullets = [];
  late AlienFormation aliens;
  late List<Shield> shields;
  final Ufo ufo = Ufo();
  final InputState inputState = InputState();
  final Random _random = Random();

  double _accumulator = 0;
  int _alienStepDelay = 45;
  int _alienStepTimer = 45;
  bool _fireLatch = false;

  void _bootstrap() {
    aliens = AlienFormation();
    shields = _createShields();
    _alienStepDelay = _calculateFrameDelay(aliens.activeAlienCount);
    _alienStepTimer = _alienStepDelay;
  }

  void reset() {
    currentScreen = GameScreen.title;
    score = 0;
    waveNumber = 1;
    player.reset();
    _playerBullet = null;
    player.clearBullet();
    alienBullets.clear();
    _fireLatch = false;
    _accumulator = 0;
    _bootstrap();
  }

  void startPlaying() {
    reset();
    currentScreen = GameScreen.playing;
  }

  void update(Duration delta) {
    _accumulator += delta.inMicroseconds / 1000000;
    while (_accumulator >= GameTimings.frameDurationSeconds) {
      stepFrame();
      _accumulator -= GameTimings.frameDurationSeconds;
    }
  }

  void stepFrame() {
    if (currentScreen != GameScreen.playing) {
      return;
    }

    _handlePlayerMovement();
    _handleShooting();
    _updatePlayerBullet();
    _updateAlienBullets();
    _updateAliens();
    _updateUfo();
    _checkCollisions();
    _checkWaveProgression();
    _checkGameOverConditions();
  }

  Bullet? get playerBullet => _playerBullet;

  set playerBullet(Bullet? bullet) {
    _playerBullet = bullet;
    player.activeBullet = bullet;
  }

  List<Shield> _createShields() {
    const count = 4;
    const gap = GameDimensions.playfieldWidth / (count + 1);
    final list = <Shield>[];
    for (var i = 0; i < count; i++) {
      final x = gap * (i + 1) - 11;
      list.add(Shield(position: Vector2(x, GameDimensions.shieldY)));
    }
    return list;
  }

  void _handlePlayerMovement() {
    if (inputState.left && !inputState.right) {
      player.moveLeft();
    } else if (inputState.right && !inputState.left) {
      player.moveRight();
    }
  }

  void _handleShooting() {
    if (inputState.fire && !_fireLatch) {
      final bullet = player.shoot();
      if (bullet != null) {
        playerBullet = bullet;
      }
      _fireLatch = true;
    } else if (!inputState.fire) {
      _fireLatch = false;
    }
  }

  void _updatePlayerBullet() {
    final bullet = playerBullet;
    if (bullet == null) {
      return;
    }
    bullet.step();
    if (bullet.isOffScreen) {
      playerBullet = null;
    }
  }

  void _updateAlienBullets() {
    for (final bullet in alienBullets) {
      bullet.step();
    }
    alienBullets.removeWhere((bullet) {
      if (bullet.isOffScreen) {
        return true;
      }
      if (CollisionSystem.overlaps(bullet, player)) {
        registerPlayerHit();
        return true;
      }
      for (final shield in shields) {
        if (CollisionSystem.bulletHitsShield(bullet, shield)) {
          shield.takeDamage();
          return true;
        }
      }
      return false;
    });

    if (alienBullets.length < 3 && _random.nextDouble() < 0.08) {
      final newBullet = _spawnAlienBullet();
      if (newBullet != null) {
        alienBullets.add(newBullet);
      }
    }
  }

  Bullet? _spawnAlienBullet() {
    if (aliens.activeAlienCount == 0) {
      return null;
    }
    for (var i = 0; i < 11; i++) {
      final column = (_random.nextInt(11) + i) % 11;
      final shooter = aliens.lowestAlienInColumn(column);
      if (shooter != null) {
        final position = Vector2(
          shooter.position.x + shooter.size.x / 2 - 2,
          shooter.position.y + shooter.size.y + 2,
        );
        return Bullet(
          position: position,
          size: const Vector2(3, 8),
          velocity: const Vector2(0, BulletConfig.alienSpeed),
          owner: BulletOwner.alien,
          shotType: AlienShotType
              .values[_random.nextInt(AlienShotType.values.length)],
        );
      }
    }
    return null;
  }

  void _updateAliens() {
    if (_alienStepTimer > 0) {
      _alienStepTimer--;
      return;
    }

    const horizontalStep = 2.0;
    if (aliens.willHitEdge(horizontalStep)) {
      aliens.moveVertical(GameDimensions.alienVerticalDrop);
      aliens.reverseDirection();
    } else {
      aliens.moveHorizontal(horizontalStep);
    }
    _alienStepTimer = _alienStepDelay;
  }

  void _updateUfo() {
    ufo.step();
    if (ufo.position.x > GameDimensions.playfieldWidth + 20) {
      ufo.despawn();
    }
  }

  void _checkCollisions() {
    final bullet = playerBullet;
    if (bullet != null) {
      for (final alien in aliens.activeAliens) {
        if (CollisionSystem.overlaps(bullet, alien)) {
          registerAlienHit(alien);
          playerBullet = null;
          break;
        }
      }
      if (playerBullet != null) {
        for (final shield in shields) {
          if (CollisionSystem.bulletHitsShield(playerBullet!, shield)) {
            shield.takeDamage();
            playerBullet = null;
            break;
          }
        }
      }
    }
  }

  void _checkWaveProgression() {
    if (aliens.activeAlienCount == 0) {
      waveNumber += 1;
      aliens = AlienFormation();
      _alienStepDelay = _calculateFrameDelay(aliens.activeAlienCount);
      _alienStepTimer = _alienStepDelay;
    }
  }

  void _checkGameOverConditions() {
    for (final alien in aliens.activeAliens) {
      if (alien.position.y + alien.size.y >= GameDimensions.invasionThreshold) {
        _transitionToGameOver();
        return;
      }
    }
    if (!player.isAlive) {
      _transitionToGameOver();
    }
  }

  void _transitionToGameOver() {
    currentScreen = GameScreen.gameOver;
  }

  void registerAlienHit(Alien alien) {
    if (!alien.isAlive) {
      return;
    }
    alien.destroy();
    score += alien.points;
    _alienStepDelay = _calculateFrameDelay(aliens.activeAlienCount);
  }

  void registerPlayerHit() {
    player.loseLife();
    if (!player.isAlive) {
      _transitionToGameOver();
    } else {
      player.position = Vector2(
        (GameDimensions.playfieldWidth - player.size.x) / 2,
        GameDimensions.playerY,
      );
    }
  }

  void setInput(GameInput input, {required bool isPressed}) {
    inputState.set(input, isPressed: isPressed);
  }

  int get alienStepDelay => _alienStepDelay;

  int _calculateFrameDelay(int activeAlienCount) {
    if (activeAlienCount <= 0) {
      return 5;
    }
    final ratio = activeAlienCount / 55;
    final delay = (5 + (ratio * 40)).round();
    return delay.clamp(5, 45);
  }
}
