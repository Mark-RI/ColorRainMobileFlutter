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

  Flame.images.loadAll(<String>[
    'circle.png',
    'gem_9.png',
    'play.png',
    'shop.png',
    'templateshop.png',
    'magnet-blast.png'
  ]);

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  LangawGame game = LangawGame(storage, gemsstorage);
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
}