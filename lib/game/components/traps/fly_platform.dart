import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/game.dart';

class FlyPlatform extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final bool isVertical;
  final double offNeg;
  final double offPos;

  FlyPlatform({
    this.isVertical = false,
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

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

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
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }

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

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
