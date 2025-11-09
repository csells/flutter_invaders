import 'package:flutter/material.dart';
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
    expect(canvasBox.size.height, closeTo(400, 0.1));
    expect(canvasBox.size.width, lessThan(800));
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
    expect(canvasBox.size.width, closeTo(400, 0.1));
    expect(canvasBox.size.height, lessThan(900));
  });
}
