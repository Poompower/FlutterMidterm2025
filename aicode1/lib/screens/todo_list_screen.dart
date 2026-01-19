import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  int _nextId = 1;

  Future<void> _goAddTodo() async {
    final title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddTodoScreen()),
    );

    if (title == null) return;

    setState(() {
      _todos.add(Todo(id: _nextId++, title: title));
    });
  }

  Future<void> _goEditTodo(Todo todo) async {
    final newTitle = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTodoScreen(initialTitle: todo.title),
      ),
    );

    if (newTitle == null) return;

    setState(() {
      todo.title = newTitle;
    });
  }

  Future<void> _confirmDelete(int index) async {
    final todo = _todos[index];

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('ลบ "${todo.title}" ใช่ไหม'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goAddTodo,
        child: const Icon(Icons.add),
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีรายการ\nกด + เพื่อเพิ่ม',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return TodoItem(
                  todo: todo,
                  onToggle: (v) {
                    setState(() {
                      todo.isDone = v ?? false;
                    });
                  },
                  onEdit: () => _goEditTodo(todo),
                  onDelete: () => _confirmDelete(index),
                );
              },
            ),
    );
  }
}
