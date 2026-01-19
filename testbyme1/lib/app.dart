import 'package:flutter/material.dart';
import 'screens/todo_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              title: 'Todo App',
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: const Color.fromARGB(255, 47, 90, 112)
              ),
              home: const TodoListScreen(),
            );
  }
}