import 'package:flutter/material.dart';
import 'package:todo/screens/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 241, 227, 101))
      ),
      home: const ToDo(),
    );
  }
}
