import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'database/database_helper.dart';
import 'database/seed_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.database;
  await DatabaseSeed.seed();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1400, 850),
    minimumSize: Size(1100, 700),
    center: true,
    title: "CREAFTON Financial Services",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const CreaftonApp());
}
