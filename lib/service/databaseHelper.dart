import 'package:grovievision/models/image_data.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String path = join(await getDatabasesPath(), 'mangrove.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE mangrove (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageBlob BLOB,
        name TEXT,
        description TEXT
      )
    ''');
  }

  Future<MangrooveData> insertImageData(MangrooveData mangrooveData) async {
    final db = await database;
    final id = await db.insert('mangrove', mangrooveData.toMap());
    return mangrooveData.copy(id: id);
  }

  Future<List<MangrooveData>> getImageDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mangrove');
    return List.generate(maps.length, (i) {
      return MangrooveData.fromMap(maps[i]);
    });
  }

  Future<void> updateImageData(MangrooveData mangrooveData) async {
    final db = await database;
    await db.update(
      'mangrove',
      mangrooveData.toMap(),
      where: 'id = ?',
      whereArgs: [mangrooveData.id],
    );
  }

  Future<void> deleteImageData(int id) async {
    final db = await database;
    await db.delete(
      'mangrove',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
