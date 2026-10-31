import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:hw_1_1/app.dart';
import 'package:hw_1_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GameCatalogApp());
}
