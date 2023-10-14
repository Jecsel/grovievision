import 'package:grovievision/models/image_data.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MangroveDatabaseHelper {
  static final MangroveDatabaseHelper instance = MangroveDatabaseHelper._init();
  static Database? _database;

  MangroveDatabaseHelper._init();

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
        local_name TEXT,
        scientific_name TEXT,
        description TEXT
      )
    ''');
  }

  Future<MangrooveModel> insertImageData(MangrooveModel mangrooveData) async {
    final db = await database;
    final id = await db.insert('mangrove', mangrooveData.toMap());
    return mangrooveData.copy(id: id);
  }

  Future<List<MangrooveModel>> getImageDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mangrove');
    return List.generate(maps.length, (i) {
      return MangrooveModel.fromMap(maps[i]);
    });
  }

  Future<void> updateImageData(MangrooveModel mangrooveData) async {
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
