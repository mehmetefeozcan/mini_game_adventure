import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mini_game_adventure/game/game.dart';

class JumpButton extends SpriteComponent
    with HasGameReference<MyGame>, TapCallbacks {
  JumpButton();

  final double margin = 32;
  final double buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    priority = 10;
    _updatePosition(game.size);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updatePosition(size);
  }

  void _updatePosition(Vector2 size) {
    if (size.x > 0 && size.y > 0) {
      position = Vector2(
        size.x - margin - buttonSize,
        size.y - margin - buttonSize,
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
