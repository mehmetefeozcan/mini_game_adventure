import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/game.dart';

class Fan extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double jumpSpeed;
  Fan({
    this.jumpSpeed = 100,
    position,
    size,
  }) : super(position: position, size: size);

  static const double fanSpeed = 0.2;

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
          size: Vector2(size.x, size.y + size.y / 6),
          position: Vector2(0, -(size.y / 6))),
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
