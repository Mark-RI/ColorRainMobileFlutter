import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:flutter/painting.dart';
import 'package:langaw/view.dart';
import 'package:langaw/rain.dart';

class ShoppingView {
  final LangawGame game;
  Rect titleRect;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  Rect rect;
  Sprite sprite;
  double x;
  double y;
  int price;


  ShoppingView(this.game, this.x, this.y, this.price) {

    rect = Rect.fromLTWH(
      game.tileSize + (game.tileSize * x),
      game.tileSize + (game.tileSize * 1.263 * y),
      game.tileSize * 2.2,
      game.tileSize * 2.2 * 1.263,
    );
    sprite = Sprite('template shop.png');

    painter = TextPainter(textAlign: TextAlign.start, textDirection: TextDirection.ltr);

    textStyle = TextStyle(color: Color(0xffffffff), fontSize: 30);

    position = Offset.zero;

  }

  void render(Canvas c) {
    painter.paint(c, position);

    sprite.renderRect(c, rect);
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