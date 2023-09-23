import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/core/helpers/hive_controller.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class EpisodesView extends StatefulWidget {
  final MyGame game;

  const EpisodesView({super.key, required this.game});

  @override
  State<EpisodesView> createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  HiveController hiveController = HiveController();
  late List levels;
  bool isLoading = false;

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  Future<void> _onInit() async {
    isLoading = true;
    levels = await hiveController.fetchLevels();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.game.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
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
                              Text("Bölümler",
                                  style: context.textTheme.headlineSmall),
                            ],
                          ),
                          SizedBox(height: context.highValue),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _episodes(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  List<Widget> _episodes() {
    List<Widget> episodes = [];

    for (var i = 0; i < levels.length; i += 2) {
      if (levels.length > i + 1) {
        episodes.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _episodeCard(context, i + 1, levels[i]['isUnlocked']),
              SizedBox(width: context.highValue),
              _episodeCard(context, i + 2, levels[i + 1]['isUnlocked']),
            ],
          ),
        );
      } else {
        episodes.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _episodeCard(context, i + 1, levels[i]['isUnlocked']),
              SizedBox(width: context.highValue),
              SizedBox(
                width: context.width * 0.06,
                height: context.height * 0.1,
              )
            ],
          ),
        );
      }
      // vertical space
      if (i != levels.length) {
        episodes.add(SizedBox(height: context.mediumValue));
      }
    }
    setState(() {});
    return episodes;
  }

  Widget _episodeCard(BuildContext context, int episode, bool isUnlocked) {
    return InkWell(
      onTap: () {
        if (isUnlocked) {
          widget.game.playCustomEpisode(episode);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.zero,
        width: context.width * 0.06,
        height: context.height * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                "$episode",
                style: context.textTheme.titleLarge,
              ),
            ),
            isUnlocked
                ? const SizedBox()
                : Center(
                    child: Icon(
                      Icons.lock_outline,
                      weight: 700,
                      size: 32,
                      color: Colors.redAccent.withOpacity(0.6),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
