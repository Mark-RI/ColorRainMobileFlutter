import 'dart:ui';
import 'dart:io';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:langaw/view.dart';

class Shop {
  final LangawGame game;
  Rect rect;
  Sprite sprite;

  Shop(this.game) {
    rect = Rect.fromLTWH(
      (game.screenSize.width - game.tileSize) / 2,
      (game.screenSize.height * .75) - (game.tileSize * 1.75),
      game.tileSize,
      game.tileSize,
    );
    sprite = Sprite('tuts.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void onTapDown() {
    game.activeView = View.shopping;
//    sleep(const Duration(milliseconds:50));
  }
}