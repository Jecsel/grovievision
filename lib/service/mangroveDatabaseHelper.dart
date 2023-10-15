import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/image_data.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/root_model.dart';
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
    await db.execute('''
      CREATE TABLE mangrove (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageBlob BLOB,
        local_name TEXT,
        scientific_name TEXT,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE root (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        name TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE flower (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        name TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leaf (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        name TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE fruit (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        name TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');
  }


  Future<MangrooveModel> insertDBMangroveData(MangrooveModel mangrooveData) async {
    final db = await database;
    final id = await db.insert('mangrove', mangrooveData.toMap());
    return mangrooveData;
  }

  Future<RootModel> insertDBRootData(RootModel rootData) async {
    final db = await database;
    final id = await db.insert('root', rootData.toMap());
    return rootData;
  }

  Future<FlowerModel> insertDBFlowerData(FlowerModel flowerData) async {
    final db = await database;
    final id = await db.insert('flower', flowerData.toMap());
    return flowerData;
  }

  Future<LeafModel> insertDBLeafData(LeafModel leafData) async {
    final db = await database;
    final id = await db.insert('leaf', leafData.toMap());
    return leafData;
  }

  Future<FruitModel> insertDBFruitData(FruitModel fruitData) async {
    final db = await database;
    final id = await db.insert('fruit', fruitData.toMap());
    return fruitData;
  }

  Future<List<MangrooveModel>> getMangroveDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mangrove');
    return List.generate(maps.length, (i) {
      return MangrooveModel.fromMap(maps[i]);
    });
  }

  Future<List<RootModel>> getRootDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('root');
    return List.generate(maps.length, (i) {
      return RootModel.fromMap(maps[i]);
    });
  }

  Future<List<FlowerModel>> getFlowerDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('flower');
    return List.generate(maps.length, (i) {
      return FlowerModel.fromMap(maps[i]);
    });
  }

  Future<List<LeafModel>> getLeafDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('leaf');
    return List.generate(maps.length, (i) {
      return LeafModel.fromMap(maps[i]);
    });
  }

  Future<List<FruitModel>> getFruitDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fruit');
    return List.generate(maps.length, (i) {
      return FruitModel.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>?> getMangroveAndRootData(int mangroveId) async {
    final db = await database;

    // Query the Mangrove table based on the mangroveId
    final mangroveData = await db.query('mangrove',
        where: 'id = ?',
        whereArgs: [mangroveId]);

    // Query the Root table based on the mangroveId
    final rootData = await db.query('root',
        where: 'mangroveId = ?',
        whereArgs: [mangroveId]);
    
    final flowerData = await db.query('flower',
        where: 'mangroveId = ?',
        whereArgs: [mangroveId]);

    final leafData = await db.query('leaf',
        where: 'mangroveId = ?',
        whereArgs: [mangroveId]);
  
    final fruitData = await db.query('fruit',
        where: 'mangroveId = ?',
        whereArgs: [mangroveId]);

    // Combine the Mangrove and Root data into a single list
    List<Map<String, dynamic>> combinedData = [];
    combinedData.add(mangroveData.first);
    combinedData.addAll(rootData);
    combinedData.addAll(flowerData);
    combinedData.addAll(leafData);
    combinedData.addAll(fruitData);

    return combinedData;
  }

  Future<void> updateMangroveData(MangrooveModel mangrooveData) async {
    final db = await database;
    await db.update(
      'mangrove',
      mangrooveData.toMap(),
      where: 'id = ?',
      whereArgs: [mangrooveData.id],
    );
  }

  Future<void> updateRootData(RootModel rootData) async {
    final db = await database;
    await db.update(
      'root',
      rootData.toMap(),
      where: 'id = ?',
      whereArgs: [rootData.id],
    );
  }

  Future<void> updateFlowerData(FlowerModel flowerData) async {
    final db = await database;
    await db.update(
      'flower',
      flowerData.toMap(),
      where: 'id = ?',
      whereArgs: [flowerData.id],
    );
  }

  Future<void> updateLeafData(LeafModel leafData) async {
    final db = await database;
    await db.update(
      'leaf',
      leafData.toMap(),
      where: 'id = ?',
      whereArgs: [leafData.id],
    );
  }

  Future<void> updateFruitData(FruitModel fruitData) async {
    final db = await database;
    await db.update(
      'fruit',
      fruitData.toMap(),
      where: 'id = ?',
      whereArgs: [fruitData.id],
    );
  }

  Future<void> deleteMangroveData(int id) async {
    final db = await database;
    await db.delete(
      'mangrove',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRootData(int id) async {
    final db = await database;
    await db.delete(
      'root',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFlowerData(int id) async {
    final db = await database;
    await db.delete(
      'flower',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteLeafData(int id) async {
    final db = await database;
    await db.delete(
      'leaf',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFruitData(int id) async {
    final db = await database;
    await db.delete(
      'fruit',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
