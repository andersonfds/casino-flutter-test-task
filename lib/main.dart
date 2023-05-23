import 'package:casino_test/src/di/main_di_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'src/presentation/screens/character_screen.dart';

const blueRickAndMorty = Color(0xFF1AADCB);
const greenRickAndMorty = Color(0xFF00E001);

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
      scrollBehavior: CupertinoScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: greenRickAndMorty,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        splashColor: greenRickAndMorty.withOpacity(0.2),
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      ),
      home: CharactersScreen(),
    );
  }
}
