import 'package:mini_game_adventure/game/core/helpers/custom_hitbox.dart';
import 'package:mini_game_adventure/game/core/helpers/utils.dart';
import 'package:mini_game_adventure/game/widgets/collision.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:async';

enum KingPigState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing
}

class KingPig extends SpriteAnimationGroupComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  KingPig({
    position,
  }) : super(position: position);

  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  final double _stepTime = 0.08;
  final double _gravity = 9.8;
  final double _jumpForce = 240;
  final double _terminalVelocity = 300;

  bool gotHit = false;
  bool isOnGround = false;
  bool hasJumped = false;
  bool isFaceRight = true;

  double moveSpeed = 30;
  double horizontalMovement = -1;
  Vector2 velocity = Vector2.zero();
  Vector2 startingPosition = Vector2.zero();

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 11,
    offsetY: 8,
    width: 18,
    height: 20,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    startingPosition = Vector2(position.x, position.y);

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void _loadAllAnimations() async {
    idleAnimation = _spriteAnimation('Idle', 12);
    runningAnimation = _spriteAnimation('Run', 6);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 2)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    // List of all Animations
    animations = {
      KingPigState.idle: idleAnimation,
      KingPigState.running: runningAnimation,
      KingPigState.jumping: jumpingAnimation,
      KingPigState.falling: fallingAnimation,
      KingPigState.hit: hitAnimation,
      KingPigState.appearing: appearingAnimation,
      KingPigState.disappearing: disappearingAnimation,
    };

    // Set Current Animation
    current = KingPigState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/King Pig/$state (38x28).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2(38, 28),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            _delayAndFlip(-1);
            position.x -= 6;

            break;
          }
          if (velocity.x < 0) {
            _delayAndFlip(1);
            position.x += 6;

            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _updatePlayerState() {
    KingPigState playerState = KingPigState.idle;

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = KingPigState.running;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = KingPigState.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = KingPigState.jumping;

    current = playerState;
  }

  Future _delayAndFlip(double movement) async {
    velocity.x = 0;
    horizontalMovement = 0;
    await Future.delayed(const Duration(milliseconds: 1000));

    flipHorizontallyAroundCenter();

    horizontalMovement = movement;
  }
}
