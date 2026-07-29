import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_app.dart';

/// app launch entrypoint
void main() async {
  // ensure flutter bindings are correctly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // lock app orientation to portrait only (portraitUp and portraitDown)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // run main application root widget
  runApp(const MyApp());
}
