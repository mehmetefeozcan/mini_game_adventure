import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game_adventure/game/core/helpers/custom_hitbox.dart';
import 'package:mini_game_adventure/game/game.dart';

class Spike extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Spike({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 6,
    width: 16,
    height: 10,
  );

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Spikes/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }
}
