import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(todo.isDone ? Icons.check_circle : Icons.timelapse),
                    const SizedBox(width: 8),
                    Text(todo.isDone ? 'สถานะ: เสร็จแล้ว' : 'สถานะ: ยังไม่เสร็จ'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Note:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(todo.note.trim().isEmpty ? '-' : todo.note),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
