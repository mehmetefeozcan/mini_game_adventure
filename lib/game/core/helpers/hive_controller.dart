import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_game_adventure/game/game.dart';

class HiveController {
  final box = Hive.box('gameBox');

  // for open game
  Future<void> setFirstGameData() async {
    final isDataSetted = box.get('gameData') != null;
    final isLevelsSetted = box.get('levels') != null;

    if (!isLevelsSetted && !isDataSetted) {
      final data = {
        "lastLevel": 1,
      };

      final levels = [
        {"level": "level_01", "isUnlocked": true},
        {"level": "level_02", "isUnlocked": false},
        {"level": "level_03", "isUnlocked": false},
        {"level": "level_04", "isUnlocked": false},
      ];

      await box.put('gameData', data);
      await box.put('levels', levels);
    }
  }

  Future fetchGameData() async {
    final model = box.get('gameData');

    return model;
  }

  Future fetchLevels() async {
    final model = box.get('levels');

    return model;
  }

  Future updateLevel(int level, MyGame game) async {
    try {
      final gameData = box.get('gameData');
      if (gameData['lastLevel']! == level) {
        final data = {
          "lastLevel": level + 1,
        };

        List levels = box.get('levels');

        levels[level]['isUnlocked'] = true;

        await box.put("gameData", data);
        await box.put("levels", levels);
      }
    } catch (e) {
      print("[Hive Controller] error: $e");
      game.quit();
    }
  }
}
