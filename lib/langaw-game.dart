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
import 'package:langaw/circle.dart';
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
import 'package:langaw/tuts.dart';
import 'package:langaw/tap.dart';
import 'package:langaw/image.dart';
import 'package:langaw/credits.dart';
import 'package:flare_flutter/flare_actor.dart';

class LangawGame extends Game {
  Tap tap;
//  Circle circle;
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
  List<Powers> power_up;
  List<ShoppingView> shoppingView;
  ShopDisplay shopDisplay;
  ShopDisplay tutsDisplay;
  ShopDisplay gemDisplay;
  ShopDisplay whiteDisplay;
  ShopDisplay powerDisplay;
  ShopDisplay warningDisplay;
  ShopDisplay creditsDisplay;
  ShopDisplay getGreen;
  ShopDisplay getGreen2;
  ShopDisplay getGreen3;
  Shop shop;
  Images gemGrab;
  Tuts tuts;
  Credits credits;
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
  final SharedPreferences tutorialDone;
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
  int temAmountRain = 5;
  List<Rain> rains;
  List<Rain> homerains;
  List<Circle> circle;
  int score;
  ScoreDisplay scoreDisplay;
  bool buy;
  bool goOn;
  int counter;
  bool notHome = false;
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
  bool tut;
  bool whiteObtained = false;
  bool greentext = false;
  bool greentext2 = false;
  bool poweractive = false;
  bool reduceRain = false;
  bool noRain = false;
  bool tapRDone = false;
  bool tapLDone = false;
  String text;
  String subtext;

  LangawGame(this.storage, this.gemsstorage, this.magnetTrue, this.gemsTrue,
      this.heartTrue, this.shieldTrue, this.arrowsTrue, this.swordsTrue,
      this.armorTrue, this.vineTrue, this.eagleTrue, this.tutorialDone) {
    initialize();
  }

  void initialize() async {
    shoppingView = List<ShoppingView>();
    power_up = List<Powers>();
    homerains = List<Rain>();
    circle = List<Circle>();
    rains = List<Rain>();
    resize(await Flame.util.initialDimensions());
    score = 0;
    scoreDisplay = ScoreDisplay(this);
    activeView = View.home;
    spawnFly();
    spawnCircle();
//    circle = Circle(this);
    lostView = LostView(this);
    homeView = HomeView(this);
    highscoreDisplay = HighscoreDisplay(this);
    gemsdisplay = GemsDisplay(this);
    startButton = StartButton(this);
    homeButton = HomeButton(this);
    tutsDisplay = ShopDisplay(this, 30, 0xffffffff);
    gemDisplay = ShopDisplay(this, 24, 0xffffffff);
    whiteDisplay = ShopDisplay(this, 24, 0xffffffff);
    getGreen = ShopDisplay(this, 20, 0xff979797);
    getGreen2 = ShopDisplay(this, 20, 0xff979797);
    getGreen3 = ShopDisplay(this, 20, 0xff979797);
    shopDisplay = ShopDisplay(this, 30, 0xffffffff);
    powerDisplay = ShopDisplay(this, 24, 0xffffffff);
    warningDisplay = ShopDisplay(this, 24, 0xffffffff);
    creditsDisplay = ShopDisplay(this, 30, 0xffffffff);
    gemGrab = Images(this, 'gem.png', 1.7, 5.25, 6, 10.66662);
    tap = Tap();
    credits = Credits(this);
    shop = Shop(this);
    tuts = Tuts(this);
    back = Back(this);
    loadShop();
    if (tutorialDone.getBool('tut') == null || tutorialDone.getBool('tut') == false) {
      tutorialDone.setBool('tut', false);
      tut = false;
    }
    if (tutorialDone.getBool('tut') == true){
      tutorialDone.setBool('tut', true);
      tut = true;
    }
    if (magnetTrue.getBool('magnet') == null) {
      magnetTrue.setBool('magnet', false);
    }
    if (magnetTrue.getBool('magnet') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'magnet') {
          shoppingview.bought = true;
          powers.add('magnet-blast.png');
          magnet_bought = true;
          magnet = Magnet(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (shieldTrue.getBool('shield') == null) {
      shieldTrue.setBool('shield', false);
    }
    if (shieldTrue.getBool('shield') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'shield') {
          shoppingview.bought = true;
          powers.add('slashed-shield.png');
          shield_bought = true;
          shield = Shield(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (heartTrue.getBool('heart') == null) {
      heartTrue.setBool('heart', false);
    }
    if (heartTrue.getBool('heart') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'heart') {
          shoppingview.bought = true;
          heart_pixel_add = true;
          fly.extra_live = true;
          heart_bought = true;
          heart = Heart(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (swordsTrue.getBool('swords') == null) {
      swordsTrue.setBool('swords', false);
    }
    if (swordsTrue.getBool('swords') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'swords') {
          shoppingview.bought = true;
          powers.add('all-for-one.png');
          swords_bought = true;
          swords = Swords(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (gemsTrue.getBool('rupee') == null) {
      gemsTrue.setBool('rupee', false);
    }
    if (gemsTrue.getBool('rupee') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'rupee') {
          shoppingview.bought = true;
          increasegems = 2;
          rupee_bought = true;
          rupee = Rupee(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (arrowsTrue.getBool('arrows') == null) {
      arrowsTrue.setBool('arrows', false);
    }
    if (arrowsTrue.getBool('arrows') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'arrows') {
          shoppingview.bought = true;
          powers.add('charged-arrow.png');
          arrows_bought = true;
          arrows = Arrows(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (armorTrue.getBool('armor') == null) {
      armorTrue.setBool('armor', false);
    }
    if (armorTrue.getBool('armor') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'armor') {
          shoppingview.bought = true;
          powers.add('chest-armor.png');
          armor_bought = true;
          armor = Armor(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (eagleTrue.getBool('eagle') == null) {
      eagleTrue.setBool('eagle', false);
    }
    if (eagleTrue.getBool('eagle') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'eagle') {
          shoppingview.bought = true;
          powers.add('eagle-emblem.png');
          eagle_bought = true;
          eagle = Eagle(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
    if (vineTrue.getBool('beanstalk') == null) {
      vineTrue.setBool('beanstalk', false);
    }
    if (vineTrue.getBool('beanstalk') == true) {
      shoppingView.forEach((ShoppingView shoppingview) {
        if (shoppingview.power == 'beanstalk') {
          shoppingview.bought = true;
          beanstalk_bought = true;
          beanstalk = Beanstalk(this, shoppingview.x, shoppingview.y);
        }
      });
      shoppingView.removeWhere((ShoppingView shoppingview) =>
      (shoppingview.bought == true));
    }
  }

  void loadShop() {
    shoppingView.add(ShoppingView(
        this,
        0,
        0.5,
        200,
        1.9,
        3.9,
        '200',
        'shield'));
    shoppingView.add(ShoppingView(
        this,
        2.5,
        0.5,
        200,
        4.4,
        3.9,
        '200',
        'heart'));
    shoppingView.add(ShoppingView(
        this,
        5,
        0.5,
        200,
        6.9,
        3.9,
        '200',
        'rupee'));
    shoppingView.add(ShoppingView(
        this,
        0,
        4,
        200,
        1.9,
        8.34,
        '200',
        'arrows'));
    shoppingView.add(ShoppingView(
        this,
        2.5,
        4,
        200,
        4.4,
        8.34,
        '200',
        'swords'));
    shoppingView.add(ShoppingView(
        this,
        5,
        4,
        200,
        6.9,
        8.34,
        '200',
        'armor'));
    shoppingView.add(ShoppingView(
        this,
        0,
        7.5,
        200,
        1.9,
        12.75,
        '200',
        'beanstalk'));
    shoppingView.add(ShoppingView(
        this,
        2.5,
        7.5,
        200,
        4.4,
        12.75,
        '200',
        'magnet'));
    shoppingView.add(ShoppingView(
        this,
        5,
        7.5,
        200,
        6.9,
        12.75,
        '200',
        'eagle'));
  }

  void spawnCircle(){
    circle.add(Circle(this));
  }

  void spawnFly() {
    fly = Fly(this, (screenSize.width - tileSize) / 2,
        screenSize.height - (btileSize * 2) - (tileSize / 8));
  }

  void spawnRain() {
    notHome = true;
    if (arrowsActive == false || reduceRain == false || noRain == false) {
      if (activeView == View.playing) if (amountRain > rains.length) {
        rains.add(Rain(this));
        power_up.forEach((Powers power) {
          if (power.active) {
            power.raincount += 1;
          }
        });
      }
    }
    if (arrowsActive || reduceRain || noRain) {
      if(noRain){
        temAmountRain = 0;
      }
      else if(reduceRain){
        temAmountRain = 1;
      }else{
        temAmountRain = 5;
      }
      if (activeView == View.playing) if (temAmountRain < rains.length) {
        rains.removeLast();
      }
      if (temAmountRain > rains.length) {
        rains.add(Rain(this));
        power_up.forEach((Powers power) {
          if (power.active) {
            power.raincount += 1;
          }
        });
      }
    }
    if (activeView == View.home || activeView == View.lost || activeView == View.credits)
      if (homeamountRain > homerains.length) {
        notHome = false;
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
    Rect lowerRect = Rect.fromLTWH(
        0, screenSize.height - (tileSize * 2.5), screenSize.width,
        tileSize * 2.5);
    Paint lowerPaint = Paint();
    lowerPaint.color = Color(0xff151515);
    if (activeView == View.playing) canvas.drawRect(lowerRect, lowerPaint);
    spawnRain();
    if (activeView == View.playing) rains.forEach((Rain rain) =>
        rain.render(canvas));
    if (activeView == View.home || activeView == View.lost || activeView == View.credits) homerains.forEach((
        Rain rain) => rain.render(canvas));
    if (activeView == View.playing) fly.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.shopping) gemsdisplay
        .render(canvas);
    if (activeView == View.shopping) shoppingView.forEach((
        ShoppingView shoppingview) => shoppingview.render(canvas));
    if (activeView == View.lost) highscoreDisplay.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
    if (activeView == View.lost) {
      homeButton.render(canvas);
    }
    if (activeView == View.home) shop.render(canvas);
    if (activeView == View.home) credits.render(canvas);
    if (activeView == View.home) tuts.render(canvas);
    if (activeView == View.shopping) shopDisplay.render(canvas);
    if (activeView == View.tuts) {
      tutsDisplay.render(canvas);
      gemDisplay.render(canvas);
      whiteDisplay.render(canvas);
      powerDisplay.render(canvas);
      warningDisplay.render(canvas);
      gemGrab.render(canvas);
    }
    if (greentext) getGreen.render(canvas);
    if (greentext) getGreen2.render(canvas);
    if (activeView == View.credits) creditsDisplay.render(canvas);
    if (activeView == View.shopping && magnet_bought == true) magnet.render(
        canvas);
    if (activeView == View.shopping && shield_bought == true) shield.render(
        canvas);
    if (activeView == View.shopping && heart_bought == true) heart.render(
        canvas);
    if (activeView == View.shopping && swords_bought == true) swords.render(
        canvas);
    if (activeView == View.shopping && rupee_bought == true) rupee.render(
        canvas);
    if (activeView == View.shopping && arrows_bought == true) arrows.render(
        canvas);
    if (activeView == View.shopping && armor_bought == true) armor.render(
        canvas);
    if (activeView == View.shopping && eagle_bought == true) eagle.render(
        canvas);
    if (activeView == View.shopping && beanstalk_bought == true) beanstalk
        .render(canvas);
    if (activeView == View.shopping || activeView == View.tuts ||
        activeView == View.credits) back.render(canvas);
    if (activeView == View.playing) power_up.forEach((Powers powers) =>
        powers.render(canvas));
    if (activeView == View.playing) circle.forEach((Circle circle) =>
        circle.render(canvas));
  }

  void update(double t) {
    if (activeView == View.playing) fly.update(t);
    if (activeView == View.playing) {
      circle.removeWhere((Circle circle) => (tapRDone && tapLDone));
      rains.forEach((Rain rain) => rain.update(t));
      rains.removeWhere((Rain rain) => (rain.onScreen == false));
    }
    if (activeView == View.home || activeView == View.lost || activeView == View.credits) {
      homerains.forEach((Rain rain) => rain.update(t));
      homerains.removeWhere((Rain rain) => (rain.onScreen == false));
    }
    if (activeView == View.playing) rains.forEach((Rain rain) {
      if (magnetActive) {
        if (rain.rainColor == rain.colorGreen &&
            rain.y > fly.y - (tileSize) - raintileSize &&
            fly.x + (tileSize * 2) > rain.x &&
            fly.x - (tileSize * 2) < rain.x + raintileSize) {
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
      if (rain.rainColor == rain.colorWhite && rain.y > fly.y + tileSize - raintileSize && rain.x + raintileSize > fly.x && fly.width + fly.x > rain.x) {
        if(tut == false && whiteObtained == false){
          whiteObtained = true;
          powerx = 2.5;
          power = 'chest-armor.png';
          power_up.add(Powers(this, powerx, 10, power, 1));
          firstFree = false;
        }
        if (firstFree) {
          powerx = 0;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 1));
          firstFree = false;
        } else if (secondFree) {
          powerx = 2.5;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 2));
          secondFree = false;
        } else if (thirdFree) {
          powerx = 5;
          power = randomChoice(powers);
          power_up.add(Powers(this, powerx, 10, power, 3));
          thirdFree = false;
        }
      }
      if (rain.rainColor == rain.colorGreen &&
          rain.y > fly.y + tileSize - raintileSize &&
          rain.x + raintileSize > fly.x && fly.width + fly.x > rain.x) {
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
      if (rain.rainColor == rain.colorRed || rain.rainColor == rain.colorBlue ||
          rain.rainColor == rain.colorYellow) {
        if (rain.y > fly.y + tileSize - raintileSize &&
            rain.x + raintileSize > fly.x && fly.width + fly.x > rain.x) {
          fly.isUp = true;
        }
      }
    });
    if (activeView == View.playing) scoreDisplay.update(t);
    if (activeView == View.home) homeView.update(t);
    if (activeView == View.lost) lostView.update(t);
    if (activeView == View.shopping) shopDisplay.update('SHOP', 2, 0.25);
    if (activeView == View.tuts) {
      tutsDisplay.update('HOW TO PLAY', 1.7, 0.25);
      gemDisplay.update('Green increases gems and score.', 1, 1.5);
      whiteDisplay.update('Obtain powers with white.', 1.85, 2.5);
      powerDisplay.update('Unlock power at the store.', 1.8, 3.5);
      warningDisplay.update('Avoid all other colors.', 1.7, 4.5);
    }
    if (activeView == View.credits) creditsDisplay.update('CREDITS', 1.9, 0.25);
    if (activeView == View.shopping) shoppingView.forEach((
        ShoppingView shoppingview) => shoppingview.update());
    if (activeView == View.playing) power_up.forEach((Powers power) =>
        power.eliminate());
    if (activeView == View.playing) power_up.removeWhere((
        Powers power) => (power.remove == true));
    if (greentext) getGreen.update(text, 1.9, 9);
    if (greentext) getGreen2.update(subtext, 1.9, 9.5);
//    if (greentext2) getGreen3.update('Get green', 1.9, 9);
    if (activeView == View.playing) circle.forEach((Circle circle) =>
        circle.update(t));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    btileSize = screenSize.width / 5;
    raintileSize = screenSize.width / 18;
  }

  void onTapDown(TapDownDetails d) {
    buy = true;
    goOn = true;

    if (activeView == View.home) {
      if (tuts.rect.contains(d.globalPosition)) {
        if (goOn) {
          tuts.onTapDown();
        }
      }
      if (shop.rect.contains(d.globalPosition)) {
        if (goOn) {
          shop.onTapDown();
          buy = false;
        }
      }
      if (credits.rect.contains(d.globalPosition)) {
        if (goOn) {
          credits.onTapDown();
        }
      }
    }

    if (activeView == View.shopping) {
      if (back.rect.contains(d.globalPosition)) {
        back.onTapDown();
      }
    }

    if (activeView == View.tuts) {
      if (back.rect.contains(d.globalPosition)) {
        back.onTapDown();
      }
    }

    if (activeView == View.credits) {
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

    if(activeView == View.home){
    if (startButton.rect.contains(d.globalPosition)) {
        homeView.onTapDown();
      }
    }
    if (activeView == View.lost) {
      if (startButton.rect.contains(d.globalPosition) && goOn == true) {
        lostView.onTapDown();
      }
      if (homeButton.rect.contains(d.globalPosition) && goOn == true) {
        lostView.onTapDownHome();
      }
    }

    if (activeView == View.shopping) shoppingView.forEach((
        ShoppingView shoppingview) {
      counter = (gemsstorage.getInt('gems'));

      if ((shoppingview.rect.contains(d.globalPosition) && buy == true &&
          shoppingview.price <= counter)) {
        counter = (gemsstorage.getInt('gems') ?? 0) - shoppingview.price;
        gemsstorage.setInt('gems', counter);
        gemsdisplay.updateGems();
        shoppingview.bought = true;
        if (shoppingview.power == 'magnet') {
          powers.add('magnet-blast.png');
          magnet_bought = true;
          magnet = Magnet(this, shoppingview.x, shoppingview.y);
          magnetTrue.setBool('magnet', true);
        }
        if (shoppingview.power == 'shield') {
          powers.add('slashed-shield.png');
          shield_bought = true;
          shield = Shield(this, shoppingview.x, shoppingview.y);
          shieldTrue.setBool('shield', true);
        }
        if (shoppingview.power == 'heart') {
          heart_pixel_add = true;
          fly.extra_live = true;
          heart_bought = true;
          heart = Heart(this, shoppingview.x, shoppingview.y);
          heartTrue.setBool('heart', true);
        }
        if (shoppingview.power == 'swords') {
          powers.add('all-for-one.png');
          swords_bought = true;
          swords = Swords(this, shoppingview.x, shoppingview.y);
          swordsTrue.setBool('swords', true);
        }
        if (shoppingview.power == 'rupee') {
          increasegems = 2;
          rupee_bought = true;
          rupee = Rupee(this, shoppingview.x, shoppingview.y);
          gemsTrue.setBool('rupee', true);
        }
        if (shoppingview.power == 'arrows') {
          powers.add('charged-arrow.png');
          arrows_bought = true;
          arrows = Arrows(this, shoppingview.x, shoppingview.y);
          arrowsTrue.setBool('arrows', true);
        }
        if (shoppingview.power == 'armor') {
          powers.add('chest-armor.png');
          armor_bought = true;
          armor = Armor(this, shoppingview.x, shoppingview.y);
          armorTrue.setBool('armor', true);
        }
        if (shoppingview.power == 'eagle') {
          powers.add('eagle-emblem.png');
          eagle_bought = true;
          eagle = Eagle(this, shoppingview.x, shoppingview.y);
          eagleTrue.setBool('eagle', true);
        }
        if (shoppingview.power == 'beanstalk') {
          beanstalk_bought = true;
          beanstalk = Beanstalk(this, shoppingview.x, shoppingview.y);
          vineTrue.setBool('beanstalk', true);
        }
        shoppingView.removeWhere((ShoppingView shoppingview) =>
        (shoppingview.bought == true));
      }
    });

    if (activeView == View.playing) {
      power_up.forEach((Powers power) {
        if (power.rect.contains(d.globalPosition)) {
          power.active = true;
          poweractive = true;
        }
      });
    }
  }

  onTapCancel() {
    fly.isLeft = false;
    fly.isRight = false;
  }
}