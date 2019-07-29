import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:flutter/painting.dart';
import 'package:langaw/view.dart';
import 'package:langaw/rain.dart';

class ShopDisplay {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ShopDisplay(this.game) {
    painter = TextPainter(textAlign: TextAlign.start, textDirection: TextDirection.ltr);

    textStyle = TextStyle(color: Color(0xffffffff), fontSize: 30);

    position = Offset.zero;

  }

  void render(Canvas c) {
    painter.paint(c, position);
  }


  void update(double t) {
    painter.text = TextSpan(
      text: ("SHOP"),
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.tileSize * .25),
    );
  }
}