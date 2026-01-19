import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/todo.dart';

class TodoDb {
  TodoDb._();
  static final TodoDb instance = TodoDb._();

  static const _dbName = 'todo.db';
  static const _dbVersion = 1;

  static const table = 'todos';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'rowid DESC');
    return rows.map(Todo.fromMap).toList();
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return db.insert(
      table,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db.update(
      table,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(String id) async {
    final db = await database;
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
