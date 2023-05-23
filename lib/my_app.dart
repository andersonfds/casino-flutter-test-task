import 'package:casino_test/src/presentation/screens/character_list/character_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const blueRickAndMorty = Color(0xFF1AADCB);
const greenRickAndMorty = Color(0xFF00E001);

class MyApp extends StatelessWidget {
  const MyApp({
    this.showDebugBanner = true,
    Key? key,
  }) : super(key: key);

  final bool showDebugBanner;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app',
      scrollBehavior: CupertinoScrollBehavior(),
      debugShowCheckedModeBanner: showDebugBanner,
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
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: CharacterListScreen(),
    );
  }
}
