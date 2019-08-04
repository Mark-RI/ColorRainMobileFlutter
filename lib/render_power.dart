import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:langaw/view.dart';

class Powers {
  final LangawGame game;
  Rect rect;
  Rect rect_background;
  Sprite sprite;
  Sprite background;
  double x;
  double y;
  bool active = false;
  var power;
  int raincount = 0;
  int pos;

  Powers(this.game, this.x, this.y, this.power, this.pos) {
    rect = Rect.fromLTWH(
      game.tileSize + (game.tileSize * x) + ((game.tileSize * 2.2 - game.tileSize * 1.6)/ 2),
      game.tileSize + (game.tileSize * 1.263 * y) + ((game.tileSize * 2.2 - game.tileSize * 1.6)/ 2),
      game.tileSize * 1.6,
      game.tileSize * 1.6,
    );
    rect_background = Rect.fromLTWH(
      game.tileSize + (game.tileSize * x),
      game.tileSize + (game.tileSize * 1.263 * y),
      game.tileSize * 2.2,
      game.tileSize * 2.2,
    );
    sprite = Sprite(power);
    background = Sprite('circle.png');
  }

  void render(Canvas c) {
    background.renderRect(c, rect_background);
    sprite.renderRect(c, rect);
  }

  void eliminate(){
    if(active == true) {
      game.power_up.removeWhere((Powers power) => (power.raincount == 20));
      if(pos == 1){
        game.firstFree = true;
      }
      if(pos == 2){
        game.secondFree = true;
      }
      if(pos == 3){
        game.thirdFree = true;
      }
    }
  }
}