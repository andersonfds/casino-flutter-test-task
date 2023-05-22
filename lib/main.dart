import 'package:casino_test/src/di/main_di_module.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'src/presentation/screens/character_screen.dart';

void main() {
  MainDIModule().configure(GetIt.I);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: CharactersScreen(),
    );
  }
}
