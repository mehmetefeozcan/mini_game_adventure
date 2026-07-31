import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mini_game_adventure/game/core/helpers/hive_controller.dart';
import 'package:mini_game_adventure/game/game.dart';
import 'package:mini_game_adventure/view/home_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync('hive_test');
    Hive.init(tempDir.path);
    await Hive.openBox('gameBox');
    await HiveController().setFirstGameData();
  });

  testWidgets('HomeView displays menu buttons', (WidgetTester tester) async {
    final game = MyGame();
    await tester.pumpWidget(
      MaterialApp(
        home: HomeView(game: game),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Oyna'), findsOneWidget);
    expect(find.text('Bölümler'), findsOneWidget);
  });
}
