import '../models/todo.dart';
import 'package:flutter/material.dart';
import 'add_edit_todo_screen.dart';
import '../widgets/todo_item_card.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  Future<void> _addTodo() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
    );
    if (result == null) return;

    final title = result['title'] ?? '';
    final desc = result['description'] ?? '';

    setState(() {
      _todos.add(
        Todo(id: DateTime.now().toString(), title: title, description: desc),
      ); // ให้Wตรงกับ model ของคุณ
    });
  }

  Future<void> _editTodo(int index) async {
    final todo = _todos[index];

    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditTodoScreen(
          initialTitle: todo.title,
          initialDescription: todo.description,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _todos[index] = Todo(
        id: todo.id,
        title: result['title'] ?? todo.title,
        description: result['description'] ?? todo.description,
        isCompleted: todo.isCompleted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Midterm'),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
      body: _todos.isEmpty
          ? Center(child: Text('Nothing to do!'))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return TodoItem(
                  todo: todo,
                  onToggle: (v) {
                    setState(() {
                      todo.isCompleted = v ?? false;
                    });
                  },
                  onEdit: () => _editTodo(index),
                  onDelete: () {
                    setState(() {
                      _todos.removeAt(index);
                    });
                  },
                );
              },
            ),
    );
  }
}
