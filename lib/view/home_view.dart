import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/core/helpers/hive_controller.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final MyGame game;
  const HomeView({super.key, required this.game});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HiveController hiveController = HiveController();

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  Future<void> _onInit() async {
    // for Game Reset or First play
    //await hiveController.setFirstGameData();

    final gameData = await hiveController.fetchGameData();
    final levels = await hiveController.fetchLevels();

    for (var level in levels) {
      widget.game.levelNames.add(level['level']);
    }

    widget.game.currentLevelIndex = gameData['lastLevel'] - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton(context, "Oyna", () {
              widget.game.play();
              setState(() {});
            }),
            SizedBox(height: context.highValue),
            _menuButton(context, "Bölümler", () {
              widget.game.goEpisodes();
              setState(() {});
            }),
            /*  SizedBox(height: context.highValue),
            _menuButton(context, "Ayarlar", () {
              widget.game.goSettings();
              setState(() {});
            }), */
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, void Function() func) {
    return InkWell(
      onTap: func,
      child: Container(
        width: context.width * 0.2,
        height: context.height * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
