import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/logger.dart';

const String _h = 'tasks_local_database';

class TaskLocalRepository {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");
    return openDatabase(
      path,
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN isSynced INTEGER NOT NULL',
          );
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              uid TEXT NOT NULL,
              dueAt TEXT NOT NULL,
              hexColor TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL
          )
    ''');
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id=?', whereArgs: [task.id]);
    logDebug(_h, "...");
    await db.insert(tableName, task.toJson());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    logDebug(_h, "Inserting updated tasks");
    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromJson(elem));
      }
      return tasks;
    }

    return [];
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    logDebug(_h, "Task is synced to Postgres db");
    final result =
        await db.query(tableName, where: 'isSynced=?', whereArgs: [0]);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromJson(elem));
      }
      return tasks;
    }

    return [];
  }

  Future<void> updatedRowValue(String id,int newValue) async {
    final db = await database;
    logDebug(_h, "Sync value is updated");
    await db.update(tableName,{'isSynced':newValue}, where: 'id=?', whereArgs: [id]);
  
  }
}
