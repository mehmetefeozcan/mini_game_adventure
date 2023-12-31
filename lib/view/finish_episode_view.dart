import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_adventure/main.dart';

class FinishEpisodeView extends StatefulWidget {
  final MyGame game;
  const FinishEpisodeView({super.key, required this.game});

  @override
  State<FinishEpisodeView> createState() => _FinishEpisodeViewState();
}

class _FinishEpisodeViewState extends State<FinishEpisodeView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: widget.game.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  episodeStar(context, game.star),
                  SizedBox(height: context.lowValue),
                  Text(
                    "Bölüm Geçildi!",
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: context.highValue),
                  _menuButton(
                    context,
                    "Sonraki Bölüm",
                    () {
                      widget.game.nextLevel();

                      setState(() {});
                    },
                  ),
                  SizedBox(height: context.mediumValue),
                  _menuButton(
                    context,
                    "Tekrar Oyna",
                    () {
                      widget.game.restart();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: context.mediumValue),
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

  Widget episodeStar(BuildContext context, int starLevel) {
    List<Widget> stars = [];

    for (var i = 1; i <= 3; i++) {
      bool isAmber = starLevel >= i;
      stars.add(
        Icon(Icons.star, color: isAmber ? Colors.amber : Colors.grey, size: 32),
      );
      stars.add(SizedBox(width: context.lowValue));
    }
    stars.removeAt(5);

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}
