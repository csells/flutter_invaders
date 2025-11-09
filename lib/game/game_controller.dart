import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'game_screen.dart';
import 'game_state.dart';
import 'input_state.dart';

class GameController extends ChangeNotifier {
  GameController({required TickerProvider tickerProvider})
    : state = GameState() {
    _ticker = tickerProvider.createTicker(_handleTick);
    unawaited(_ticker.start());
  }

  final GameState state;
  late final Ticker _ticker;
  Duration? _lastElapsed;

  void _handleTick(Duration elapsed) {
    if (_lastElapsed == null) {
      _lastElapsed = elapsed;
      return;
    }
    final delta = elapsed - _lastElapsed!;
    _lastElapsed = elapsed;
    state.update(delta);
    notifyListeners();
  }

  void handleInput(GameInput input, {required bool isPressed}) {
    state.setInput(input, isPressed: isPressed);
  }

  void handleSpace({required bool isPressed}) {
    final screen = state.currentScreen;
    if (screen == GameScreen.title && isPressed) {
      state.startPlaying();
      notifyListeners();
      return;
    }
    if (screen == GameScreen.gameOver && isPressed) {
      state.startPlaying();
      notifyListeners();
      return;
    }
    if (screen == GameScreen.playing) {
      handleInput(GameInput.fire, isPressed: isPressed);
    }
  }

  void refresh() => notifyListeners();

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
