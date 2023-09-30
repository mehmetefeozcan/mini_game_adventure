import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

enum GameState { home, game, pause, episode, settings, gameOver }

class GameManager extends Component with HasGameRef<MyGame> {
  GameManager();

  GameState state = GameState.home;

  bool get isHome => state == GameState.home;
  bool get isGame => state == GameState.game;
  bool get isEpisode => state == GameState.episode;
  bool get isSettings => state == GameState.settings;
  bool get isGameOver => state == GameState.gameOver;

  ValueNotifier<int> health = ValueNotifier(2);
}
