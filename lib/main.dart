import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/objectives_screen.dart';

void main() {
  sqfliteFfiInit(); // initialise sqflite pour desktop / tests
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discipline App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ObjectivesScreen(),
    );
  }
}
