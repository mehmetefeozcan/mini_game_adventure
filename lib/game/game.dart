import 'package:mini_game_adventure/game/core/helpers/hive_controller.dart';
import 'package:mini_game_adventure/game/manager/game_manager.dart';
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
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;

  List<String> levelNames = [];
  int currentLevelIndex = 0;

  GameManager gameManager = GameManager();
  HiveController hiveController = HiveController();

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
      await hiveController.updateLevel(currentLevelIndex + 1);
    }

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
    }
  }

  Future _loadLevel() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: size.x,
        height: size.y,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      await addAll([world, cam]);
    });
  }

  void goEpisodes() {
    gameManager.state = GameState.episode;

    overlays.remove('home');
    overlays.add('episode');
  }

  void goSettings() {
    gameManager.state = GameState.settings;

    overlays.remove('home');
    overlays.add('settings');
  }

  Future play() async {
    gameManager.state = GameState.game;

    removeWhere((component) => component is Level);

    await _loadLevel();

    overlays.remove('home');
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

  void quit() {
    gameManager.state = GameState.game;
    removeWhere((component) => component is Level);
    overlays.removeAll(['pause', 'game']);
    overlays.add('home');
    resumeEngine();
  }

  Future playCustomEpisode(int episode) async {
    gameManager.state = GameState.game;

    removeWhere((component) => component is Level);

    currentLevelIndex = episode - 1;
    await _loadLevel();

    overlays.remove('episode');
    overlays.add('game');
  }
}
