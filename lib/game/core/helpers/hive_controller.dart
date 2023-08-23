import 'package:hive_flutter/hive_flutter.dart';

class HiveController {
  final box = Hive.box('gameBox');

  // for first open
  Future<void> setFirstGameData() async {
    final data = {
      "lastLevel": 1,
    };

    final levels = [
      {"level": "level_01", "isUnlocked": true},
      {"level": "level_02", "isUnlocked": false},
      {"level": "level_03", "isUnlocked": false},
    ];

    await box.put('gameData', data);
    await box.put('levels', levels);
  }

  Future fetchGameData() async {
    final model = box.get('gameData');

    return model;
  }

  Future fetchLevels() async {
    final model = box.get('levels');

    return model;
  }

  updateLevel(int level) async {
    final gameData = box.get('gameData');
    if (gameData.lastLevel! < level) {
      final data = {
        "lastLevel": level,
      };

      List levels = box.get('levels');

      levels[level - 1].isUnlocked = true;

      await box.put("gameData", data);
      await box.put("levels", levels);
    }
  }
}
