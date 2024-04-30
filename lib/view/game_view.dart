// ignore_for_file: unrelated_type_equality_checks

import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:mini_game_adventure/main.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  final MyGame game;

  const GameView({super.key, required this.game});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.highValue, vertical: context.highValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                widget.game.pause();
                setState(() {});
              },
              child: Icon(
                Icons.pause,
                color: Colors.grey.shade600,
              ),
            ),
            _health(context),
          ],
        ),
      ),
    );
  }

  Widget _health(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: game.gameManager.health,
      builder: (context, value, child) {
        List<Widget> items = [];

        for (var i = 0; i < game.gameManager.health.value; i++) {
          items.add(
            Image.asset(
              'assets/images/heart.png',
              width: 24,
              height: 24,
            ),
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: items,
        );
      },
    );
  }
}
