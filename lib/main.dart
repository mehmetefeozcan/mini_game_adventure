import 'package:mini_game_adventure/view/episodes_view.dart';
import 'package:mini_game_adventure/view/finish_episode_view.dart';
import 'package:mini_game_adventure/view/game_over_view.dart';
import 'package:mini_game_adventure/view/settings_view.dart';
import 'package:mini_game_adventure/view/pause_view.dart';
import 'package:mini_game_adventure/view/game_view.dart';
import 'package:mini_game_adventure/view/home_view.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('gameBox');

  runApp(const MyApp());
}

MyGame game = MyGame();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "MultiTypePixel"),
      home: GameWidget(
        game: game,
        overlayBuilderMap: <String, Widget Function(BuildContext, MyGame)>{
          'home': (context, game) => HomeView(game: game),
          'game': (context, game) => GameView(game: game),
          'episode': (context, game) => EpisodesView(game: game),
          'pause': (context, game) => PauseView(game: game),
          'settings': (context, game) => SettingsView(game: game),
          'gameOver': (context, game) => GameOverView(game: game),
          'finish': (context, game) => FinishEpisodeView(game: game),
        },
        initialActiveOverlays: const ['home'],
      ),
    );
  }
}
