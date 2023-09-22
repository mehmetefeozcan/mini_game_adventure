import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/game.dart';

class FallingPlatform extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double jumpSpeed;
  final double offNeg;
  final double offPos;
  FallingPlatform({
    this.jumpSpeed = 100,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(position: position, size: size);

  static const double sawSpeed = 0.1;
  static const moveSpeed = 20;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox());

    rangeNeg = position.y - offNeg * tileSize;
    rangePos = position.y + offPos * tileSize;

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Falling Platforms/On (32x10).png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: sawSpeed,
          textureSize: Vector2(32, 10),
        ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _moveVertically(dt);

    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }
}
