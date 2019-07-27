import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:langaw/langaw-game.dart';

class PriceDisplay {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  String price;
  double y;
  double x;

  PriceDisplay(this.game, this.price, this.x, this.y) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
        color: Color(0xffffffff),
        fontSize: 18
    );

    position = Offset.zero;

    update();
  }

  void update() {
    painter.text = TextSpan(
      text: '$price',
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      game.tileSize * x,
      game.tileSize * y,
    );
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }
}