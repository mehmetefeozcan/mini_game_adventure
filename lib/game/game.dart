import 'package:mini_game_adventure/game/core/helpers/hive_controller.dart';
import 'package:mini_game_adventure/game/manager/game_manager.dart';
import 'package:mini_game_adventure/game/widgets/collision.dart';
import 'package:mini_game_adventure/game/widgets/jump_button.dart';
import 'package:mini_game_adventure/game/components/player.dart';
import 'package:mini_game_adventure/game/level.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'dart:async';

class MyGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(character: 'Ninja Frog');

  late JoystickComponent joystick;
  late CameraComponent cam;

  @override
  bool isLoading = false;

  List<String> levelNames = [];
  int currentLevelIndex = 0;

  double centerDiffX = 0;
  double centerDiffY = 0;

  GameManager gameManager = GameManager();
  HiveController hiveController = HiveController();

  List<CollisionBlock> collisionBlocks = [];

  bool isInited = false;
  double maxWidth = 780;
  double maxHeight = 360;

  bool isBeeBulletHit = false;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    //_loadLevel();

    addJoystick();

    add(JumpButton());
    add(gameManager);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateJoystick();
    if (gameManager.isGame) {
      if (isInited) {
        cam.viewport.position = Vector2(-size.x / 2, 0);

        final screenMidX = cam.viewport.size.x / 2;
        centerDiffX = player.position.x - screenMidX;

        final screenMidY = cam.viewport.size.y / 1.2;
        centerDiffY = player.position.y - screenMidY;

        // Yatay Kamera Hareketi
        if (screenMidX < player.position.x &&
            player.position.x < maxWidth - screenMidX) {
          cam.viewport.position.x -= centerDiffX;
        } else if (player.position.x > maxWidth - screenMidX) {
          cam.viewport.position.x -= maxWidth - screenMidX * 2;
        }

        // Dikey Kamera Hareketi
        if (screenMidY < player.position.y) {
          cam.viewport.position.y -= centerDiffY;
        }
      }
    }

    if (gameManager.health.value == 0 && gameManager.isGame) {
      gameOver();
      return;
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() async {
    removeWhere((component) => component is Level);
    final lastLevel = await hiveController.fetchGameData();
    if (currentLevelIndex == lastLevel['lastLevel'] - 1) {
      await hiveController.updateLevel(currentLevelIndex + 1, this);
    }

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
    }
  }

  Future _loadLevel() async {
    isLoading = true;
    gameManager.health.value = 2;
    player.size = Vector2(34, 34);

    collisionBlocks = [];

    await Future.delayed(const Duration(seconds: 1), () async {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent(world: world);
      cam.viewfinder.anchor = Anchor.topCenter;

      await addAll([world, cam]);

      maxWidth = world.level.size.x;
      maxHeight = world.level.size.y;

      isInited = true;
      isLoading = false;
    });
  }

  void goEpisodes() {
    gameManager.state = GameState.episode;

    removeOverlays();
    overlays.add('episode');
  }

  void goSettings() {
    gameManager.state = GameState.settings;

    removeOverlays();
    overlays.add('settings');
  }

  Future play() async {
    gameManager.state = GameState.game;

    removeWhere((component) => component is Level);

    await _loadLevel();

    removeOverlays();
    overlays.add('game');
  }

  void pause() {
    gameManager.state = GameState.pause;

    overlays.add('pause');
    pauseEngine();
  }

  void resume() {
    gameManager.state = GameState.game;

    overlays.remove('pause');
    resumeEngine();
  }

  void restart() async {
    gameManager.health.value = 2;
    gameManager.state = GameState.game;
    resumeEngine();

    removeWhere((component) => component is Level);

    await _loadLevel();
    removeOverlays();
    overlays.add('game');
  }

  void gameOver() {
    gameManager.state = GameState.gameOver;

    removeOverlays();
    overlays.add('gameOver');
    pauseEngine();
  }

  void finishLevel() {
    const reachedCheckpointDuration = Duration(milliseconds: 500);
    Future.delayed(reachedCheckpointDuration, () {
      player.size = Vector2.zero();
      player.reachedCheckpoint = false;

      removeOverlays();
      overlays.add('finish');
    });
  }

  void nextLevel() {
    loadNextLevel();

    removeOverlays();
    overlays.add('game');
  }

  void quit() {
    gameManager.state = GameState.home;
    removeWhere((component) => component is Level);
    removeOverlays();
    overlays.add('home');
    resumeEngine();
  }

  Future playCustomEpisode(int episode) async {
    gameManager.state = GameState.game;

    removeWhere((component) => component is Level);

    currentLevelIndex = episode - 1;
    await _loadLevel();

    removeOverlays();
    overlays.add('game');
  }

  removeOverlays() => overlays.removeAll(
        [
          'home',
          'game',
          'episode',
          'pause',
          'settings',
          'gameOver',
          'finish',
        ],
      );
}
