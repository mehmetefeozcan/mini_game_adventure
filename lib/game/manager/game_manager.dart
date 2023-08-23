import 'package:mini_game_adventure/game/game.dart';
import 'package:flame/components.dart';

enum GameState { home, game, pause, episode }

class GameManager extends Component with HasGameRef<MyGame> {
  GameManager();

  GameState state = GameState.home;

  bool get isHome => state == GameState.home;
  bool get isGame => state == GameState.game;
  bool get isEpisode => state == GameState.episode;
}
