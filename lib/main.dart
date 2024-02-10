import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'home_page.dart';
import 'palette.dart';

void main() async {
  await Hive.initFlutter();
  // ignore: unused_local_variable
  var box = await Hive.openBox('prepabox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.mainColor),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: "title",
              letterSpacing: 2.5),
          titleMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Rubik',
          ),
          titleSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Rubik',
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w200,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w200,
          ),
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          color: Palette.translColor,
          shadowColor: Palette.translColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
      ),
      home: const HomePage(),
    );
  }
}
