import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../entities/alien.dart';
import '../game_state.dart';

class GamePainter extends CustomPainter {
  GamePainter({required this.state});

  final GameState state;

  static const _background = Color(0xFF000000);
  static const _playerColor = Color(0xFF00FF00);
  static const _squidColor = Color(0xFFFFFF00);
  static const _crabColor = Color(0xFF00FFFF);
  static const _octopusColor = Color(0xFF00FF00);
  static const _shieldColor = Color(0xFF66FFFF);
  static const _bulletColor = Color(0xFFFFFFFF);
  static const _ufoColor = Color(0xFFFF3B30);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = _background;
    canvas.drawRect(Offset.zero & size, bgPaint);

    _drawPlayer(canvas);
    _drawPlayerBullet(canvas);
    _drawAlienBullets(canvas);
    _drawAliens(canvas);
    _drawShields(canvas);
    _drawUfo(canvas);
  }

  void _drawPlayer(Canvas canvas) {
    if (!state.player.isAlive) return;
    final paint = Paint()..color = _playerColor;
    final rect = Rect.fromLTWH(
      state.player.position.x,
      state.player.position.y,
      state.player.size.x,
      state.player.size.y,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
  }

  void _drawAliens(Canvas canvas) {
    for (final alien in state.aliens.activeAliens) {
      final paint = Paint()..color = _colorForAlien(alien.type);
      final rect = Rect.fromLTWH(
        alien.position.x,
        alien.position.y,
        alien.size.x,
        alien.size.y,
      );
      canvas.drawRect(rect, paint);
    }
  }

  void _drawPlayerBullet(Canvas canvas) {
    final bullet = state.playerBullet;
    if (bullet == null) return;
    final paint = Paint()..color = _bulletColor;
    final rect = Rect.fromLTWH(
      bullet.position.x,
      bullet.position.y,
      bullet.size.x,
      bullet.size.y,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawAlienBullets(Canvas canvas) {
    final paint = Paint()..color = _bulletColor.withValues(alpha: 0.8);
    for (final bullet in state.alienBullets) {
      final rect = Rect.fromLTWH(
        bullet.position.x,
        bullet.position.y,
        bullet.size.x,
        bullet.size.y,
      );
      canvas.drawRect(rect, paint);
    }
  }

  void _drawShields(Canvas canvas) {
    for (final shield in state.shields) {
      if (shield.isDestroyed) continue;
      final opacity = ui.clampDouble(1 - (shield.state.index * 0.25), 0.2, 1);
      final paint = Paint()..color = _shieldColor.withValues(alpha: opacity);
      final rect = Rect.fromLTWH(
        shield.position.x,
        shield.position.y,
        shield.size.x,
        shield.size.y,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
    }
  }

  void _drawUfo(Canvas canvas) {
    if (!state.ufo.isVisible) return;
    final paint = Paint()..color = _ufoColor;
    final rect = Rect.fromLTWH(
      state.ufo.position.x,
      state.ufo.position.y,
      state.ufo.size.x,
      state.ufo.size.y,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      paint,
    );
  }

  Color _colorForAlien(AlienType type) {
    switch (type) {
      case AlienType.squid:
        return _squidColor;
      case AlienType.crab:
        return _crabColor;
      case AlienType.octopus:
        return _octopusColor;
    }
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}
