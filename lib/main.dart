import 'package:flutter/material.dart';
import 'pages/intro_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF6F1), // Background color
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      home: IntroPage(),
    );
  }
}
