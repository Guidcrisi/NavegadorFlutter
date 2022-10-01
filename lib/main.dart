import 'package:flutter/material.dart';
import 'package:flutternet/ui/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static Color primary = const Color(0xFF7b00ff);
  static Color background = const Color.fromARGB(255, 56, 56, 56);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterNet',
      home: HomePage(),
    );
  }
}
