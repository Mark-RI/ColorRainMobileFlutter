import 'dart:ui';
import 'package:langaw/langaw-game.dart';// Access to screen size
import 'package:langaw/rain.dart';
import 'package:langaw/view.dart';
// Rect instances are immutable. However its shift and translate methods can be used to move it.
class Fly {
  final LangawGame game;
  Rect flyRect;
  Paint flyPaint;
  bool isLeft = false;
  bool isRight = false;
  bool isUp = false;
  double x;
  double y;
  int pixel_pos = 0;

  Fly(this.game, this.x, this.y) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyPaint = Paint();
    flyPaint.color = Color(0xff6ab04c);
  }

  void render(Canvas c) {
    c.drawRect(flyRect, flyPaint);
  }

  void update(double t) {
    if (isLeft) {
      if (x >= game.tileSize){
        x += (game.tileSize * -7 * t);
        flyRect = flyRect.translate(game.tileSize * -7 * t, 0);
      }
    }
    if (isRight) {
      if (x <= game.screenSize.width - (game.tileSize * 2)){
        x += (game.tileSize * 7 * t);
        flyRect = flyRect.translate(game.tileSize * 7 * t, 0);
      }
    }
    if (isUp){
      if (pixel_pos < 3) {
        pixel_pos += 1;
        y += game.tileSize * -2;
        flyRect = flyRect.translate(0, game.tileSize * -2);
        isUp = false;
      }
      else{
        game.activeView = View.lost;
        game.rains = List<Rain>();
        game.amountRain = 1;
        pixel_pos = 0;
        isUp = false;
        isLeft = false;
        isRight = false;
        y += game.tileSize * 6;
        flyRect = flyRect.translate(0, game.tileSize * 6);

      }
    }
  }
}