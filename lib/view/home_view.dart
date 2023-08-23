import 'package:flutter/material.dart';
import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';

class HomeView extends StatefulWidget {
  final MyGame game;
  const HomeView({super.key, required this.game});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                widget.game.play();
                setState(() {});
              },
              child: Container(
                width: context.width * 0.2,
                height: context.height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Text("Oyna"),
                ),
              ),
            ),
            SizedBox(height: context.highValue),
            InkWell(
              onTap: () {
                widget.game.goEpisodeView();
                setState(() {});
              },
              child: Container(
                width: context.width * 0.2,
                height: context.height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Text("Bölümler"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
