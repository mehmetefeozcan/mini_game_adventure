import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
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
            Image.asset(
              'assets/images/heart.png',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
