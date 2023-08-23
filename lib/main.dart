import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:mini_game_adventure/view/episodes_view.dart';
import 'package:mini_game_adventure/view/game_view.dart';
import 'package:mini_game_adventure/view/home_view.dart';
import 'package:mini_game_adventure/view/pause_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  MyGame game = MyGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: <String, Widget Function(BuildContext, MyGame)>{
        'home': (context, game) => HomeView(game: game),
        'game': (context, game) => GameView(game: game),
        'episode': (context, game) => EpisodesView(game: game),
        'pause': (context, game) => PauseView(game: game),
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}
