import 'package:flutter/material.dart';
import 'package:lumie/screens/get_started/get_started_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumie',
      debugShowCheckedModeBanner: false,
      home: GetStartedScreen(),
    );
  }
}