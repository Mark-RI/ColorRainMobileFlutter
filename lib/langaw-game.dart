import 'dart:ui'; // Used to access canvas and size
import 'package:flame/game.dart';// Game loop library
import 'package:flame/flame.dart';
import 'package:langaw/fly.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:langaw/button.dart';
import 'package:langaw/rain.dart';
import 'package:flame/util.dart';
import 'package:langaw/score-display.dart';
import 'package:langaw/view.dart';
import 'package:langaw/home-view.dart';
import 'package:langaw/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:langaw/highscore.dart';

class LangawGame extends Game {
  HighscoreDisplay highscoreDisplay;
  final SharedPreferences storage;
  View activeView;
  LostView lostView;
  HomeView homeView;
  Size screenSize;
  double tileSize;
  double btileSize;
  double raintileSize;
  Fly fly;
  int homeamountRain = 15;
  int amountRain = 1;
  List<Button> buttons;
  List<Rain> rains;
  List<Rain> homerains;
  int score;
  ScoreDisplay scoreDisplay;


  LangawGame(this.storage) {
    initialize();
  }

  void initialize() async {
    homerains = List<Rain>();
    rains = List<Rain>();
    buttons = List<Button>();
    resize(await Flame.util.initialDimensions());
    score = 0;
    scoreDisplay = ScoreDisplay(this);
    activeView = View.home;
    spawnButton();
    spawnFly();
    lostView = LostView(this);
    homeView = HomeView(this);
    highscoreDisplay = HighscoreDisplay(this);
  }

  void spawnButton(){
    buttons.add(Button(this, 0.2, false));
    buttons.add(Button(this, 0.8, true));
  }

  void spawnFly() {
    fly = new Fly(this, (screenSize.width - tileSize)/2, screenSize.height - (btileSize * 2) - (tileSize * 2));
  }

  void spawnRain(){
    if (activeView == View.playing) if(amountRain > rains.length) {
      rains.add(Rain(this));
    }
    if (activeView == View.home || activeView == View.lost) if(homeamountRain > homerains.length){
      homerains.add(Rain(this));
    }
  }

  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);// L and T are coordinates
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff576574);// Fuel Town from FlatUIColors.com be careful as some color can be harmful
    canvas.drawRect(bgRect, bgPaint);// Canvas needs a size and a color
    spawnRain();
    if (activeView == View.playing) rains.forEach((Rain rain) => rain.render(canvas));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((Rain rain) => rain.render(canvas));
    if (activeView == View.playing) buttons.forEach((Button button) => button.render(canvas));
    if (activeView == View.playing) fly.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.lost) highscoreDisplay.render(canvas);
  }

  void update(double t) {
    if (activeView == View.playing) fly.update(t);
    if (activeView == View.playing) rains.forEach((Rain rain) => rain.update(t));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((Rain rain) => rain.update(t));
    if (activeView == View.playing) buttons.forEach((Button button) => button.update(t));
    if (activeView == View.playing) rains.forEach((Rain rain){
      if (rain.rainColor == rain.colorGreen && rain.y > fly.y + tileSize - raintileSize && rain.x >= fly.x && rain.x + raintileSize < (fly.x + tileSize)){
        amountRain += 1;
        score += 1;
        if (score > (storage.getInt('highscore') ?? 0)) {
          storage.setInt('highscore', score);
          highscoreDisplay.updateHighscore();
        }
      }
      if (rain.rainColor == rain.colorRed || rain.rainColor == rain.colorBlue || rain.rainColor == rain.colorYellow){
        if (rain.y > fly.y + tileSize - raintileSize && rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x){
          fly.isUp = true;
      }
    }
    });
    if (activeView == View.playing) scoreDisplay.update(t);
    if (activeView == View.home) homeView.update(t);
    if (activeView == View.lost) lostView.update(t);
}

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    btileSize = screenSize.width / 5;
    raintileSize = screenSize.width / 18;
  }

  void onTapDown(TapDownDetails d) {

    if (activeView == View.lost){
      lostView.onTapDown();
    }

    if (activeView == View.home){
      homeView.onTapDown();
    }

    buttons.forEach((Button button) {
      if (button.buttonRect.contains(d.globalPosition)) {
        bool dir_right = button.onTapDown();
        buttons.forEach((Button button) => button.changeColor = true);
        if(dir_right == true){
          fly.isLeft = false;
          fly.isRight = true;
          buttons.forEach((Button button) => button.isLeft = false);
          buttons.forEach((Button button) => button.isRight = true);
        }
        if(dir_right == false) {
          fly.isRight = false;
          fly.isLeft = true;
          buttons.forEach((Button button) => button.isLeft = true);
          buttons.forEach((Button button) => button.isRight = false);
        }
      }
    });
  }

  void onTapUp(TapUpDetails d) {
    buttons.forEach((Button button) {
      if (button.buttonRect.contains(d.globalPosition)) {
        buttons.forEach((Button button) => button.onTapUp());
        buttons.forEach((Button button) => button.changeColor = false);
        fly.isRight = false;
        fly.isLeft = false;
      }
    });
  }
}