import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:flutter/painting.dart';
import 'package:langaw/view.dart';
import 'package:langaw/rain.dart';

class HomeView {
  final LangawGame game;
  Rect titleRect;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HomeView(this.game) {
    painter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    textStyle = TextStyle(color: Color(0xffffffff), fontSize: 60);

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }


  void update(double t) {
    painter.text = TextSpan(
      text: ("COLOR RAIN"),
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * .5) - (painter.height),
    );
  }
  void onTapDown() {
//    game.score = 0;
    game.homerains = List<Rain>();
    game.activeView = View.playing;
  }
}