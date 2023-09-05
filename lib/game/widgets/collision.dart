// ignore_for_file: empty_constructor_bodies

import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {}
}
