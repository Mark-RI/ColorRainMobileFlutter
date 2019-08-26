import 'dart:ui';
import 'package:langaw/langaw-game.dart';// Access to screen size
import 'package:langaw/rain.dart';
import 'package:langaw/view.dart';
import 'package:flame/sprite.dart';
import 'dart:math' as math;
import 'package:langaw/render_power.dart';

class Circle{
  final LangawGame game;
  bool up = true;
  double x;
  double y;
  Paint paint = Paint();
  Color colorWhite = Color(0xffffffff);
  double opacity = 0.7;
  double size;
  double strokeWidth = 5;


  Circle(this.game) {
    x = game.tileSize;
    y = game.screenSize.height - (game.tileSize * 6);
    size = game.tileSize / 4;
    paint.color = colorWhite.withOpacity(opacity);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth;
  }

  void render(Canvas c) {
    c.drawCircle(Offset(x + (game.tileSize / 1.6), y + (game.tileSize / 2)), size, paint);
  }

  void update(double t) {
    if(size < game.tileSize / 2 && up){
      size += (t * 10);
    }
    if(size > game.tileSize / 2){
      up = false;
    }
    if(size > game.tileSize / 4 && up == false){
      size -= (t * 10);
    }
    if(size < game.tileSize / 4){
      up = true;
    }
    if(game.tapLDone && game.tapRDone == false){
      x = game.screenSize.width - (game.tileSize * 2);
    }
  }
}