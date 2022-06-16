import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    } else {
      try {
        final String _path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE $_tableName ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                'title STRING,'
                'note TEXT,'
                'date DATETIME,'
                'startTime STRING,'
                'endTime STRING,'
                'remind INTEGER,'
                'repeat STRING,'
                'color INTEGER,'
                'isCompleted INTEGER)',
          );
        });
        print('DataBase Created');
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }
  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE $_tableName 
    SET isCompleted =?
    WHERE id=?
    ''', [1, id]);
  }
}
