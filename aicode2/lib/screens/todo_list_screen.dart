import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/app_drawer.dart';
import '../widgets/todo_item_tile.dart';
import '../widgets/todo_item_card.dart';
import 'add_edit_todo_screen.dart';
import 'todo_detail_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  bool _isGrid = false;

  Future<void> _goAdd() async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
    );

    if (result == null) return;

    setState(() {
      _todos.add(result);
    });
  }

  Future<void> _goEdit(Todo todo) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (_) => AddEditTodoScreen(editing: todo)),
    );

    if (result == null) return;

    setState(() {
      // todo ถูกแก้ใน object เดิมแล้ว แค่ rebuild ก็พอ
    });
  }

  void _goDetail(Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TodoDetailScreen(todo: todo)),
    );
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

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        'ไม่มีรายการ\nกด + เพื่อเพิ่ม',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildList() {
    if (_todos.isEmpty) return _buildEmpty();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return TodoItemTile(
          todo: todo,
          onToggle: (v) {
            setState(() => todo.isDone = v ?? false);
          },
          onTap: () => _goDetail(todo),
          onEdit: () => _goEdit(todo),
          onDelete: () => _confirmDelete(index),
        );
      },
    );
  }

  Widget _buildGrid() {
    if (_todos.isEmpty) return _buildEmpty();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return TodoItemCard(
          todo: todo,
          onToggle: (v) {
            setState(() => todo.isDone = v ?? false);
          },
          onTap: () => _goDetail(todo),
          onEdit: () => _goEdit(todo),
          onDelete: () => _confirmDelete(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        onGoHome: () {}, // หน้านี้คือ home อยู่แล้ว
      ),
      appBar: AppBar(
        title: const Text('To-do List'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _isGrid ? 'List view' : 'Grid view',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() => _isGrid = !_isGrid);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goAdd,
        child: const Icon(Icons.add),
      ),
      body: _isGrid ? _buildGrid() : _buildList(),
    );
  }
}
