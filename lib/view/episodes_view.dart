import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class EpisodesView extends StatefulWidget {
  final MyGame game;

  const EpisodesView({super.key, required this.game});

  @override
  State<EpisodesView> createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: context.highValue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bölümler", style: context.textTheme.titleLarge),
                  ],
                ),
                SizedBox(height: context.normalValue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _episodeCard(context, 1, true),
                    SizedBox(width: context.normalValue),
                    _episodeCard(context, 2, true),
                    SizedBox(width: context.normalValue),
                    _episodeCard(context, 3, true),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _episodeCard(BuildContext context, int episode, bool isUnlocked) {
    return InkWell(
      onTap: () {
        widget.game.playCustomEpisode(episode);
        setState(() {});
      },
      child: Container(
        width: context.width * 0.1,
        height: context.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            "$episode",
            style: context.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
