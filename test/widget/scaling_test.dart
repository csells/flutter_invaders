import 'package:flutter/material.dart';
import 'package:flutter_invaders/game/constants.dart';
import 'package:flutter_invaders/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('wide viewport letterboxes horizontally', (tester) async {
    final view = tester.view;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    view.physicalSize = const Size(800, 400);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(const SpaceInvadersApp());
    await tester.pump();

    final canvasBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('game-canvas')),
    );
    expect(canvasBox.size.width, GameDimensions.playfieldWidth);
    expect(canvasBox.size.height, GameDimensions.playfieldHeight);
  });

  testWidgets('tall viewport letterboxes vertically', (tester) async {
    final view = tester.view;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    view.physicalSize = const Size(400, 900);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(const SpaceInvadersApp());
    await tester.pump();

    final canvasBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('game-canvas')),
    );
    expect(canvasBox.size.width, GameDimensions.playfieldWidth);
    expect(canvasBox.size.height, GameDimensions.playfieldHeight);
  });

  testWidgets('FittedBox scales up to fill large viewport', (tester) async {
    final view = tester.view;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    view.physicalSize = const Size(800, 600);
    view.devicePixelRatio = 1;

    await tester.pumpWidget(const SpaceInvadersApp());
    await tester.pump();

    final fittedBox = tester.renderObject<RenderBox>(
      find.byType(FittedBox),
    );
    expect(fittedBox.size.width, 800);
    expect(fittedBox.size.height, 600);

    final canvasBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('game-canvas')),
    );
    expect(canvasBox.size.width, GameDimensions.playfieldWidth);
    expect(canvasBox.size.height, GameDimensions.playfieldHeight);
  });
}
