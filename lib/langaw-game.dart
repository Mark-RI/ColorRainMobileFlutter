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
import 'package:langaw/shoptext.dart';
import 'package:langaw/magnet.dart';
import 'package:langaw/shield.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:langaw/heart.dart';
import 'package:langaw/swords.dart';
import 'package:langaw/rupee.dart';
import 'package:langaw/arrows.dart';
import 'package:langaw/eagle.dart';
import 'package:langaw/armor.dart';
import 'package:langaw/beanstalk.dart';
import 'package:langaw/homebutton.dart';
import 'package:langaw/back_button.dart';
import 'package:langaw/heart-pixel.dart';
import 'package:langaw/render_power.dart';

class LangawGame extends Game {
  Back back;
  Beanstalk beanstalk;
  Eagle eagle;
  Armor armor;
  Arrows arrows;
  Rupee rupee;
  Swords swords;
  int increasegems = 1;
  Magnet magnet;
  Shield shield;
  Heart heart;
  HighscoreDisplay highscoreDisplay;
  GemsDisplay gemsdisplay;
//  List<HeartPixel> heart_pixel;
  List<Powers> power_up;
  List<ShoppingView> shoppingView;
  ShopDisplay shopDisplay;
  Shop shop;
  final SharedPreferences storage;
  final SharedPreferences gemsstorage;
  final SharedPreferences gemsTrue;
  final SharedPreferences magnetTrue;
  final SharedPreferences heartTrue;
  final SharedPreferences shieldTrue;
  final SharedPreferences arrowsTrue;
  final SharedPreferences swordsTrue;
  final SharedPreferences armorTrue;
  final SharedPreferences vineTrue;
  final SharedPreferences eagleTrue;
  View activeView;
  StartButton startButton;
  HomeButton homeButton;
  LostView lostView;
  HomeView homeView;
  Size screenSize;
  double tileSize;
  double btileSize;
  double raintileSize;
  Fly fly;
  int homeamountRain = 15;
  int amountRain = 1;
  int temAmountRain = 0;
  List<Rain> rains;
  List<Rain> homerains;
  int score;
  ScoreDisplay scoreDisplay;
  bool buy;
  int counter;
  bool magnet_bought = false;
  bool shield_bought = false;
  bool heart_bought = false;
  bool swords_bought = false;
  bool rupee_bought = false;
  bool arrows_bought = false;
  bool armor_bought = false;
  bool eagle_bought = false;
  bool beanstalk_bought = false;
  List powers = [];
  var power;
  double powerx;
  bool heart_pixel_add = false;
  bool heart_add = true;
  bool firstFree = true;
  bool secondFree = true;
  bool thirdFree = true;
  bool swordActive = false;
  bool smallActive = false;
  bool shieldActive = false;
  bool eagleActive = false;
  bool magnetActive = false;
  bool arrowsActive = false;
  bool magnetSaved;
  bool heartSaved;
  bool shieldSaved;
  bool arrowsSaved;
  bool swordsSaved;
  bool armorSaved;
  bool vineSaved;
  bool eagleSaved;
  double m;
  double c;
//  int next_heart;

  LangawGame(this.storage, this.gemsstorage, this.magnetTrue, this.gemsTrue, this.heartTrue, this.shieldTrue, this.arrowsTrue, this.swordsTrue, this.armorTrue, this.vineTrue, this.eagleTrue) {
    initialize();
  }

  void initialize() async {
    shoppingView = List<ShoppingView>();
    power_up = List<Powers>();
    homerains = List<Rain>();
    rains = List<Rain>();
//    heart_pixel = List<HeartPixel>();
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
    homeButton = HomeButton(this);
    shopDisplay = ShopDisplay(this);
    shop = Shop(this);
    back = Back(this);
    loadShop();
    if(magnetTrue.getBool('magnet') == null){
      magnetTrue.setBool('magnet', false);
    }
    if(magnetTrue.getBool('magnet') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'magnet') {
          shoppingview.bought = true;
          powers.add('magnet-blast.png');
          magnet_bought = true;
          magnet = Magnet(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(shieldTrue.getBool('shield') == null){
      shieldTrue.setBool('shield', false);
    }
    if(shieldTrue.getBool('shield') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'shield') {
          shoppingview.bought = true;
          powers.add('slashed-shield.png');
          shield_bought = true;
          shield = Shield(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(heartTrue.getBool('heart') == null){
      heartTrue.setBool('heart', false);
    }
    if(heartTrue.getBool('heart') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'heart') {
          shoppingview.bought = true;
          heart_pixel_add = true;
          fly.extra_live = true;
          heart_bought = true;
          heart = Heart(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(swordsTrue.getBool('swords') == null){
      swordsTrue.setBool('swords', false);
    }
    if(swordsTrue.getBool('swords') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'swords') {
          shoppingview.bought = true;
          powers.add('all-for-one.png');
          swords_bought = true;
          swords = Swords(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(gemsTrue.getBool('rupee') == null){
      gemsTrue.setBool('rupee', false);
    }
    if(gemsTrue.getBool('rupee') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'rupee') {
          shoppingview.bought = true;
          increasegems = 2;
          rupee_bought = true;
          rupee = Rupee(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(arrowsTrue.getBool('arrows') == null){
      arrowsTrue.setBool('arrows', false);
    }
    if(arrowsTrue.getBool('arrows') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'arrows') {
          shoppingview.bought = true;
          powers.add('charged-arrow.png');
          arrows_bought = true;
          arrows = Arrows(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(armorTrue.getBool('armor') == null){
      armorTrue.setBool('armor', false);
    }
    if(armorTrue.getBool('armor') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'armor') {
          shoppingview.bought = true;
          powers.add('chest-armor.png');
          armor_bought = true;
          armor = Armor(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(eagleTrue.getBool('eagle') == null){
      eagleTrue.setBool('eagle', false);
    }
    if(eagleTrue.getBool('eagle') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'eagle') {
          shoppingview.bought = true;
          powers.add('eagle-emblem.png');
          eagle_bought = true;
          eagle = Eagle(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
    if(vineTrue.getBool('beanstalk') == null){
      vineTrue.setBool('beanstalk', false);
    }
    if(vineTrue.getBool('beanstalk') == true){
      shoppingView.forEach((ShoppingView shoppingview){
        if (shoppingview.power == 'beanstalk') {
          shoppingview.bought = true;
          beanstalk_bought = true;
          beanstalk = Beanstalk(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
    }
  }


  void loadShop() {
    shoppingView.add(ShoppingView(this, 0, 0.5, 200, 1.9, 3.9, '200', 'shield'));
    shoppingView.add(ShoppingView(this, 2.5, 0.5, 200, 4.4, 3.9, '200', 'heart'));
    shoppingView.add(ShoppingView(this, 5, 0.5, 200, 6.9, 3.9, '200', 'rupee'));
    shoppingView.add(ShoppingView(this, 0, 4, 200, 1.9, 8.34, '200', 'arrows'));
    shoppingView.add(ShoppingView(this, 2.5, 4, 200, 4.4, 8.34, '200', 'swords'));
    shoppingView.add(ShoppingView(this, 5, 4, 200, 6.9, 8.34, '200', 'armor'));
    shoppingView.add(ShoppingView(this, 0, 7.5, 200, 1.9, 12.75, '200', 'beanstalk'));
    shoppingView.add(ShoppingView(this, 2.5, 7.5, 200, 4.4, 12.75, '200', 'magnet'));
    shoppingView.add(ShoppingView(this, 5, 7.5, 200, 6.9, 12.75, '200', 'eagle'));
  }

//  void loadHeartPixel() {
//    next_heart = 1;
//    heart_pixel.add(HeartPixel(this, 3.6, 1, 2));
//    heart_pixel.add(HeartPixel(this, 4.4, 1, 3));
//    heart_pixel.add(HeartPixel(this, 5.2, 1, 4));
//    heart_add = false;
//  }

//  void loadExtraHeart() {
//   next_heart = 0;
//    heart_pixel.add(HeartPixel(this, 2.8, 1, 1));
//    heart_pixel_add = false;
//  }

  void spawnFly() {
    fly = Fly(this, (screenSize.width - tileSize) / 2,
        screenSize.height - (btileSize * 2) - (tileSize / 8));
  }

  void spawnRain() {
    if(arrowsActive == false) {
      if (activeView == View.playing) if (amountRain > rains.length) {
        rains.add(Rain(this));
        power_up.forEach((Powers power) {
          if (power.active) {
            power.raincount += 1;
          }
        });
      }
    }else{
      temAmountRain = 5;
      if (activeView == View.playing) if (temAmountRain < rains.length) {
        rains.removeLast();
      }
      if(temAmountRain > rains.length){
        rains.add(Rain(this));
        power_up.forEach((Powers power) {
          if (power.active) {
            power.raincount += 1;
          }
        });
      }
    }
    if (activeView == View.home || activeView == View.lost)
      if (homeamountRain > homerains.length) {
        homerains.add(Rain(this));
      }
  }

  void render(Canvas canvas) {
    print("Magnet :");
    print(magnetTrue.getBool('magnet'));
    print("Shield :");
    print(shieldTrue.getBool('shield'));
    print("Heart :");
    print(heartTrue.getBool('heart'));
    print("Swords :");
    print(swordsTrue.getBool('swords'));
    print("Rupee :");
    print(gemsTrue.getBool('rupee'));
    print("Arrows :");
    print(arrowsTrue.getBool('arrows'));
    print("Armor :");
    print(armorTrue.getBool('armor'));
    print("Eagle :");
    print(eagleTrue.getBool('eagle'));
    print("Vine :");
    print(vineTrue.getBool('beanstalk'));
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height); // L and T are coordinates
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff1e1e1e); // Fuel Town from FlatUIColors.com be careful as some color can be harmful
    canvas.drawRect(bgRect, bgPaint); // Canvas needs a size and a color
    Rect lowerRect = Rect.fromLTWH(0, screenSize.height - (tileSize * 2.5), screenSize.width, tileSize * 2.5);
    Paint lowerPaint = Paint();
    lowerPaint.color = Color(0xff151515);
    if (activeView == View.playing) canvas.drawRect(lowerRect, lowerPaint);
    spawnRain();
//    if (heart_add == true && activeView == View.playing) loadHeartPixel();
//    if (heart_pixel_add == true && activeView == View.playing) loadExtraHeart();
//    print(next_heart);
    if (activeView == View.playing) rains.forEach((Rain rain) => rain.render(canvas));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((Rain rain) => rain.render(canvas));
    if (activeView == View.playing) fly.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.shopping) gemsdisplay.render(canvas);
    if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingview) => shoppingview.render(canvas));
    if (activeView == View.lost) highscoreDisplay.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
    if (activeView == View.lost) {
      homeButton.render(canvas);
    }
    if (activeView == View.home) shop.render(canvas);
    if (activeView == View.shopping) shopDisplay.render(canvas);
    if (activeView == View.shopping && magnet_bought == true) magnet.render(canvas);
    if (activeView == View.shopping && shield_bought == true) shield.render(canvas);
    if (activeView == View.shopping && heart_bought == true) heart.render(canvas);
    if (activeView == View.shopping && swords_bought == true) swords.render(canvas);
    if (activeView == View.shopping && rupee_bought == true) rupee.render(canvas);
    if (activeView == View.shopping && arrows_bought == true) arrows.render(canvas);
    if (activeView == View.shopping && armor_bought == true) armor.render(canvas);
    if (activeView == View.shopping && eagle_bought == true) eagle.render(canvas);
    if (activeView == View.shopping && beanstalk_bought == true) beanstalk.render(canvas);
    if (activeView == View.shopping) back.render(canvas);
    if (activeView == View.playing) power_up.forEach((Powers powers) => powers.render(canvas));
//    if (activeView == View.playing) heart_pixel.forEach((HeartPixel heartPixel) => heartPixel.render(canvas));
    }

  void update(double t) {
    if (activeView == View.playing) fly.update(t);
    if (activeView == View.playing) rains.forEach((Rain rain) => rain.update(t));
    if (activeView == View.home || activeView == View.lost) homerains.forEach((Rain rain) => rain.update(t));
    if (activeView == View.playing) rains.forEach((Rain rain) {
      if(magnetActive){
        if (rain.rainColor == rain.colorGreen && rain.y > fly.y - (tileSize) - raintileSize && fly.x + (tileSize * 2) > rain.x && fly.x - (tileSize * 2) < rain.x + raintileSize){
          /*
          rain.xCenter = rain.x + (raintileSize / 2);
          rain.yCenter = rain.y + (raintileSize / 2);
          fly.xCenter = fly.x + (tileSize / 2);
          fly.yCenter = fly.y + (tileSize / 2);
          m = (fly.yCenter - rain.yCenter)/(fly.xCenter - rain.xCenter);
          c = ((rain.xCenter * fly.yCenter) - (rain.yCenter * fly.xCenter)) / (rain.xCenter - fly.xCenter);
          fly.x = (fly.y - c)/m;
          **/
          amountRain += 1;
          score += 1;
          if (score > (storage.getInt('highscore') ?? 0)) {
            storage.setInt('highscore', score);
            highscoreDisplay.updateHighscore();
          }
          counter = (gemsstorage.getInt('gems') ?? 0) + increasegems;
          gemsstorage.setInt('gems', counter);
          gemsdisplay.updateGems();

          rain.onScreen = false;
        }
      }
      if (rain.rainColor == rain.colorWhite && rain.y > fly.y + tileSize - raintileSize && rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x) {
        if(firstFree){
          powerx = 0;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 1));
          firstFree = false;
        }else if(secondFree){
          powerx = 2.5;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 2));
          secondFree = false;
        }else if(thirdFree){
          powerx = 5;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 3));
          thirdFree = false;
        }

      }
      if (rain.rainColor == rain.colorGreen && rain.y > fly.y + tileSize - raintileSize && rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x) {
        amountRain += 1;
        score += 1;
        if (score > (storage.getInt('highscore') ?? 0)) {
          storage.setInt('highscore', score);
          highscoreDisplay.updateHighscore();
        }
        counter = (gemsstorage.getInt('gems') ?? 0) + increasegems;
        gemsstorage.setInt('gems', counter);
        gemsdisplay.updateGems();
      }
      if (rain.rainColor == rain.colorRed || rain.rainColor == rain.colorBlue || rain.rainColor == rain.colorYellow) {
        if (rain.y > fly.y + tileSize - raintileSize &&
            rain.x + raintileSize > fly.x && tileSize + fly.x > rain.x) {
          fly.isUp = true;
//          next_heart += 1;
//          heart_pixel.forEach((HeartPixel heartPixel) {
//           if(heartPixel.pos == next_heart){
//              heartPixel.live_lost = true;
            }
//          });
        }
//      }
    });
    if (activeView == View.playing) scoreDisplay.update(t);
    if (activeView == View.home) homeView.update(t);
    if (activeView == View.lost) lostView.update(t);
    if (activeView == View.shopping) shopDisplay.update(t);
    if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingview) => shoppingview.update());
//    if (activeView == View.playing) heart_pixel.forEach((HeartPixel heartPixel) => heartPixel.update());
    if (activeView == View.playing) power_up.forEach((Powers power) => power.eliminate());
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
      if (homeButton.rect.contains(d.globalPosition)) {
        lostView.onTapDownHome();
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

    if(activeView == View.shopping) {
      if (back.rect.contains(d.globalPosition)) {
        back.onTapDown();
      }
    }

    if (activeView == View.playing) {
      Offset pos = d.globalPosition;
      double pos_x = pos.dx;
      double pos_y = pos.dy;
      if (fly.x < pos_x && pos_y < screenSize.height - (tileSize * 2.5)) {
        fly.isLeft = false;
        fly.isRight = true;
      };
      if (fly.x > pos_x && pos_y < screenSize.height - (tileSize * 2.5)) {
        fly.isLeft = true;
        fly.isRight = false;
      };
    }
  }

  void onTapUp(TapUpDetails d) {
    fly.isRight = false;
    fly.isLeft = false;

    if (activeView == View.shopping) shoppingView.forEach((ShoppingView shoppingview){
      counter = (gemsstorage.getInt('gems'));

      if ((shoppingview.rect.contains(d.globalPosition) && buy == true && shoppingview.price <= counter) ){
        counter = (gemsstorage.getInt('gems') ?? 0) - shoppingview.price;
        gemsstorage.setInt('gems', counter);
        gemsdisplay.updateGems();
        shoppingview.bought = true;
        if (shoppingview.power == 'magnet'){
          powers.add('magnet-blast.png');
          magnet_bought = true;
          magnet = Magnet(this, shoppingview.x, shoppingview.y);
          magnetTrue.setBool('magnet', true);
        }
        if (shoppingview.power == 'shield'){
          powers.add('slashed-shield.png');
          shield_bought = true;
          shield = Shield(this, shoppingview.x, shoppingview.y);
          shieldTrue.setBool('shield', true);
        }
        if (shoppingview.power == 'heart'){
          heart_pixel_add = true;
          fly.extra_live = true;
          heart_bought = true;
          heart = Heart(this, shoppingview.x, shoppingview.y);
          heartTrue.setBool('heart', true);
        }
        if (shoppingview.power == 'swords'){
          powers.add('all-for-one.png');
          swords_bought = true;
          swords = Swords(this, shoppingview.x, shoppingview.y);
          swordsTrue.setBool('swords', true);
        }
        if (shoppingview.power == 'rupee'){
          increasegems = 2;
          rupee_bought = true;
          rupee = Rupee(this, shoppingview.x, shoppingview.y);
          gemsTrue.setBool('rupee', true);
        }
        if (shoppingview.power == 'arrows'){
          powers.add('charged-arrow.png');
          arrows_bought = true;
          arrows = Arrows(this, shoppingview.x, shoppingview.y);
          arrowsTrue.setBool('arrows', true);
        }
        if (shoppingview.power == 'armor'){
          powers.add('chest-armor.png');
          armor_bought = true;
          armor = Armor(this, shoppingview.x, shoppingview.y);
          armorTrue.setBool('armor', true);
        }
        if (shoppingview.power == 'eagle'){
          powers.add('eagle-emblem.png');
          eagle_bought = true;
          eagle = Eagle(this, shoppingview.x, shoppingview.y);
          eagleTrue.setBool('eagle', true);
        }
        if (shoppingview.power == 'beanstalk'){
          beanstalk_bought = true;
          beanstalk = Beanstalk(this, shoppingview.x, shoppingview.y);
          vineTrue.setBool('beanstalk', true);
        }
        shoppingView.removeWhere((ShoppingView shoppingview) => (shoppingview.bought == true));
      }
    });

    if(activeView == View.playing){
      power_up.forEach((Powers power){
        if(power.rect.contains(d.globalPosition)){
          power.active = true;
        }
      });
    }
  }
}