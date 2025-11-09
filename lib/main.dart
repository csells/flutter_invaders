import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/game.dart';
import 'game/rendering/game_painter.dart';

void main() {
  runApp(const SpaceInvadersApp());
}

class SpaceInvadersApp extends StatelessWidget {
  const SpaceInvadersApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Space Invaders',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.black,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'RobotoMono'),
    ),
    home: const GamePage(),
  );
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: GameView())),
  );
}

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  GameViewState createState() => GameViewState();
}

class GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final GameController _controller;

  @visibleForTesting
  GameController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = GameController(tickerProvider: this)
      ..addListener(_onControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    bool? isPressed;
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      isPressed = true;
    } else if (event is KeyUpEvent) {
      isPressed = false;
    }
    if (isPressed == null) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _controller.handleInput(GameInput.left, isPressed: isPressed);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      _controller.handleInput(GameInput.right, isPressed: isPressed);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space) {
      _controller.handleSpace(isPressed: isPressed);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: SizedBox.expand(
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                key: const Key('game-canvas'),
                width: GameDimensions.playfieldWidth,
                height: GameDimensions.playfieldHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _GameCanvas(state: _controller.state),
                    if (_controller.state.currentScreen == GameScreen.title)
                      const _TitleScene(),
                    if (_controller.state.currentScreen == GameScreen.gameOver)
                      _GameOverScene(score: _controller.state.score),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _GameCanvas extends StatelessWidget {
  const _GameCanvas({required this.state});

  final GameState state;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(
        painter: GamePainter(state: state),
        isComplex: true,
        willChange: true,
      ),
          if (state.currentScreen == GameScreen.playing)
            _Hud(score: state.score, lives: state.player.lives),
        ],
      );
}

class _Hud extends StatelessWidget {
  const _Hud({required this.score, required this.lives});

  final int score;
  final int lives;

  String get _scoreText => 'SCORE: ${score.toString().padLeft(4, '0')}';

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _scoreText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        Row(
          key: const Key('lives-indicator'),
          children: List.generate(
            lives,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                width: 12,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _TitleScene extends StatelessWidget {
  const _TitleScene();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SPACE INVADERS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'PRESS SPACE TO START',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'CONTROLS:',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '← → MOVE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'SPACE FIRE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    ),
  );
}

class _GameOverScene extends StatelessWidget {
  const _GameOverScene({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'GAME OVER',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'FINAL SCORE: ${score.toString().padLeft(4, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'PRESS SPACE TO RESTART',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ),
  );
}
