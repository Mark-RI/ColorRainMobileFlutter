import 'dart:ui'; // Used to access canvas and size
import 'package:flame/game.dart';// Game loop library
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:langaw/fly.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:langaw/rain.dart';
import 'package:flame/util.dart';
import 'package:langaw/score-display.dart';
import 'package:langaw/view.dart';
import 'package:langaw/home-view.dart';
import 'package:langaw/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:langaw/highscore.dart';
import 'package:langaw/gems.dart';
import 'package:langaw/shop.dart';
import 'package:langaw/start-button.dart';
import 'package:langaw/shopping.dart';
import 'package:langaw/price.dart';

class LangawGame extends Game {
  HighscoreDisplay highscoreDisplay;
  GemsDisplay gemsdisplay;
  List<ShoppingView> shoppingView;
  List<PriceDisplay> price;
  Shop shop;
  final SharedPreferences storage;
  final SharedPreferences gemsstorage;
  View activeView;
  StartButton startButton;
  LostView lostView;
  HomeView homeView;
  Size screenSize;
  double tileSize;
  double btileSize;
  double raintileSize;
  Fly fly;
  int homeamountRain = 15;
  int amountRain = 1;
  List<Rain> rains;
  List<Rain> homerains;
  int score;
  ScoreDisplay scoreDisplay;
  bool buy;
  int counter;


  LangawGame(this.storage, this.gemsstorage) {
    initialize();
  }

  void initialize() async {
    shoppingView = List<ShoppingView>();
    price = List<PriceDisplay>();
    homerains = List<Rain>();
    rains = List<Rain>();
    resize(await Flame.util.initialDimensions());
    score = 0;
    scoreDisplay = ScoreDisplay(this);
    activeView = View.home;
    spawnFly();
    lostView = LostView(this);
    homeView = HomeView(this);
    highscoreDisplay = HighscoreDisplay(this);
    gemsdisplay = GemsDisplay(this);
    startButton = StartButton(this);
    shop = Shop(this);
    loadShop();
  }

  void loadShop() {
      shoppingView.add(ShoppingView(this, 0, 0.5, 200));
      shoppingView.add(ShoppingView(this, 2.5, 0.5, 200));
      shoppingView.add(ShoppingView(this, 5, 0.5, 200));
      shoppingView.add(ShoppingView(this, 0, 4, 200));
      shoppingView.add(ShoppingView(this, 2.5, 4, 200));
      shoppingView.add(ShoppingView(this, 5, 4, 200));
      shoppingView.add(ShoppingView(this, 0, 7.5, 200));
      shoppingView.add(ShoppingView(this, 2.5, 7.5, 200));
      shoppingView.add(ShoppingView(this, 5, 7.5, 200));
      price.add(PriceDisplay(this, '200', 1.9, 3.9));
      price.add(PriceDisplay(this, '200', 4.4, 3.9));
      price.add(PriceDisplay(this, '200', 6.9, 3.9));
      price.add(PriceDisplay(this, '200', 1.9, 8.34));
      price.add(PriceDisplay(this, '200', 4.4, 8.34));
      price.add(PriceDisplay(this, '200', 6.9, 8.34));
      price.add(PriceDisplay(this, '200', 1.9, 12.75));
      price.add(PriceDisplay(this, '200', 4.4, 12.75));
      price.add(PriceDisplay(this, '200', 6.9, 12.75));
  }

  void spawnFly() {
    fly = Fly(this, (screenSize.width - tileSize) / 2,
        screenSize.height - (btileSize * 2) - (tileSize * 2));
  }

  void spawnRain() {
    if (activeView == View.playing) if (amountRain > rains.length) {
      rains.add(Rain(this));
    }
    if (activeView == View.home || activeView == View.lost)
      if (homeamountRain > homerains.length) {
        homerains.add(Rain(this));
      }
  }

  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(
        0, 0, screenSize.width, screenSize.height); // L and T are coordinates
    Paint bgPaint = Paint();
    bgPaint.color = Color(
        0xff1e1e1e); // Fuel Town from FlatUIColors.com be careful as some color can be harmful
    canvas.drawRect(bgRect, bgPaint); // Canvas needs a size and a color
    spawnRain();
    if (activeView == View.playing) rains.forEach((Rain rain) =>
        rain.render(canvas));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((
        Rain rain) => rain.render(canvas));
    if (activeView == View.playing) fly.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.shopping) gemsdisplay.render(canvas);
    if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingview) => shoppingview.render(canvas));
    if (activeView == View.shopping) price.forEach((PriceDisplay price) => price.render(canvas));
    if (activeView == View.lost) highscoreDisplay.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
    if (activeView == View.home) shop.render(canvas);
  }

  void update(double t) {
    if (activeView == View.playing) fly.update(t);
    if (activeView == View.playing) rains.forEach((Rain rain) =>
        rain.update(t));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((
        Rain rain) => rain.update(t));
    if (activeView == View.playing) rains.forEach((Rain rain) {
      if (rain.rainColor == rain.colorGreen &&
          rain.y > fly.y + tileSize - raintileSize &&
          rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x) {
        amountRain += 1;
        score += 1;
        if (score > (storage.getInt('highscore') ?? 0)) {
          storage.setInt('highscore', score);
          highscoreDisplay.updateHighscore();
        }
        counter = (gemsstorage.getInt('gems') ?? 0) + 1;
        gemsstorage.setInt('gems', counter);
        gemsdisplay.updateGems();
      }
      if (rain.rainColor == rain.colorRed || rain.rainColor == rain.colorBlue ||
          rain.rainColor == rain.colorYellow) {
        if (rain.y > fly.y + tileSize - raintileSize &&
            rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x) {
          fly.isUp = true;
        }
      }
    });
    if (activeView == View.playing) scoreDisplay.update(t);
    if (activeView == View.home) homeView.update(t);
    if (activeView == View.lost) lostView.update(t);
    if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingview) => shoppingview.update(t));
    if (activeView == View.shopping) price.forEach((PriceDisplay price) => price.update());
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    btileSize = screenSize.width / 5;
    raintileSize = screenSize.width / 18;
  }

  void onTapDown(TapDownDetails d) {
    buy = true;
    if (activeView == View.lost) {
      if (startButton.rect.contains(d.globalPosition)) {
        lostView.onTapDown();
      }
    }

    if (activeView == View.home) {
      if (shop.rect.contains(d.globalPosition)){
        shop.onTapDown();
        buy = false;
      }
      if (startButton.rect.contains(d.globalPosition)) {
        homeView.onTapDown();
      }
    }



    if (activeView == View.playing) {
      Offset pos = d.globalPosition;
      double pos_x = pos.dx;
      if (fly.x < pos_x) {
        fly.isLeft = false;
        fly.isRight = true;
      };
      if (fly.x > pos_x) {
        fly.isLeft = true;
        fly.isRight = false;
      };
    }
  }
    void onTapUp(TapUpDetails d) {
      fly.isRight = false;
      fly.isLeft = false;

      if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingView){
        counter = (gemsstorage.getInt('gems') ?? 0);
        if (shoppingView.rect.contains(d.globalPosition) && buy == true && shoppingView.price <= counter ){
          counter = (gemsstorage.getInt('gems') ?? 0) - shoppingView.price;
          gemsstorage.setInt('gems', counter);
          gemsdisplay.updateGems();
        }
      });
  }
}