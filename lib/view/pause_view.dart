import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class PauseView extends StatefulWidget {
  final MyGame game;

  const PauseView({super.key, required this.game});

  @override
  State<PauseView> createState() => _PauseViewState();
}

class _PauseViewState extends State<PauseView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.5),
      child: SizedBox(
        width: context.width,
        height: context.height,
        child: Center(
          child: widget.game.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _menuButton(
                      context,
                      "Devam Et",
                      () {
                        widget.game.resume();
                        setState(() {});
                      },
                    ),
                    /* SizedBox(height: context.highValue),
              _menuButton(
                context,
                "Ayarlar",
                () {
                  widget.game.goEpisodes();
                  setState(() {});
                },
              ), */
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
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, void Function() func) {
    return InkWell(
      onTap: func,
      child: Text(
        title,
        style: context.textTheme.headlineSmall,
      ),
    );
  }
}
