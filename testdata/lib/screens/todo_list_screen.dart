import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_db.dart';
import '../widgets/todo_item_card.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    if (_loading) return;
    setState(() => _loading = true);

    final items = await TodoDb.instance.getAllTodos();

    if (!mounted) return;
    setState(() {
      _todos
        ..clear()
        ..addAll(items);
      _loading = false;
    });
  }

  Future<void> _addTodo() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
    );
    if (result == null) return;

    final title = (result['title'] ?? '').trim();
    final desc = (result['description'] ?? '').trim();

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: desc,
    );

    await TodoDb.instance.insertTodo(todo);
    await _loadTodos();
  }

  Future<void> _editTodo(int index) async {
    final old = _todos[index];

    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditTodoScreen(
          initialTitle: old.title,
          initialDescription: old.description,
        ),
      ),
    );
    if (result == null) return;

    final updated = Todo(
      id: old.id,
      title: (result['title'] ?? old.title).trim(),
      description: (result['description'] ?? old.description).trim(),
      isCompleted: old.isCompleted,
    );

    await TodoDb.instance.updateTodo(updated);
    await _loadTodos();
  }

  Future<void> _deleteTodo(int index) async {
    final todo = _todos[index];

    // (optional) ถ้าอยาก confirm ก็ใส่ dialog ได้ แต่ตอนนี้เอาให้ทำงานชัวร์ก่อน
    await TodoDb.instance.deleteTodo(todo.id);
    await _loadTodos();
  }

  Future<void> _toggleTodo(int index, bool value) async {
    final todo = _todos[index];

    // อัปเดต UI ก่อน ให้มันรู้สึกไว
    setState(() {
      todo.isCompleted = value;
    });

    // แล้วค่อยเขียนลง DB
    await TodoDb.instance.updateTodo(todo);
    // ไม่จำเป็นต้อง _loadTodos() ทุกครั้งก็ได้ แต่ถ้าอยากชัวร์ก็เรียก
    // await _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Midterm'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _loadTodos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
          ? const Center(child: Text('Nothing to do!'))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return TodoItem(
                  todo: todo,
                  onToggle: (v) => _toggleTodo(index, v ?? false),
                  onEdit: () => _editTodo(index),
                  onDelete: () => _deleteTodo(index),
                );
              },
            ),
    );
  }
}
