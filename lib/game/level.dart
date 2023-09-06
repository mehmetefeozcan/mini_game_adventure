import 'package:mini_game_adventure/game/components/king_pig.dart';
import 'package:mini_game_adventure/game/manager/game_manager.dart';
import 'package:mini_game_adventure/game/widgets/background_tile.dart';
import 'package:mini_game_adventure/game/widgets/collision.dart';
import 'package:mini_game_adventure/game/components/index.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';
import 'dart:async';

class Level extends World {
  late TiledComponent level;
  late String levelName;
  late Player player;

  Level({required this.player, required this.levelName});
  List<CollisionBlock> collisionBlocks = [];
  GameManager gameManager = GameManager();

  Pig pig = Pig(position: Vector2(0, 0));
  KingPig kingPig = KingPig(position: Vector2(0, 0));

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    _scrollingBackground();
    _addObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
      );
      add(backgroundTile);
    }
  }

  void _addObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;

          case 'Enemy':
            if (spawnPoint.name == 'Pig') {
              pig.position = Vector2(spawnPoint.x, spawnPoint.y);
              add(pig);
            } else if (spawnPoint.name == 'King Pig') {
              kingPig.position = Vector2(spawnPoint.x, spawnPoint.y);
              add(kingPig);
            }
            break;

          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;

          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;

          case 'Fan':
            final jumpSpeed = spawnPoint.properties.getValue('jumpSpeed');
            final fanSpeed = spawnPoint.properties.getValue('fanSpeed');
            final fan = Fan(
              jumpSpeed: jumpSpeed,
              fanSpeed: fanSpeed,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fan);
            break;

          case 'Trampoline':
            final jumpSpeed = spawnPoint.properties.getValue('jumpSpeed');
            final trampoline = Trampoline(
              jumpSpeed: jumpSpeed,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(trampoline);
            break;

          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    pig.collisionBlocks = collisionBlocks;
    kingPig.collisionBlocks = collisionBlocks;
  }
}
