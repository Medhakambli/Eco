
import 'package:flutter/material.dart';
import 'package:voice_assistant_app/pallete.dart';
import 'home_page.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Pallete.whiteColor,
          appBarTheme: AppBarTheme(color: Pallete.whiteColor )),
      home: HomePage(),
    );
  }
}
