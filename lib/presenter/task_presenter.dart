import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do/model/task_model.dart';

class TaskPresenter {
  static final TaskPresenter _instance = TaskPresenter._internal();
  factory TaskPresenter() => _instance;
  TaskPresenter._internal();

  final Logger _logger = Logger();
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> setDatabase(Database database) async {
    _database = database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    _logger.i('Initializing database at path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        _logger.i('Creating tasks table');
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT,
            completed INTEGER,
            priority INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    _logger.i('Inserting task: ${task.toJson()}');
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    _logger.i('Fetching all tasks');
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    _logger.i('Updating task with id: ${task.id}');
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    _logger.i('Deleting task with id: $id');
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
