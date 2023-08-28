import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/game.dart';

class Trampoline extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double jumpSpeed;
  Trampoline({
    this.jumpSpeed = 100,
    position,
    size,
  }) : super(position: position, size: size);

  static const double trampolineSpeed = 0.2;

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(size.x, size.y / 2),
        position: Vector2(0, size.y / 2),
      ),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: trampolineSpeed,
        textureSize: Vector2(28, 28),
      ),
    );

    debugMode = true;
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/Jump (28x28).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: trampolineSpeed,
        textureSize: Vector2(28, 28),
      ),
    );
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: trampolineSpeed,
        textureSize: Vector2(28, 28),
      ),
    );
    super.onCollisionEnd(other);
  }
}
