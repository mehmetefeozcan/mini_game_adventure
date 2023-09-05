import 'package:mini_game_adventure/game/core/extension/context_extension.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final MyGame game;
  const SettingsView({super.key, required this.game});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ayarlar",
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: context.highValue),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
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
