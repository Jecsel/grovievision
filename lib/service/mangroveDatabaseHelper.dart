import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:grovievision/models/UserModel.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
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
        description TEXT,
        summary TEXT
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
  
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> registerUser(UserModel userData) async {
    final db = await database;
    final userReturnData = await db.insert('user', userData.toMap());
    return userReturnData;
  }

  Future<List<UserModel>> getAllUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> userData = await db.query('user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password]
    );

    // if (userResult.isNotEmpty) {
    //   return UserModel.fromMap(userResult.first);
    // } else {
    //   return null;
    // }e

    return userData.length > 0;
  }


  Future<int> insertDBMangroveData(MangrooveModel mangrooveData) async {
    final db = await database;
    final mangrooveReturnData = await db.insert('mangrove', mangrooveData.toMap());
    return mangrooveReturnData;
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

  // Future<List<MangrooveModel>> getMangroveDataList() async {
  //   final db = await database;
  //   print('========= db ======= ${db}');
  //   final List<Map<String, dynamic>> maps = await db.query('mangrove');
  //   return List.generate(maps.length, (i) {
  //     return MangrooveModel.fromMap(maps[i]);
  //   });
  // }

  Future<List<MangrooveModel>> getMangroveDataList(int page, int pageSize) async {
    final db = await database;

    // Calculate the offset based on the page and page size to implement pagination.
    final int offset = (page - 1) * pageSize;

    // Replace 'column1', 'column2', etc. with the actual column names you want to select.
    final List<Map<String, dynamic>> maps = await db.query(
      'mangrove',
      columns: ['id', 'imageBlob', 'local_name', 'scientific_name', 'description', 'summary'],
      offset: offset,
      limit: pageSize, // Specify the page size
    );

    print("======== map ========");
    print(maps);

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

  Future<MangrooveModel?> getOneMangroveData(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('mangrove',
      where: 'id = ?',
      whereArgs: [mangroveId]);

    if (mangroveData.isNotEmpty) {
      return MangrooveModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given mangroveId
    }
  }

Future<RootModel?> getOneRootData(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('root',
      where: 'mangroveId = ?',
      whereArgs: [mangroveId]);

    if (mangroveData.isNotEmpty) {
      return RootModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given mangroveId
    }
  }

  Future<FlowerModel?> getOneFlowerData(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('flower',
      where: 'mangroveId = ?',
      whereArgs: [mangroveId]);

    if (mangroveData.isNotEmpty) {
      return FlowerModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given mangroveId
    }
  }

  Future<LeafModel?> getOneLeafData(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('leaf',
      where: 'mangroveId = ?',
      whereArgs: [mangroveId]);

    if (mangroveData.isNotEmpty) {
      return LeafModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given mangroveId
    }
  }

    Future<FruitModel?> getOneFruitData(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('fruit',
      where: 'mangroveId = ?',
      whereArgs: [mangroveId]);

    if (mangroveData.isNotEmpty) {
      return FruitModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given mangroveId
    }
  }

  Future<List<Map<String, dynamic>>?> getMangroveAndData(int mangroveId) async {
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


  Future<void> initiateUserData(MangroveDatabaseHelper dbHelper) async {
    // MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
    final newUser = UserModel(username: 'admin', password: '123123123');
    final registeredUser = await dbHelper.registerUser(newUser);

  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List> loadImageAsUint8List(path) async {
    // Load the image data from the asset
    final ByteData data = await rootBundle.load(path);

    // Convert the ByteData to a Uint8List
    Uint8List uint8List = data.buffer.asUint8List();

    return uint8List;
  }

  Future<void> initiateMangrooveData(MangroveDatabaseHelper dbHelper) async {

    List<dynamic> mangrove_datas = [
      {
        'path': 'assets/images/splash_img.png',
        'local_name': 'Sample Local Name',
        'scientific_name': 'Sample Scientific Name',
        'description': 'Sample Description',
        'summary': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras in felis vitae purus dignissim malesuada vel vitae ex. Mauris at purus ac urna dapibus hendrerit. Suspendisse tristique diam porta, mattis odio id, bibendum erat. Aliquam molestie metus aliquet ipsum condimentum, in fermentum leo varius. Suspendisse ante ante, tempus nec diam quis, aliquet ornare libero. Suspendisse finibus lectus enim, vel lobortis neque egestas nec. Phasellus semper mauris vel efficitur sollicitudin. In tempor justo id sapien hendrerit, et tincidunt enim condimentum. In volutpat nisl in ipsum malesuada suscipit. Duis magna lacus, fringilla malesuada nisi sit amet, lacinia pharetra diam. Maecenas mollis a nibh bibendum pellentesque.',
        'root': {
          'path': 'assets/images/root.png',
          'name': '',
          'description': ''
        },
        'flower': {
          'path': 'assets/images/flower.png',
          'name': '',
          'description': ''
        },
        'leaf': {
          'path': 'assets/images/leaf.png',
          'name': '',
          'description': ''
        },
        'fruit': {
          'path': 'assets/images/fruit.png',
          'name': '',
          'description': ''
        },
      }
    ];

    for (var mangrove in mangrove_datas) {
      final Uint8List mangroveImageBytes = await loadImageAsUint8List(mangrove['path']);
      final Uint8List fruitImageBytes = await loadImageAsUint8List(mangrove['path']);
      final Uint8List rootImageBytes = await loadImageAsUint8List(mangrove['path']);
      final Uint8List leafImageBytes = await loadImageAsUint8List(mangrove['path']);
      final Uint8List flowerImageBytes = await loadImageAsUint8List(mangrove['path']);

      // final Uint8List mangroveImageBytes = await fileToUint8List(File(mangrove['path']));

      var newMangroove = MangrooveModel(
        imageBlob: mangroveImageBytes, 
        local_name: mangrove['local_name'], 
        scientific_name: mangrove['scientific_name'], 
        description: mangrove['description'], 
        summary: mangrove['summary']
      );

      int newMangrooveId = await dbHelper.insertDBMangroveData(newMangroove);

      print("============newMangrooveId========");
      print(newMangrooveId);

      final newRoot = RootModel(
        mangroveId: newMangrooveId ?? 0,
        imageBlob: rootImageBytes, 
        name: mangrove.root.name,
        description: mangrove.root.description,
      );

      final newFlower = FlowerModel(
        mangroveId: newMangrooveId ?? 0,
        imageBlob: flowerImageBytes, 
        name: mangrove.flower.name,
        description: mangrove.flower.description
      );

      final newLeaf = LeafModel(
        mangroveId: newMangrooveId ?? 0,
        imageBlob: leafImageBytes, 
        name: mangrove.leaf.name,
        description: mangrove.leaf.description
      );

      final newFruit = FruitModel(
        mangroveId: newMangrooveId ?? 0,
        imageBlob:  fruitImageBytes, 
        name: mangrove.fruit.name,
        description: mangrove.fruit.description
      );

      final root_id = dbHelper.insertDBRootData(newRoot);
      final flower_id = dbHelper.insertDBFlowerData(newFlower);
      final leaf_id = dbHelper.insertDBLeafData(newLeaf);
      final fruit_id = dbHelper.insertDBFruitData(newFruit);
    }
  }
}
