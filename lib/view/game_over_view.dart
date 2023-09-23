import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class GameOverView extends StatefulWidget {
  final MyGame game;
  const GameOverView({super.key, required this.game});

  @override
  State<GameOverView> createState() => _GameOverViewState();
}

class _GameOverViewState extends State<GameOverView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: widget.game.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Oyunu Kaybettiniz!",
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: context.highValue),
                  _menuButton(
                    context,
                    "Tekrar Oyna",
                    () {
                      widget.game.restart();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: context.highValue),
                  _menuButton(
                    context,
                    "Çık",
                    () {
                      widget.game.quit();
                      setState(() {});
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, void Function() func) {
    return InkWell(
      onTap: func,
      child: Text(
        title,
        style: context.textTheme.titleLarge,
      ),
    );
  }
}
