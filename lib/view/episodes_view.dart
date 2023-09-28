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
                              Text(
                                "Bölümler",
                                style: context.textTheme.headlineSmall,
                              ),
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

    for (var i = 0; i < levels.length; i += 5) {
      if (levels.length > i + 4) {
        episodes.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _episodeCard(
                context,
                i + 1,
                levels[i]['isUnlocked'],
                levels[i]['star'],
              ),
              SizedBox(width: context.highValue),
              _episodeCard(
                context,
                i + 2,
                levels[i + 1]['isUnlocked'],
                levels[i + 1]['star'],
              ),
              SizedBox(width: context.highValue),
              _episodeCard(
                context,
                i + 3,
                levels[i + 2]['isUnlocked'],
                levels[i + 2]['star'],
              ),
              SizedBox(width: context.highValue),
              _episodeCard(
                context,
                i + 4,
                levels[i + 3]['isUnlocked'],
                levels[i + 3]['star'],
              ),
              SizedBox(width: context.highValue),
              _episodeCard(
                context,
                i + 5,
                levels[i + 4]['isUnlocked'],
                levels[i + 4]['star'],
              ),
            ],
          ),
        );
      } else {
        episodes.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _episodeCard(
                context,
                i + 1,
                levels[i]['isUnlocked'],
                levels[i]['star'],
              ),
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

  Widget _episodeCard(
      BuildContext context, int episode, bool isUnlocked, int star) {
    return InkWell(
      onTap: () {
        if (isUnlocked) {
          widget.game.playCustomEpisode(episode);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.zero,
        width: context.width * 0.1,
        height: context.height * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "$episode",
                    style: context.textTheme.titleLarge,
                  ),
                  episodeStar(context, star),
                ],
              ),
            ),
            isUnlocked
                ? const SizedBox()
                : Center(
                    child: Icon(
                      Icons.lock_outline,
                      weight: 700,
                      size: 36,
                      color: Colors.redAccent.withOpacity(0.6),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget episodeStar(BuildContext context, int starLevel) {
    List<Widget> stars = [];

    for (var i = 1; i <= 3; i++) {
      bool isAmber = starLevel >= i;
      stars.add(
        Icon(Icons.star, color: isAmber ? Colors.amber : Colors.grey, size: 16),
      );
      stars.add(SizedBox(width: context.lowValue));
    }
    stars.removeAt(5);

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}


/* const Icon(Icons.star, color: Colors.amber, size: 16),
      SizedBox(width: context.lowValue),
      const Icon(Icons.star, color: Colors.amber, size: 16),
      SizedBox(width: context.lowValue),
      const Icon(Icons.star, color: Colors.grey, size: 16), */