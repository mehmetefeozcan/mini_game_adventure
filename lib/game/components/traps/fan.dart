import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/game.dart';

class Fan extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double jumpSpeed;
  final double fanSpeed;
  Fan({
    this.jumpSpeed = 100,
    this.fanSpeed = 0.2,
    position,
    size,
  }) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
          size: Vector2(size.x, size.y + size.y / 4),
          position: Vector2(0, -(size.y / 2))),
    );

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Fan/On (24x8).png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: fanSpeed,
          textureSize: Vector2(24, 8),
        ));

    return super.onLoad();
  }
}
