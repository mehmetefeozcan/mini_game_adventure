import 'package:mini_game_adventure/game/core/helpers/custom_hitbox.dart';
import 'package:mini_game_adventure/game/core/helpers/utils.dart';
import 'package:mini_game_adventure/game/widgets/collision.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:async';

enum BeeState { idle, hit, attack, appearing, disappearing }

class Bee extends SpriteAnimationGroupComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Bee({position}) : super(position: position);

  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation attackAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  final double _stepTime = 0.14;
  final double _jumpForce = 240;

  bool gotHit = false;
  bool isOnGround = false;
  bool hasJumped = false;
  bool isFaceRight = true;

  double moveSpeed = 20;
  double horizontalMovement = 0;
  Vector2 velocity = Vector2.zero();
  Vector2 startingPosition = Vector2.zero();

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  late BeeBullet bullet;
  Vector2 bulletPos = Vector2(0, 0);

  int bulletCount = 0;

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
    //debugMode = true;

    return super.onLoad();
  }

  @override
  void update(double dt) async {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void _loadAllAnimations() async {
    idleAnimation = _spriteAnimation('Idle', 6);
    attackAnimation = _spriteAnimation('Attack', 8);
    hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    // List of all Animations
    animations = {
      BeeState.hit: hitAnimation,
      BeeState.idle: idleAnimation,
      BeeState.attack: attackAnimation,
      BeeState.appearing: appearingAnimation,
      BeeState.disappearing: disappearingAnimation,
    };

    // Set Current Animation
    current = BeeState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Bee/$state (36x34).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2(36, 34),
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

  Future _updatePlayerState() async {
    bullet = BeeBullet(position: bulletPos);

    if (bulletCount == 0) {
      if (gameRef.player.position.x - 200 <= position.x &&
          gameRef.player.position.x + 200 >= position.x) {
        await gameRef.add(bullet);
        bulletCount = 1;
      }
    } else if (bulletCount == 1) {
      if (gameRef.isBeeBulletHit) {
        bulletCount = 0;
      }
    }

    current = BeeState.idle;
  }

  Future _delayAndFlip(double movement) async {
    velocity.x = 0;
    horizontalMovement = 0;
    await Future.delayed(const Duration(milliseconds: 1000));

    flipHorizontallyAroundCenter();

    horizontalMovement = movement;
  }
}

class BeeBullet extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  BeeBullet({position}) : super(position: position);

  final double _gravity = 2;
  final double _jumpForce = 240;
  final double _terminalVelocity = 300;

  bool gotHit = false;
  bool isOnGround = false;

  double moveSpeed = 20;
  double horizontalMovement = 0;
  Vector2 velocity = Vector2.zero();

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 18,
    height: 18,
  );

  @override
  FutureOr<void> onLoad() {
    _load();

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
    collisionBlocks = gameRef.player.collisionBlocks;

    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit) {
        _applyGravity(dt);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void _load() async {
    sprite = Sprite(gameRef.images.fromCache('Enemies/Bee/Bullet.png'));
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

    if (isOnGround) {
      gameRef.isBeeBulletHit = true;

      gameRef.remove(this);
    } else {
      gameRef.isBeeBulletHit = false;
    }
  }

  removeBullet() {
    gameRef.isBeeBulletHit = true;
    gameRef.remove(this);
  }
}
