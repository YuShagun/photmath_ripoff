import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:photomath_ripoff/models/solution.dart';

class DatabaseProvider {
  static DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Database _db;

  Future<void> openSolutionDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'solution_database.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) => _createDatabase(db)
    );
  }

  Future<void> _createDatabase(Database db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $tableSolution ('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnText TEXT, '
        '$columnType TEXT, '
        '$columnValue TEXT)');
  }

  Future<void> saveSolution(Solution solution) async {
    await _db.insert(
      tableSolution,
      solution.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Solution>> getSolutionMap() async {
    final List<Map<String, dynamic>> solutionMaps = await _db.query(tableSolution);
    return Map.fromIterable(
      solutionMaps.map((solution) => Solution.fromMap(solution)),
      key: (solution) => solution.id.toString(),
      value: (solution) => solution,
    );
  }

  Future<void> deleteSolution(int id) async {
    await _db.delete(
      tableSolution,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllSolutions() async {
    await _db.delete(
      tableSolution,
    );
  }
}