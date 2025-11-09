import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_invaders/game/constants.dart';
import 'package:flutter_invaders/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('title screen shows instructions and transitions on SPACE', (
    tester,
  ) async {
    await tester.pumpWidget(const SpaceInvadersApp());
    expect(find.text('SPACE INVADERS'), findsOneWidget);
    expect(find.text('PRESS SPACE TO START'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.text('PRESS SPACE TO START'), findsNothing);
  });

  testWidgets('title screen text is visible within canvas bounds', (
    tester,
  ) async {
    await tester.pumpWidget(const SpaceInvadersApp());

    final canvas = tester.renderObject(
      find.byKey(const Key('game-canvas')),
    ) as RenderBox;
    expect(canvas.size.width, GameDimensions.playfieldWidth);
    expect(canvas.size.height, GameDimensions.playfieldHeight);

    final title = tester.renderObject(
      find.text('SPACE INVADERS'),
    ) as RenderBox;
    final titleOffset = title.localToGlobal(Offset.zero, ancestor: canvas);
    expect(titleOffset.dx, greaterThanOrEqualTo(0));
    expect(titleOffset.dy, greaterThanOrEqualTo(0));
    expect(
      titleOffset.dx + title.size.width,
      lessThanOrEqualTo(canvas.size.width),
    );
    expect(
      titleOffset.dy + title.size.height,
      lessThanOrEqualTo(canvas.size.height),
    );

    final subtitle = tester.renderObject(
      find.text('PRESS SPACE TO START'),
    ) as RenderBox;
    final subtitleOffset =
        subtitle.localToGlobal(Offset.zero, ancestor: canvas);
    expect(subtitleOffset.dx, greaterThanOrEqualTo(0));
    expect(subtitleOffset.dy, greaterThanOrEqualTo(0));
    expect(
      subtitleOffset.dx + subtitle.size.width,
      lessThanOrEqualTo(canvas.size.width),
    );
    expect(
      subtitleOffset.dy + subtitle.size.height,
      lessThanOrEqualTo(canvas.size.height),
    );
  });

  testWidgets('title screen is centered horizontally', (tester) async {
    await tester.pumpWidget(const SpaceInvadersApp());

    final canvas = tester.renderObject(
      find.byKey(const Key('game-canvas')),
    ) as RenderBox;
    final title = tester.renderObject(
      find.text('SPACE INVADERS'),
    ) as RenderBox;
    final titleOffset = title.localToGlobal(Offset.zero, ancestor: canvas);

    final expectedCenterX = (canvas.size.width - title.size.width) / 2;
    expect(titleOffset.dx, closeTo(expectedCenterX, 1.0));
  });
}
