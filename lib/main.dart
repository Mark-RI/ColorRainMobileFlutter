import 'package:flutter/material.dart';
import 'package:flame/util.dart';// Can keep portrait, tells O.S to run full screen and no notification bar or buttons
import 'package:flutter/services.dart';// Gives access to device orientation
import 'package:langaw/langaw-game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:langaw/view.dart';
import 'package:langaw/home-view.dart';
import 'package:langaw/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  SharedPreferences storage = await SharedPreferences.getInstance();
  SharedPreferences gemsstorage = await SharedPreferences.getInstance();
  SharedPreferences magnetTrue = await SharedPreferences.getInstance();
  SharedPreferences gemsTrue = await SharedPreferences.getInstance();
  SharedPreferences heartTrue = await SharedPreferences.getInstance();
  SharedPreferences shieldTrue = await SharedPreferences.getInstance();
  SharedPreferences arrowsTrue = await SharedPreferences.getInstance();
  SharedPreferences swordsTrue = await SharedPreferences.getInstance();
  SharedPreferences armorTrue = await SharedPreferences.getInstance();
  SharedPreferences vineTrue = await SharedPreferences.getInstance();
  SharedPreferences eagleTrue = await SharedPreferences.getInstance();

  Flame.images.loadAll(<String>[
    'circle.png',
    'gem_9.png',
    'play.png',
    'shop.png',
    'templateshop.png',
    'magnet-blast.png',
    'slashed-shield.png',
    'hearts.png',
    'all-for-one.png',
    'rupee.png',
    'charged-arrow.png',
    'chest-armor.png',
    'eagle-emblem.png',
    'beanstalk.png',
    'back.png',
    'home.png',
    'heart-pixel.png',
    'heart-lost.png',
    'tuts.png',
    'gem.png',
    'credits.png',
  ]);

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  LangawGame game = LangawGame(storage, gemsstorage, magnetTrue, gemsTrue, heartTrue, shieldTrue, arrowsTrue, swordsTrue, armorTrue, vineTrue, eagleTrue);
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  tapper.onTapUp = game.onTapUp;
  tapper.onTapCancel = game.onTapCancel;
  flameUtil.addGestureRecognizer(tapper);
}