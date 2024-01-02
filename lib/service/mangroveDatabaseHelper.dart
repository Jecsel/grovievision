import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:grovievision/models/UserModel.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/mangrove_images.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flower_images.dart';
import '../models/fruit_images.dart';
import '../models/leaf_images.dart';
import '../models/root_images.dart';

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
        imagePath TEXT,
        name TEXT,
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
        imagePath TEXT,
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
        imagePath TEXT,
        name TEXT,
        inflorescence TEXT,
        petals TEXT,
        sepals TEXT,
        stamen TEXT,
        size TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leaf (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        arrangement TEXT,
        bladeShape TEXT,
        margin TEXT,
        apex TEXT,
        base TEXT,
        upperSurface TEXT,
        underSurface TEXT,
        size TEXT,
        description TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE fruit (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        shape TEXT,
        color TEXT,
        texture TEXT,
        size TEXT,
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

    await db.execute('''
      CREATE TABLE mangrove_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangroveId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (mangroveId) REFERENCES mangrove (id)
      )
    ''');
  
    await db.execute('''
      CREATE TABLE root_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rootId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (rootId) REFERENCES root (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE flower_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flowerId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (flowerId) REFERENCES flower (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE fruit_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fruitId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (fruitId) REFERENCES fruit (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leaf_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        leafId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        FOREIGN KEY (leafId) REFERENCES leaf (id)
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

  Future<MangroveImagesModel> insertMangroveImages( imageData) async {
    final db = await database;
    await db.insert('mangrove_images', imageData.toMap());
    return imageData;
  }

  Future<List<MangroveImagesModel>> getMangroveImages(int mangroveId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('mangrove_images', where: 'mangroveId = ?', whereArgs: [mangroveId]);
    return List.generate(maps.length, (i) {
      return MangroveImagesModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOneImageFromMangrove(int id) async {
    final db = await database;
    await db.delete(
      'mangrove_images',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<FlowerImagesModel> insertFlowerImages( imageData) async {
    final db = await database;
    await db.insert('flower_images', imageData.toMap());
    return imageData;
  }

  Future<List<FlowerImagesModel>> getFlowerImages(int flowerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('flower_images', where: 'flowerId = ?', whereArgs: [flowerId]);
    return List.generate(maps.length, (i) {
      return FlowerImagesModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOneImageFromFlower(int id) async {
    final db = await database;
    await db.delete(
      'flower_images',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<FruitImagesModel> insertFruitImages( imageData) async {
    final db = await database;
    await db.insert('fruit_images', imageData.toMap());
    return imageData;
  }

  Future<List<FruitImagesModel>> getFruitImages(int fruitId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('fruit_images', where: 'fruitId = ?', whereArgs: [fruitId]);
    return List.generate(maps.length, (i) {
      return FruitImagesModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOneImageFromFruit(int id) async {
    final db = await database;
    await db.delete(
      'fruit_images',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<LeafImagesModel> insertLeafImages( imageData) async {
    final db = await database;
    await db.insert('leaf_images', imageData.toMap());
    return imageData;
  }

  Future<List<LeafImagesModel>> getLeafImages(int leafId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('leaf_images', where: 'leafId = ?', whereArgs: [leafId]);
    return List.generate(maps.length, (i) {
      return LeafImagesModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOneImageFromLeaf(int id) async {
    final db = await database;
    await db.delete(
      'leaf_images',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<RootImagesModel> insertRootImages( imageData) async {
    final db = await database;
    await db.insert('root_images', imageData.toMap());
    return imageData;
  }

  Future<List<RootImagesModel>> getRootImages(int rootId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('root_images', where: 'rootId = ?', whereArgs: [rootId]);
    return List.generate(maps.length, (i) {
      return RootImagesModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOneImageFromRoot(int id) async {
    final db = await database;
    await db.delete(
      'root_images',
      where: 'id = ?',
      whereArgs: [id]
    );
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

  Future<int> insertDBRootData(RootModel rootData) async {
    final db = await database;
    final rootId = await db.insert('root', rootData.toMap());
    return rootId;
  }

  Future<int> insertDBFlowerData(FlowerModel flowerData) async {
    final db = await database;
    final flowerId = await db.insert('flower', flowerData.toMap());
    return flowerId;
  }

  Future<int> insertDBLeafData(LeafModel leafData) async {
    final db = await database;
    final leafId = await db.insert('leaf', leafData.toMap());
    return leafId;
  }

  Future<int> insertDBFruitData(FruitModel fruitData) async {
    final db = await database;
    final fruitId = await db.insert('fruit', fruitData.toMap());
    return fruitId;
  }

  Future<List<MangrooveModel>> getMangroveDataList() async {
    final db = await database;
    print('========= db ======= ${db}');
    final List<Map<String, dynamic>> maps = await db.query('mangrove');
    return List.generate(maps.length, (i) {
      return MangrooveModel.fromMap(maps[i]);
    });
  }

  // Future<List<MangrooveModel>> getMangroveDataList(int page, int pageSize) async {
  //   final db = await database;

  //   // Calculate the offset based on the page and page size to implement pagination.
  //   final int offset = (page - 1) * pageSize;

  //   // Replace 'column1', 'column2', etc. with the actual column names you want to select.
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'mangrove',
  //     columns: ['id', 'imageBlob', 'local_name', 'scientific_name', 'description', 'summary'],
  //     offset: offset,
  //     limit: pageSize, // Specify the page size
  //   );

  //   print("======== map ========");
  //   print(maps);

  //   return List.generate(maps.length, (i) {
  //     return MangrooveModel.fromMap(maps[i]);
  //   });
  // }

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
    await dbHelper.registerUser(newUser);

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

    if(await getFlagFromTempStorage()) {
      print("already initialize");

    } else {
      await setFlagInTempStorage();

    List<dynamic> mangrove_datas = [
        {
          'path': 'assets/images/onetree.png',
          'image_paths': [
            'assets/images/onetree.png',
            'assets/images/onetree.png',
            'assets/images/onetree.png',
          ],
          'name': ' Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus ebracteatus',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
          'root': {
            'path': '',
            'image_paths': [
              'assets/images/root.png',
              'assets/images/root.png',
              'assets/images/root.png',
              ],
            'name': 'Sample Name',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/oneflower.png',
            'image_paths': [
              'assets/images/oneflower.png',
              'assets/images/oneflower.png',
              'assets/images/oneflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal',
            'petals':'white to brownish, with age',
            'sepals': '',
            'stamen': '',
            'size': '2-3 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/oneleaf.png',
            'image_paths': [
              'assets/images/oneleaf.png',
              'assets/images/oneleaf.png',
              'assets/images/oneleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptic to oblong',
            'margin': 'deeply lobed, serrate, with sharp spines',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'dark green, shiny',
            'underSurface': 'dark green',
            'size': '10-20 cm long, 4-6 cm wide',
            'description': 'stiff, salt crystals present'
          },
          'fruit': {
            'path': 'assets/images/onefruit.png',
            'image_paths': [
              'assets/images/onefruit.png',
              'assets/images/onefruit.png',
              'assets/images/onefruit.png',
            ],
            'name': '',
            'shape': 'capsule, slightly flattened',
            'color': 'green to dark green',
            'texture': 'smooth',
            'size': '2-3 cm long, ~ 1 cm diameter',
            'description': ''
          },
        },    
         {
          'path': 'assets/images/twotree.png',
          'image_paths': [
            'assets/images/twotree.png',
            'assets/images/twotree.png',
            'assets/images/twotree.png',
          ],
          'name': ' Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus ilicifolius',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
          'root': {
            'path': '',
            'image_paths': [
              'assets/images/root.png',
              'assets/images/root.png',
              'assets/images/root.png',
              ],
            'name': 'Sample Name',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/twoflower.png',
            'image_paths': [
              'assets/images/twoflower.png',
              'assets/images/twoflower.png',
              'assets/images/twoflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal',
            'petals':'light blue with purple hue',
            'sepals': '',
            'stamen': '',
            'size': '2-3 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/twoleaf.png',
            'image_paths': [
              'assets/images/twoleaf.png',
              'assets/images/twoleaf.png',
              'assets/images/twoleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': ' elliptic to oblong',
            'margin': 'slightly lobed, serrate, with sharp spines',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'pale green with yellowish tinge, smooth',
            'underSurface': 'green',
            'size': '18-22 cm long, 6-7 cm wide',
            'description': 'stiff'
          },
          'fruit': {
            'path': 'assets/images/twofruit.png',
            'image_paths': [
              'assets/images/twofruit.png',
              'assets/images/twofruit.png',
              'assets/images/twofruit.png',
            ],
            'name': '',
            'shape': 'capsule, slightly flattened',
            'color': 'green',
            'texture': 'smooth',
            'size': '2.5-3 cm long, 1-1.5 cm diameter',
            'description': ''
          },
        },   
         {
          'path': 'assets/images/trestree.png',
          'image_paths': [
            'assets/images/trestree.png',
            'assets/images/trestree.png',
            'assets/images/trestree.png',
          ],
          'name': ' Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus volubilis',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
          'root': {
            'path': '',
            'image_paths': [
              'assets/images/root.png',
              'assets/images/root.png',
              'assets/images/root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/tresflower.png',
            'image_paths': [
              'assets/images/tresflower.png',
              'assets/images/tresflower.png',
              'assets/images/tresflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal',
            'petals':'white to brownish, with age',
            'sepals': '',
            'stamen': '',
            'size': '~2 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/tresleaf.png',
            'image_paths': [
              'assets/images/tresleaf.png',
              'assets/images/tresleaf.png',
              'assets/images/tresleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': ' elliptic to anceolate',
            'margin': 'entire - smooth, rarely serrate',
            'apex': 'acute to acuminate',
            'base': 'acute',
            'upperSurface': 'dark green, smooth',
            'underSurface': 'dark green',
            'size': '15-18 cm long, 4-6 cm wide',
            'description': 'younger (higher on stem)- wider, margin often smooth older (lower on stem)- narrower, with small spines'
          },
          'fruit': {
            'path': 'assets/images/tresfruit.png',
            'image_paths': [
              'assets/images/tresfruit.png',
              'assets/images/tresfruit.png',
              'assets/images/tresfruit.png',
            ],
            'name': '',
            'shape': 'capsule, slightly flattened',
            'color': 'green to dark green',
            'texture': 'smooth',
            'size': '~2 cm long, ~1 cm diameter',
            'description': ''
          },
        },  
        {
          'path': 'assets/images/fourtree.png',
          'image_paths': [
            'assets/images/fourtree.png',
            'assets/images/fourtree.png',
            'assets/images/fourtree.png',
          ],
          'name': ' Myrsinaceae',
          'local_name': 'saging-saging, tayokan, kawilan (Visayan), tinduk-tindukan (Tagalog)',
          'scientific_name': 'Aegiceras corniculatum',
          'description': 'Shrubs to small trees typically 2-3 m tall but may reach 5 m. The species grows in isolated clumps never forming extensive stands along tidal creeks and river mouths. Widely distributed in Panay but has never been found together with its sister species A. floridum (see following). Substrate is sandy to compact mud. The leaves are often notched and have a prominent midrib on the undersurface which merges with the pinkish petiole. The strongly curved fruits hang in clusters like small bananas (hence the local names referring to banana varieties) and are pale green to pinkish-red. In Panay, the species is used for firewood and the bark for tanning and fish poison. Elsewhere in the Philippines, the wood is made into knife handles.',
          'summary': '',
          'root': {
            'path': 'assets/images/fourroot.png',
            'image_paths': [
              'assets/images/fourroot.png',
              'assets/images/fourroot.png',
              'assets/images/fourroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/fourflower.png',
            'image_paths': [
              'assets/images/fourflower.png',
              'assets/images/fourflower.png',
              'assets/images/fourflower.png',
            ],
            'name': '',
            'inflorescence':'umbel, terminal',
            'petals':'5, white, folded outward',
            'sepals': '5, green',
            'stamen': '5, orange to brown',
            'size': '0.6-0.7 cm long,0.8-1.0 cm diameter',
            'description': 'scented'
          },
          'leaf': {
            'path': 'assets/images/fourleaf.png',
            'image_paths': [
              'assets/images/fourleaf.png',
              'assets/images/fourleaf.png',
              'assets/images/fourleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate (rarely opposite), spiral',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'acute',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'brownish green, prominent midrib',
            'size': '7 (5-12) cm long, 5 (3-7) cm wide',
            'description': 'salt crystals present'
          },
          'fruit': {
            'path': 'assets/images/fourfruit.png',
            'image_paths': [
              'assets/images/fourfruit.png',
              'assets/images/fourfruit.png',
              'assets/images/fourfruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, strongly curved, pointed tip',
            'color': 'light green to purple',
            'texture': 'smooth',
            'size': '0 (4-8) cm long, 0.4-0.6 cm diameter',
            'description': 'cryptoviviparous'
          },
        },
        {
          'path': 'assets/images/fivetree.png',
          'image_paths': [
            'assets/images/fivetree.png',
            'assets/images/fivetree.png',
            'assets/images/fivetree.png',
          ],
          'name': ' Myrsinaceae',
          'local_name': 'saging-saging, katuganung, kwasay (Visayan); tinduk-tindukan (Tagalog)',
          'scientific_name': 'Aegiceras floridum ',
          'description': 'Shrubs to small trees typically 2-3 m tall but may reach 5 m. The species grows in isolated clumps never forming extensive stands along tidal creeks and river mouths. Widely distributed in Panay but has never been found together with its sister species A. floridum (see following). Substrate is sandy to compact mud. The leaves are often notched and have a prominent midrib on the undersurface which merges with the pinkish petiole. The strongly curved fruits hang in clusters like small bananas (hence the local names referring to banana varieties) and are pale green to pinkish-red. In Panay, the species is used for firewood and the bark for tanning and fish poison. Elsewhere in the Philippines, the wood is made into knife handles.',
          'summary': '',
          'root': {
            'path': 'assets/images/fiveroot.png',
            'image_paths': [
              'assets/images/fiveroot.png',
              'assets/images/fiveroot.png',
              'assets/images/fiveroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/fiveflower.png',
            'image_paths': [
              'assets/images/fiveflower.png',
              'assets/images/fiveflower.png',
              'assets/images/fiveflower.png',
            ],
            'name': '',
            'inflorescence':'raceme, terminal',
            'petals':'5, white to brown',
            'sepals': '5, green',
            'stamen': '5',
            'size': '1 cm long, 0.7 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/fiveleaf.png',
            'image_paths': [
              'assets/images/fiveleaf.png',
              'assets/images/fiveleaf.png',
              'assets/images/fiveleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'acute',
            'upperSurface': 'smooth, light green',
            'underSurface': 'smooth, whitish green',
            'size': '4 (3-6) cm long, 2 (1-3) cm wide',
            'description': 'salt crystals present, insect bites'
          },
          'fruit': {
            'path': 'assets/images/fivefruit.png',
            'image_paths': [
              'assets/images/fivefruit.png',
              'assets/images/fivefruit.png',
              'assets/images/fivefruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, straight, like small bananas',
            'color': 'pink to bright red',
            'texture': 'smooth',
            'size': '2-3 cm long,0.4-0.5 cm diameter',
            'description': 'cryptoviviparous'
          },
        },  
         {
          'path': 'assets/images/sixtree.png',
          'image_paths': [
            'assets/images/sixtree.png',
            'assets/images/sixtree.png',
            'assets/images/sixtree.png',
          ],
          'name': ' Avicenniaceae',
          'local_name': 'bungalon, api-api, miapi',
          'scientific_name': 'Avicennia alba',
          'description': 'Medium-sized trees reaching 12 m high, which tolerate high salinity and colonize the soft, muddy banks of rivers and tidal flats. This species can be found interspersed among the more widely distributed stands of A . marina. Small monospecific groves of A. alba are found in Pan-ay, Capiz; Batan, Aklan and Makato River, Aklan. The whitish undersides of leaves give the canopy a silvery-white appearance from a distance, differentiating it from the green to golden canopy of A .marina. A. alba differs from the latter by its elongated leaves, conical or chili-like fruits, and relatively dark, sooty trunk (see opposite page, bottom left photo). The wood is used for fuel and the leaves for forage. Past uses include a resinous secretion for birth control, bark as astringent, and an ointment from seeds to relieve smallpox ulceration. Table 4 summarizes the characters used to separate the four Avicennia species.',
          'summary': '',
          'root': {
            'path': 'assets/images/sixroot.png',
            'image_paths': [
              'assets/images/sixroot.png',
              'assets/images/sixroot.png',
              'assets/images/sixroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/sixflower.png',
            'image_paths': [
              'assets/images/sixflower.png',
              'assets/images/sixflower.png',
              'assets/images/sixflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal/axillary',
            'petals':'4, light yellow-orange',
            'sepals': '4, light green, fused',
            'stamen': '4, yellow',
            'size': '0.5-0.6 cm diameter',
            'description': 'slightly scented'
          },
          'leaf': {
            'path': 'assets/images/sixleaf.png',
            'image_paths': [
              'assets/images/sixleaf.png',
              'assets/images/sixleaf.png',
              'assets/images/sixleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'smooth, green',
            'underSurface': 'smooth, slivery',
            'size': '10 (7-15) cm long, 4 (2-5) cm wide',
            'description': ''
          },
          'fruit': {
            'path': 'assets/images/sixfruit.png',
            'image_paths': [
              'assets/images/sixfruit.png',
              'assets/images/sixfruit.png',
              'assets/images/sixfruit.png',
            ],
            'name': '',
            'shape': 'conical, chili-like form',
            'color': 'light green',
            'texture': 'light green',
            'size': '3-5 cm long, 1-2 cm wide',
            'description': ''
          },
        },  
        {
          'path': 'assets/images/sevtree.png',
          'image_paths': [
            'assets/images/sevtree.png',
            'assets/images/sevtree.png',
            'assets/images/sevtree.png',
          ],
          'name': '  Avicenniaceae',
          'local_name': 'bungalon, api-api, miapi, bayabason (Iloilo)',
          'scientific_name': 'Avicennia marina ',
          'description': 'The most widely distributed mangrove species, it colonizes muddy, sandy and even coralline rock substrates in fringing mangroves - forming stands, often with S. alba - and along river banks and on higher ground. It is also found as shrubs in mudflats and abandoned fishponds. Leaves are highly variable, and often exhibit leaf curling. The yellow green leaves give the stand a golden appearance in sunlight. The bark is mottled, light green to brown and flaky. Pneumatophores are pencil-shaped. Coastal dwellers plant this species to protect their homes from typhoons (see opposite, bottom left photo). A. marina is preferred for firewood because it coppices, i.e., produces new branches after cutting. The smoke of dried branches acts as mosquito repellent. Leaves are fed to livestock. Newly-sprouted Avicennia seedlings are cooked as vegetables. Christmas trees built from branches are sold along Roxas Blvd. in Manila.',
          'summary': '',
          'root': {
            'path': 'assets/images/sevroot.png',
            'image_paths': [
              'assets/images/sevroot.png',
              'assets/images/sevroot.png',
              'assets/images/sevroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/sevflower.png',
            'image_paths': [
              'assets/images/sevflower.png',
              'assets/images/sevflower.png',
              'assets/images/sevflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal/axillary',
            'petals':'4, yellow-orange, brown margin',
            'sepals': '4, light green, fused',
            'stamen': '4, yellow; very short',
            'size': '0.5-0.7 cm diamete',
            'description': '1 short pistil, yellow'
          },
          'leaf': {
            'path': 'assets/images/sevleaf.png',
            'image_paths': [
              'assets/images/sevleaf.png',
              'assets/images/sevleaf.png',
              'assets/images/sevleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acute to round',
            'base': 'acute',
            'upperSurface': 'smooth, green to yellow-green',
            'underSurface': 'smooth, green to yellow green',
            'size': '7 (4-11) cm long, 3 (2-6) cm wide',
            'description': 'numerous insect bites, curling and rolling, highly variable'
          },
          'fruit': {
            'path': 'assets/images/sevfruit.png',
            'image_paths': [
              'assets/images/sevfruit.png',
              'assets/images/sevfruit.png',
              'assets/images/sevfruit.png',
            ],
            'name': '',
            'shape': 'heart-shaped, short beak',
            'color': 'light green',
            'texture': 'pubescent',
            'size': '2-3 cm long, 2-3 cm wide',
            'description': ''
          },
        } ,  
        {
          'path': 'assets/images/eyttree.png',
          'image_paths': [
            'assets/images/eyttree.png',
            'assets/images/eyttree.png',
            'assets/images/eyttree.png',
          ],
          'name': ' Avicenniaceae ',
          'local_name': 'api-api, miapi, bungalon',
          'scientific_name': 'Avicennia officinalis',
          'description': 'Medium to large trees up to 20 m on firm mud of the upper intertidal in estuarine areas. The species has a crooked trunk and shiny, dark green leaves with spreading crown. Among the four Avicennia species, A. officinalis has the biggest flowers (1.5 cm wide), fruits (4 cm long) and leaves (14 cm long x 7 cm wide) with conspicuous salt crystals (see opposite, bottom left photo), and rarely forms monospecific stands. In addition, the orange flowers have the darkest shade and strongest scent. Ashes of branches are placed in a funnel through which seawater is filtered. The filtrate is evaporated by boiling to obtain a solid lump of salt. In the past, the wood was used to smoke fish and build rice mortars and pestles. Fruits were used as astringent, bark and roots as aphrodisiac, and seeds and roots as poultice to treat ulcers, etc.',
          'summary': '',
          'root': {
            'path': 'assets/images/eytroot.png',
            'image_paths': [
              'assets/images/eytroot.png',
              'assets/images/eytroot.png',
              'assets/images/eytroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/eytflower.png',
            'image_paths': [
              'assets/images/eytflower.png',
              'assets/images/eytflower.png',
              'assets/images/eytflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal/axillary',
            'petals':'4, dark yellow-orange',
            'sepals': '4, light green, fused',
            'stamen': '4, yellow',
            'size': '0.9-1.5 cm diameter',
            'description': 'most aromatic among Avicennia spp.'
          },
          'leaf': {
            'path': 'assets/images/eytleaf.png',
            'image_paths': [
              'assets/images/eytleaf.png',
              'assets/images/eytleaf.png',
              'assets/images/eytleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptic to oblong',
            'margin': 'entire - smooth',
            'apex': 'round',
            'base': 'acute',
            'upperSurface': 'shiny, dark green',
            'underSurface': 'glabrous, yellow-green',
            'size': '10 (6-14) cm long, 5 (3-7) cm wide',
            'description': 'with salt crystals; appear slightly convex as sides bent downwards'
          },
          'fruit': {
            'path': 'assets/images/eytfruit.png',
            'image_paths': [
              'assets/images/eytfruit.png',
              'assets/images/eytfruit.png',
              'assets/images/eytfruit.png',
            ],
            'name': '',
            'shape': 'heart-shaped, elongated, pointed tip',
            'color': 'yellowish green',
            'texture': 'rugose, finely hairy',
            'size': '3-4 cm long, 2-3 cm wide',
            'description': ''
          },
        },
        {
          'path': 'assets/images/ninetree.png',
          'image_paths': [
            'assets/images/ninetree.png',
            'assets/images/ninetree.png',
            'assets/images/ninetree.png',
          ],
          'name': ' Avicenniaceae ',
          'local_name': 'api-api, miapi, bungalon',
          'scientific_name': 'Avicennia rumphiana',
          'description': 'Formerly referred to as Avicennia lanata, this species forms medium to large trees. They grow on firm mud of middle to high intertidal areas. Avicennia rumphiana forms an almost monospecific grove of dozens of old, big trees in Bugtong Bato, Ibajay, Aklan with maximum 20 m height, 2.5 m diameter and 8 m circumference (see opposite page, bottom left photo). It differs from other Avicennia species by the brownish color and woolly hairs of fruits and undersurface of leaves. The canopy of an A .rumphiana stand looks light brown from a distance, in contrast to the silvery white appearance of A. alba.Sometimes A . rumphiana occurs with A officinalis, but its young leaves and branches are typically upright, whereas those of A . officinalis point in all directions. Also used as fuelwood and for furniture-making with its fine-grained wood.',
          'summary': '',
          'root': {
            'path': 'assets/images/nineroot.png',
            'image_paths': [
              'assets/images/nineroot.png',
              'assets/images/nineroot.png',
              'assets/images/nineroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/nineflower.png',
            'image_paths': [
              'assets/images/nineflower.png',
              'assets/images/nineflower.png',
              'assets/images/nineflower.png',
            ],
            'name': '',
            'inflorescence':'spike, terminal/axillary',
            'petals':'4, yellow-orange',
            'sepals': '4, light green, fused',
            'stamen': '4, yellow',
            'size': '0.5-0.7 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/nineleaf.png',
            'image_paths': [
              'assets/images/nineleaf.png',
              'assets/images/nineleaf.png',
              'assets/images/nineleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'round',
            'base': 'acute',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'densely pubescent, yellow green',
            'size': '8 (5-11) cm long, 4 (3-5) cm wide',
            'description': ''
          },
          'fruit': {
            'path': 'assets/images/ninefruit.png',
            'image_paths': [
              'assets/images/ninefruit.png',
              'assets/images/ninefruit.png',
              'assets/images/ninefruit.png',
            ],
            'name': '',
            'shape': 'heart-shaped, rounded, blunt tip',
            'color': 'yellow-green',
            'texture': 'woolly',
            'size': '1-3 cm long, 1-2 cm wide',
            'description': ''
          },
        } ,
        {
          'path': 'assets/images/tentree.png',
          'image_paths': [
            'assets/images/tentree.png',
            'assets/images/tentree.png',
            'assets/images/tentree.png',
          ],
          'name': 'Rhizophoraceae ',
          'local_name': 'pototan, busain (Tagalog)',
          'scientific_name': 'Bruguiera cylindrica',
          'description': 'Small to medium-sized trees with rounded crown, reaching 10 m high and 20 cm DBH. Bruguiera cylindrica colonizes newly-established substrates behind the pioneering Avicennia-Rhizophora zone along estuarine riverbanks and tidal creeks. When found beside taller Rhizophora trees, the species appears short (hence the local name pototan). B. cylindrica is also found as single trees on compact muds of open, more inland sites. Among the Bruguiera species, it has the smallest leaves and flowers next to B. parviflora (Table 5). The stipules (at times called leaf sheaths) are pale green. The mottled bark becomes more dark and rough in older trees (see opposite page, bottom left photos). The short and thin pencil-like propagules bear a calyx cap whose lobes are reflexed. In the past, B. cylindrica timber was harvested for household and construction use. Present uses are limited to firewood and as source of tannin.',
          'summary': '',
          'root': {
            'path': 'assets/images/tenroot.png',
            'image_paths': [
              'assets/images/tenroot.png',
              'assets/images/tenroot.png',
              'assets/images/tenroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/tenflower.png',
            'image_paths': [
              'assets/images/tenflower.png',
              'assets/images/tenflower.png',
              'assets/images/tenflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'8, white, with brown hairs',
            'sepals': '8, light green, fused',
            'stamen': '8 pairs, brown tips',
            'size': '0.8-1 cm long, 1-1.2 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/tenleaf.png',
            'image_paths': [
              'assets/images/tenleaf.png',
              'assets/images/tenleaf.png',
              'assets/images/tenleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acute to acuminate',
            'base': 'acute',
            'upperSurface': 'shiny, green',
            'underSurface': 'smooth, light green',
            'size': '10 (6-17) cm long, 4 (2-8) cm wide',
            'description': 'light green stipules'
          },
          'fruit': {
            'path': 'assets/images/tenfruit.png',
            'image_paths': [
              'assets/images/tenfruit.png',
              'assets/images/tenfruit.png',
              'assets/images/tenfruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, short and thin',
            'color': 'green to purple when mature',
            'texture': 'finely rough, ridged',
            'size': '10.7 (7-15) cm long, 0.5-0.8 cm diameter',
            'description': 'calyx slightly reflexed; viviparous'
          },
        },
          {
          'path': 'assets/images/elevtree.png',
          'image_paths': [
            'assets/images/elevtree.png',
            'assets/images/elevtree.png',
            'assets/images/elevtree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'pototan; bakhaw (Antique), busain (Tagalog)',
          'scientific_name': 'Bruguiera gymnorrhiza',
          'description': 'Medium to large trees reaching 10 m high and 30 cm DBH, found on muddy substrate along riverbanks, sandy-muddy substrate in island mangroves, and compact mud in inner mangroves. They differ from the other Bruguiera species in that they have the largest leaves, flowers, propagules, and lenticels. B. gymnorrhiza has very heavy wood which was used in the past as timber for saltwater and foundation pilings, house posts, flooring, cabinetwork and furniture. It was also used as source of dyes for fishnets, ropes, sails and clothing and powdered bark (baluk) for the preparation of tuba, a popular drink made from coconut sap. Trees can survive partial debarking to obtain dye if limited to a small section of the trunk (see opposite page, bottom left photo). Present uses are charcoal and firewood, while the knee roots are utilized in planting rituals in Palanan, Isabela so cultivated tubers will grow big.',
          'summary': '',
          'root': {
            'path': 'assets/images/elevroot.png',
            'image_paths': [
              'assets/images/elevroot.png',
              'assets/images/elevroot.png',
              'assets/images/elevroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/elevflower.png',
            'image_paths': [
              'assets/images/elevflower.png',
              'assets/images/elevflower.png',
              'assets/images/elevflower.png',
            ],
            'name': '',
            'inflorescence':'single, axillary',
            'petals':'11-14, orange, notched, hairy',
            'sepals': '11-14, pink to red, fused',
            'stamen': '11-14 pairs',
            'size': '3-4 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/elevleaf.png',
            'image_paths': [
              'assets/images/elevleaf.png',
              'assets/images/elevleaf.png',
              'assets/images/elevleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acute to acuminate',
            'base': 'acute',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'waxy, light green',
            'size': '15 (10-20) cm long, 6 (4-8) cm wide',
            'description': 'reddish stipules'
          },
          'fruit': {
            'path': 'assets/images/elevfruit.png',
            'image_paths': [
              'assets/images/elevfruit.png',
              'assets/images/elevfruit.png',
              'assets/images/elevfruit.png',
            ],
            'name': '',
            'shape': 'cigar-like, long and stout',
            'color': 'dark green to purple when mature',
            'texture': 'finely rough, ridged',
            'size': '21.7 (19-25) cm long, 1-1.7 cm diameter',
            'description': 'calyx cap red, lobes free;viviparous'
          },
        },
           {
          'path': 'assets/images/tweltree.png',
          'image_paths': [
            'assets/images/tweltree.png',
            'assets/images/tweltree.png',
            'assets/images/tweltree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'hangalai, langarai, mangalai (Tagalog)',
          'scientific_name': 'Bruguiera parviflora',
          'description': 'Bruguiera parviflora forms solid stands of slender, tall trees reaching 15 m high. Among Bruguiera species, it has the darkest trunk, the most delicate flowers, and the finest leaves that appear stellate or star-shaped from a distance. The slender propagules have a distinctive calyx appressed to the fruit, unlike other Bruguiera spp. At first green and erect, the propagules become brown and pendulous when mature. The yellow-green leaves form a golden canopy in full sunlight. Older trees have cracked bark with reddish interior (see opposite page, bottom left photo). Like other Bruguiera species, past uses include saltwater and foundation pilings, house posts, flooring, cabinetwork and as a source of tannin.',
          'summary': '',
          'root': {
            'path': 'assets/images/twelroot.png',
            'image_paths': [
              'assets/images/twelroot.png',
              'assets/images/twelroot.png',
              'assets/images/twelroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/twelflower.png',
            'image_paths': [
              'assets/images/twelflower.png',
              'assets/images/twelflower.png',
              'assets/images/twelflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'white',
            'sepals': '8, yellow-green',
            'stamen': '',
            'size': '0.9-1.3 cm long, 0.4-0.6 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/twelleaf.png',
            'image_paths': [
              'assets/images/twelleaf.png',
              'assets/images/twelleaf.png',
              'assets/images/twelleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acuminate',
            'base': 'acute',
            'upperSurface': 'smooth, light green',
            'underSurface': 'waxy, pale green',
            'size': '8 (6-10) cm long, 3 (2-4) cm wide',
            'description': 'whitish to light yellow stipules'
          },
          'fruit': {
            'path': 'assets/images/twelfruit.png',
            'image_paths': [
              'assets/images/twelfruit.png',
              'assets/images/twelfruit.png',
              'assets/images/twelfruit.png',
            ],
            'name': '',
            'shape': 'pencil-like, tapered but blunt tip',
            'color': 'light green to brown when mature',
            'texture': 'smooth',
            'size': '14 (11-19) cm long, 4-6 cm diameter',
            'description': 'calyx fused, lobes appressed; viviparous'
          },
        },
        {
          'path': 'assets/images/tertree.png',
          'image_paths': [
            'assets/images/tertree.png',
            'assets/images/tertree.png',
            'assets/images/tertree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'pototan, karakandang (Antique)',
          'scientific_name': 'Bruguiera sexangula',
          'description': '',
          'summary': '',
          'root': {
            'path': 'assets/images/terroot.png',
            'image_paths': [
              'assets/images/terroot.png',
              'assets/images/terroot.png',
              'assets/images/terroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/terflower.png',
            'image_paths': [
              'assets/images/terflower.png',
              'assets/images/terflower.png',
              'assets/images/terflower.png',
            ],
            'name': '',
            'inflorescence':'single, axillary',
            'petals':'10-11, orange to brown',
            'sepals': '10-12, yellow-orange, fused',
            'stamen': '10-11 pairs',
            'size': '3-3.2 cm long, 1-2 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/terleaf.png',
            'image_paths': [
              'assets/images/terleaf.png',
              'assets/images/terleaf.png',
              'assets/images/terleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acuminate',
            'base': 'acute',
            'upperSurface': 'smooth, green',
            'underSurface': 'waxy, yellow-green',
            'size': '12 (8-15) cm long, 4 (3-6) cm wide',
            'description': 'pale green to yellowish stipules'
          },
          'fruit': {
            'path': 'assets/images/terfruit.png',
            'image_paths': [
              'assets/images/terfruit.png',
              'assets/images/terfruit.png',
              'assets/images/terfruit.png',
            ],
            'name': '',
            'shape': 'cigar-like, short and stout',
            'color': 'green to purple when mature',
            'texture': 'finely rough, ridged',
            'size': '7.7 (4-9) cm long, 1-2 cm diameter',
            'description': 'calyx lobes spreading; viviparous'
          },
        },
        {
          'path': 'assets/images/forttree.png',
          'image_paths': [
            'assets/images/forttree.png',
            'assets/images/forttree.png',
            'assets/images/forttree.png',
          ],
          'name': 'Bombacaceae ',
          'local_name': 'gapas-gapas',
          'scientific_name': 'Camptostemon philippinensis',
          'description': 'Also called Camptostemon philippinense, this species has small to medium-sized trees reaching 15 m tall and 50 cm DBH, along rivers and tidal creeks. The leaves are thick, covered with fine scales (like the buds and fruits), and crowded at the end. Surface roots emanate from the base of the trunk and spread out around mature trees - both the knobby roots and lower trunk have many lenticels and give the species a distinctive gnarled appearance. The capsule-shaped fruits have seeds covered by numerous thick white threads, hence the local name gapas-gapas meaning cotton (see opposite page, bottom left photo). The ground in a C. philippinensis grove appears white from the cottony threads of newly-fallen seeds. In Panay, the wood is used for fuel and elsewhere in the Philippines, for making household utensils and carvings.',
          'summary': '',
          'root': {
            'path': 'assets/images/fortroot.png',
            'image_paths': [
              'assets/images/fortroot.png',
              'assets/images/fortroot.png',
              'assets/images/fortroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/fortflower.png',
            'image_paths': [
              'assets/images/fortflower.png',
              'assets/images/fortflower.png',
              'assets/images/fortflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, terminal',
            'petals':'5, white to reddish brown',
            'sepals': '5, green',
            'stamen': '',
            'size': '1-1.3 cm diameter',
            'description': '3-4 flowers per cluster'
          },
          'leaf': {
            'path': 'assets/images/fortleaf.png',
            'image_paths': [
              'assets/images/fortleaf.png',
              'assets/images/fortleaf.png',
              'assets/images/fortleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'acute',
            'upperSurface': 'leathery, dark green',
            'underSurface': 'smooth, light green; with scales ',
            'size': '8 (5-9) cm long, 5 (3-7) cm wide',
            'description': 'fine salt crystals on leaves'
          },
          'fruit': {
            'path': 'assets/images/fortfruit.png',
            'image_paths': [
              'assets/images/fortfruit.png',
              'assets/images/fortfruit.png',
              'assets/images/fortfruit.png',
            ],
            'name': '',
            'shape': 'rounded, dehiscent',
            'color': 'green to brown',
            'texture': 'cottony inside',
            'size': '1-2 cm long, 7 cm diameter',
            'description': 'attractive to big red ants'
          },
        },
        {
          'path': 'assets/images/fifthtree.png',
          'image_paths': [
            'assets/images/fifthtree.png',
            'assets/images/fifthtree.png',
            'assets/images/fifthtree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'baras-baras, lapis-lapis, malatangal (Tagalog)',
          'scientific_name': 'Ceriops decandra',
          'description': 'Shrubs reaching 3 m tall that grow on the compact mud or sandy-mud of inner mangroves. This pioneer species occurs as monospecific stands that provide the leading edge of mangrove invasion of grasslands, up to the high tide limit (see opposite page, bottom left photo), but may also form the understory portion of a mixed mangrove community. Ceriops decandra differs from C. tagal by its shorter height, multiple stems, and shorter fruits (with red cotyledonary collar) that point in all directions. Roots have small flaky buttresses that give the trunk a swollen appearance. Commonly used as firewood, and as Christmas trees in Luzon. The bark of mature trees is harvested for the baluk powder used in making local tuba, although the preferred species is C. tagal.',
          'summary': '',
          'root': {
            'path': 'assets/images/fifthroot.png',
            'image_paths': [
              'assets/images/fifthroot.png',
              'assets/images/fifthroot.png',
              'assets/images/fifthroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/fifthflower.png',
            'image_paths': [
              'assets/images/fifthflower.png',
              'assets/images/fifthflower.png',
              'assets/images/fifthflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'5, white, with hairs',
            'sepals': '5, light green, fused',
            'stamen': '',
            'size': '0.3-0.5 cm diameter',
            'description': '6-8 flowers per cluster, on short thick stalks '
          },
          'leaf': {
            'path': 'assets/images/fifthleaf.png',
            'image_paths': [
              'assets/images/fifthleaf.png',
              'assets/images/fifthleaf.png',
              'assets/images/fifthleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'mostly obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'acute',
            'upperSurface': 'smooth, green',
            'underSurface': 'smooth, light green',
            'size': '7 (4-10) cm long, 4 (3-8) cm wide',
            'description': ''
          },
          'fruit': {
            'path': 'assets/images/fifthfruit.png',
            'image_paths': [
              'assets/images/fifthfruit.png',
              'assets/images/fifthfruit.png',
              'assets/images/fifthfruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, pencil-shaped',
            'color': 'green to brown when mature',
            'texture': 'smooth, slender, slightly ribbed',
            'size': '13.5 (10-18) cm long, 0.5-0.9 cm diameter',
            'description': 'reddish brown cotyledonary collar (see inset)'
          },
        },
         {
          'path': 'assets/images/sixthtree.png',
          'image_paths': [
            'assets/images/sixthtree.png',
            'assets/images/sixthtree.png',
            'assets/images/sixthtree.png',
          ],
          'name': ' Rhizophoraceae ',
          'local_name': 'tungog, tangal, tagasa (Tagalog)',
          'scientific_name': 'Ceriops tagal',
          'description': 'Small trees reaching 6 m tall, on firm sandy to muddy substrates of inner mangroves. Compared to C. decandra, trees are taller with a single straight trunk, and longer fruits point downwards. Leaves turn yellowish green in sunlight. Roots have small flaky buttresses; knee roots appear in older trees. Among the Rhizophoraceae, the dried C. tagal bark gives the best quality baluk powder used in making tuba, bahalina (a special tuba variety in Leyte and Samar), and basi (rice wine), and in dyeing fish nets and clothing. Wood is used for fuel, charcoal, poles for baklad (fish corrals) and house posts. In the past, big trees provided hard, fine-textured wood for furniture and house construction. The bark was used to treat hemorrhages and ulcers; older folks chewed on dried bark. Only isolated trees of C. tagal are found in Panay, aside from a small 20-year old plantation in Naisud, Ibajay, Aklan.',
          'summary': '',
          'root': {
            'path': 'assets/images/sixthroot.png',
            'image_paths': [
              'assets/images/sixthroot.png',
              'assets/images/sixthroot.png',
              'assets/images/sixthroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/sixthflower.png',
            'image_paths': [
              'assets/images/sixthflower.png',
              'assets/images/sixthflower.png',
              'assets/images/sixthflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4-6, white, with brown hairs',
            'sepals': '4-6, light green, fused',
            'stamen': '4-6, brown tip',
            'size': '0.6-0.9 cm long, 0.6-0.9 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/sixthleaf.png',
            'image_paths': [
              'assets/images/sixthleaf.png',
              'assets/images/sixthleaf.png',
              'assets/images/sixthleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'mostly obovate',
            'margin': 'entire - smooth, curl downwards',
            'apex': 'round',
            'base': 'acute',
            'upperSurface': 'smooth, green to yellow green',
            'underSurface': 'smooth, yellow green',
            'size': '8 (5-12) cm long, 4 (2-6) cm wide',
            'description': 'leaves directed upward, brittle'
          },
          'fruit': {
            'path': 'assets/images/sixthfruit.png',
            'image_paths': [
              'assets/images/sixthfruit.png',
              'assets/images/sixthfruit.png',
              'assets/images/sixthfruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, pencil-shaped',
            'color': 'dark green to brown when mature',
            'texture': 'ridged, with a few warts',
            'size': '20.5 (16-30) cm long, 0.6-1 cm diameter',
            'description': 'pendulous, calyx spread, yellow cotyledonary collar (inset)'
          },
        },
        {
          'path': 'assets/images/sevthtree.png',
          'image_paths': [
            'assets/images/sevthtree.png',
            'assets/images/sevthtree.png',
            'assets/images/sevthtree.png',
          ],
          'name': ' Euphorbiaceae ',
          'local_name': ' lipata, alipata (Visayan), buta-buta (Cebuano)',
          'scientific_name': 'Excoecaria agallocha',
          'description': 'Small to medium trees with surface roots on sandy-muddy substrate along tidal creeks or on hard mud in the inner mangroves and along dikes of ponds. The leaves are highly variable in size, shape and color. They fall off in the dry season just before the flowers appear, but sometimes flowering trees show leaves. The only dioecious mangrove species, female and male plants can be distinguished during the reproductive period. Male flowers in full bloom, which are longer than those of females, present a spectacular but short-lived sight of numerous golden catkins hanging from bare branches. The twigs are used as pest repellent, burnt ashes for salt extraction, and leaves to treat epilepsy. Its milky sap, which flows from any cut surface on the leaf, twig or trunk can cause skin irritation and alleged blindness, hence the local name butabuta. The sap is used to treat toothache and ulcers, and as fish poison.',
          'summary': '',
          'root': {
            'path': 'assets/images/sevthroot.png',
            'image_paths': [
              'assets/images/sevthroot.png',
              'assets/images/sevthroot.png',
              'assets/images/sevthroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/sevthflower.png',
            'image_paths': [
              'assets/images/sevthflower.png',
              'assets/images/sevthflower.png',
              'assets/images/sevthflower.png',
            ],
            'name': '',
            'inflorescence':'catkin, axillary',
            'petals':'yellow (male & female)',
            'sepals': '',
            'stamen': 'yellow (male & female)',
            'size': 'male 1.9-3.0 cm long, female 0.3-0.7 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/sevthleaf.png',
            'image_paths': [
              'assets/images/sevthleaf.png',
              'assets/images/sevthleaf.png',
              'assets/images/sevthleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'elliptical',
            'margin': 'entire - smooth',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'smooth, green',
            'underSurface': 'smooth, light green',
            'size': '5 (3-8) cm long, 3 (2-4) cm wide',
            'description': 'white milky sap, deciduous'
          },
          'fruit': {
            'path': 'assets/images/sevthfruit.png',
            'image_paths': [
              'assets/images/sevthfruit.png',
              'assets/images/sevthfruit.png',
              'assets/images/sevthfruit.png',
            ],
            'name': '',
            'shape': 'rounded with 3 lobes',
            'color': 'green, brown when mature',
            'texture': 'green, brown when mature',
            'size': '0.4-0.6 cm diameter',
            'description': 'short style splits into 3 curling strands'
          },
        },
        {
          'path': 'assets/images/eytitree.png',
          'image_paths': [
            'assets/images/eytitree.png',
            'assets/images/eytitree.png',
            'assets/images/eytitree.png',
          ],
          'name': ' Sterculiaceae ',
          'local_name': 'dungon, dungon-late',
          'scientific_name': 'Heritiera littoralis',
          'description': 'Medium-sized trees up to 20 m high found in back mangroves, often on dry land along forest margins. The big, dark green leaves have a characteristic silvery-white undersurface, and the hard, shiny fruits are boat-shaped with a ridge. Prominent buttress roots have flattened extensions, called plank roots, that criss-cross the substrate. These buttresses reach ~ 3 m high in the magnificent Heritiera littoralisstand in Iriomote, Okinawa, southern Japan (S. Baba, personal communication). The species is widely distributed in the Philippines - evidence of its previous abundance are two neighboring barangays both named Dungon in Jaro, Iloilo City. Past uses of the hard, heavy wood include piles, bridges and wharves. The pre-Hispanic balanghaiboats excavated from Agusan del Norte were made of dungon. Roots used as fish poison, seed extracts to treat diarrhea and dysentery.',
          'summary': '',
          'root': {
            'path': 'assets/images/eytiroot.png',
            'image_paths': [
              'assets/images/eytiroot.png',
              'assets/images/eytiroot.png',
              'assets/images/eytiroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/eytiflower.png',
            'image_paths': [
              'assets/images/eytiflower.png',
              'assets/images/eytiflower.png',
              'assets/images/eytiflower.png',
            ],
            'name': '',
            'inflorescence':'panicle, axillary',
            'petals':'none',
            'sepals': '4, hairy, pink-red inside, yellow green outside,',
            'stamen': '',
            'size': '0.3-0.5 cm diameter',
            'description': '0.3-0.5 cm diameter'
          },
          'leaf': {
            'path': 'assets/images/eytileaf.png',
            'image_paths': [
              'assets/images/eytileaf.png',
              'assets/images/eytileaf.png',
               'assets/images/eytileaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'elliptical to oblong',
            'margin': 'entire - undulate',
            'apex': 'acute',
            'base': 'acute to round',
            'upperSurface': 'leathery, dark green',
            'underSurface': 'tiny scales, silvery',
            'size': '',
            'description': ''
          },
          'fruit': {
            'path': 'assets/images/eytifruit.png',
            'image_paths': [
              'assets/images/eytifruit.png',
              'assets/images/eytifruit.png',
              'assets/images/eytifruit.png',
            ],
            'name': '',
            'shape': 'boat-shaped',
            'color': 'green to brown',
            'texture': 'shiny, hard',
            'size': '5-9 cm long,4-6 cm diameter',
            'description': 'central ridge or keel'
          },
        },
            {
          'path': 'assets/images/ninethtree.png',
          'image_paths': [
            'assets/images/ninethtree.png',
            'assets/images/ninethtree.png',
            'assets/images/ninethtree.png',
          ],
          'name': 'Rhizophoraceae',
          'local_name': 'angal',
          'scientific_name': 'Kandelia candel',
          'description': 'Kandelia candel has been found in only two sites in the Philippines - Castillo, Baler (~ 10 specimens) and Cozo, Casiguran Bay – both in Aurora Province on the eastern side of Luzon. It was first identified in May 1996 (Zisman et al., 1998). Except for this report, K. candel is not mentioned in any of the published lists of Philippine mangrove species. The Aurora plants are small, slender trees up to 5 m tall on muddy substrate along tidal creeks and rivers where they are associated with N. fruticans and S. alba. In other Southeast Asian countries, the trees are reported to be taller, with bigger buttresses, prop roots and pneumatophores.',
          'summary': '',
          'root': {
            'path': 'assets/images/ninethroot.png',
            'image_paths': [
              'assets/images/ninethroot.png',
              'assets/images/ninethroot.png',
              'assets/images/ninethroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/ninethflower.png',
            'image_paths': [
              'assets/images/ninethflower.png',
              'assets/images/ninethflower.png',
              'assets/images/ninethflower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4-5, white, thin',
            'sepals': '4-5, reflexed',
            'stamen': 'numerous, white',
            'size': '1.5-2 cm long',
            'description': '2 flowers per cluster '
          },
          'leaf': {
            'path': 'assets/images/ninethleaf.png',
            'image_paths': [
              'assets/images/ninethleaf.png',
              'assets/images/ninethleaf.png',
              'assets/images/ninethleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'oblong to elliptic',
            'margin': 'entire - smooth',
            'apex': 'obtuse to round',
            'base': 'acute',
            'upperSurface': 'smooth, yellow green to green',
            'underSurface': 'smooth, green',
            'size': '10-16 cm long, 3-5 cm wide',
            'description': 'stipule reddish to yellow, prominent midrib'
          },
          'fruit': {
            'path': 'assets/images/ninethfruit.png',
            'image_paths': [
              'assets/images/ninethfruit.png',
              'assets/images/ninethfruit.png',
              'assets/images/ninethfruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, slender, tapering with pointed tip',
            'color': 'yellow green to green',
            'texture': 'smooth',
            'size': '20-30 cm long, ~ 1 cm diameter',
            'description': 'long (3-4 cm) peduncle; sepals persistent on calyx cap; viviparous'
          },
        },
        {
          'path': 'assets/images/twentree.png',
          'image_paths': [
            'assets/images/twentree.png',
            'assets/images/twentree.png',
            'assets/images/twentree.png',
          ],
          'name': 'Combretaceae ',
          'local_name': 'tabao, libato (Tagalog)',
          'scientific_name': 'Lumnitzera littorea',
          'description': 'Medium to tall trees reaching 12 m high in stands along tidal creeks and on muddy to sandy-muddy substrates of back mangroves. In Palawan, a natural stand provides shade to a multispecies mangrove nursery (see opposite page, bottom left photo). Lumnitzera littorea is easily differentiated from L. racemosa by its bigger size, darker green leaves, and bright red flowers whose buds look like small lipsticks. The beautiful decorative flowers make L. littorea suitable for planting in beach resorts. Old L. littoreatrees in a small pristine mangrove patch in Jawili, Tangalan, Aklan have branches bent close to the ground and a dark trunk that is crooked. Branches can be used for fuel and for smoking fish. A decoction of the leaves is used to treat thrush in infants. In the past, the hard, strong wood was used for heavy construction - bridges, wharves, ships, cart axles, flooring and furniture.',
          'summary': '',
          'root': {
            'path': 'assets/images/twenroot.png',
            'image_paths': [
              'assets/images/twenroot.png',
              'assets/images/twenroot.png',
              'assets/images/twenroot.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/twenflower.png',
            'image_paths': [
              'assets/images/twenflower.png',
              'assets/images/twenflower.png',
              'assets/images/twenflower.png',
            ],
            'name': '',
            'inflorescence':'spike, axillary',
            'petals':'5, bright red',
            'sepals': '5, green, fused',
            'stamen': '10, red filaments, yellow pollen',
            'size': '1-3 cm long, 0.1-0.3 cm diameter ',
            'description': 'stamens longer than petals'
          },
          'leaf': {
            'path': 'assets/images/twenleaf.png',
            'image_paths': [
              'assets/images/twenleaf.png',
              'assets/images/twenleaf.png',
              'assets/images/twenleaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'sessile',
            'upperSurface': 'smooth, green',
            'underSurface': 'smooth, green',
            'size': '6 (4-9) cm long, 2 (1-4) cm wide ',
            'description': 'succulent, brittle'
          },
          'fruit': {
            'path': 'assets/images/twenfruit.png',
            'image_paths': [
              'assets/images/twenfruit.png',
              'assets/images/twenfruit.png',
              'assets/images/twenfruit.png',
            ],
            'name': '',
            'shape': 'vase-shaped',
            'color': 'dark green, reddish base',
            'texture': 'smooth',
            'size': '1-2 cm long, 0.3-0.7 cm diameter ',
            'description': 'succulent'
          },
        },
        {
          'path': 'assets/images/21tree.png',
          'image_paths': [
            'assets/images/21tree.png',
            'assets/images/21tree.png',
            'assets/images/21tree.png',
          ],
          'name': ' Combretaceae',
          'local_name': 'tabao, culasi, bolali (Negros Occidental)',
          'scientific_name': 'Lumnitzera racemosa',
          'description': 'A pioneering species of small trees up to 6 m high often found in the muddy back mangrove where it forms thick stands and on sandy beaches near the high water line. It has multiple stems, surface roots and succulent leaves with many conspicuous insect bites; older trees have a single trunk and looping roots. Lumnitzera racemosa is so widely distributed that many Philippine towns and villages are named after it (Table 8). Interestingly, the two sister species are rarely found together, except in Naisud, Ibajay, Aklan. Aside from firewood, the dried twigs are used as fish-aggregating devices and the leaves as forage for livestock. The trunks of bigger trees are used as house posts. Villagers in Taba-ao, Sagay, Negros Occid. use both cut stems, and planted L. racemosainterspersed with B. cylindrica, to form a living fence around their dwellings (see opposite, bottom left photos). It is also planted along dikes of fishponds.',
          'summary': '',
          'root': {
            'path': 'assets/images/21root.png',
            'image_paths': [
              'assets/images/21root.png',
              'assets/images/21root.png',
              'assets/images/21root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/21flower.png',
            'image_paths': [
              'assets/images/21flower.png',
              'assets/images/21flower.png',
              'assets/images/21flower.png',
            ],
            'name': '',
            'inflorescence':'spike, axillary',
            'petals':'5, white',
            'sepals': '5, green, fused',
            'stamen': '10, pale yellow',
            'size': '1-1.6 cm long, 0.6-1 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/21leaf.png',
            'image_paths': [
              'assets/images/21leaf.png',
              'assets/images/21leaf.png',
              'assets/images/21leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, alternate, spiral',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'emarginate to round',
            'base': 'sessile',
            'upperSurface': 'smooth, light green',
            'underSurface': 'smooth, light green',
            'size': '6 (4-9) cm long, 2 (2-4) cm wide',
            'description': 'succulent'
          },
          'fruit': {
            'path': 'assets/images/21fruit.png',
            'image_paths': [
              'assets/images/21fruit.png',
              'assets/images/21fruit.png',
              'assets/images/21fruit.png',
            ],
            'name': '',
            'shape': 'pitcher-like',
            'color': 'green',
            'texture': 'smooth, waxy',
            'size': '1.1-1.8 cm long, 0.5-0.7 cm diameter',
            'description': 'one side slightly bulging, the other side flat'
          },
        },
        {
          'path': 'assets/images/22tree.png',
          'image_paths': [
            'assets/images/22tree.png',
            'assets/images/22tree.png',
            'assets/images/22tree.png',
          ],
          'name': 'Palmae',
          'local_name': 'nipa, sapsap, sasa (Tagalog)',
          'scientific_name': 'Nypa fruticans',
          'description': 'The only palm among true mangrove species, Nypa fruticans forms extensive belts along muddy edges of brackish to almost freshwater creeks and rivers. Individual plants are also found in mixed mangrove communities. It has creeping stems called rhizomes from which tall (up to 8 m high) compound leaves arise. Commercially important, its products include the local drink tuba, vinegar and alcohol from the sap of the inflorescence (see opposite, bottom left photo); roofing material, native hats (salakot), raincoats, baskets, bags, mats, and wrappers from leaflets; and brooms from midribs. The fruit endosperm is eaten fresh or cooked, and the trunk pith is prepared as salad. The Sanskrit name Nypatithau was that of a generous man who gave everything of himself. Coincidentally, Nypa was first applied in Indonesia to this palm species, which gives of its every useful part so to speak (M. Vannucci, personal communication).',
          'summary': '',
          'root': {
            'path': 'assets/images/22root.png',
            'image_paths': [
              'assets/images/22root.png',
              'assets/images/22root.png',
              'assets/images/22root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/22flower.png',
            'image_paths': [
              'assets/images/22flower.png',
              'assets/images/22flower.png',
              'assets/images/22flower.png',
            ],
            'name': '',
            'inflorescence':'catkin, axillary',
            'petals':'yellow to orange',
            'sepals': 'orange',
            'stamen': 'yellow',
            'size': '',
            'description': 'dimorphic'
          },
          'leaf': {
            'path': 'assets/images/22leaf.png',
            'image_paths': [
              'assets/images/22leaf.png',
              'assets/images/22leaf.png',
              'assets/images/22leaf.png',
            ],
            'name': '',
            'arrangement': 'compound, odd pinnate',
            'bladeShape': 'lanceolate leaflet',
            'margin': 'entire - smooth',
            'apex': 'acute',
            'base': 'sessile leaflet',
            'upperSurface': 'smooth, green',
            'underSurface': 'powdery, light green',
            'size': '40-120 cm long, 4-9 cm wide',
            'description': '80-120 leaflets per leaf 10-20 leaves per cluster'
          },
          'fruit': {
            'path': 'assets/images/22fruit.png',
            'image_paths': [
              'assets/images/22fruit.png',
              'assets/images/22fruit.png',
              'assets/images/22fruit.png',
            ],
            'name': '',
            'shape': 'ball-shaped cluster of fruits',
            'color': 'light to dark brown',
            'texture': 'individual fruit smooth, shiny',
            'size': '20-40 cm diameter (cluster)',
            'description': 'meat (endosperm) edible'
          },
        },
        {
          'path': 'assets/images/23tree.png',
          'image_paths': [
            'assets/images/23tree.png',
            'assets/images/23tree.png',
            'assets/images/23tree.png',
          ],
          'name': '  Myrtaceae',
          'local_name': 'bunot-bunot, tawalis, dukduk (Negros)',
          'scientific_name': 'Osbornia octodonta',
          'description': 'Shrubs to small trees reaching 6 m tall with surface roots, often with multiple irregular stems. They can tolerate high salinity and are found in stands on the high tide line on exposed rocky and sandy shores or the sheltered elevated flats of the foreshore. Osbornia octodonta is sometimes associated with other high shore species like P. acidula and A. floridum, and shares a superficial resemblance with the latter. It has small, brittle leaves which emit an aroma when crushed, small white flowers, capsuleshaped fruits, deeply fissured bark and cable roots often exposed on rocky shores. Aside from fuelwood, the dried twigs (see opposite page, bottom left photo) are made into baskets and used as fish-aggregating devices by local fishers.',
          'summary': '',
          'root': {
            'path': 'assets/images/23root.png',
            'image_paths': [
              'assets/images/23root.png',
              'assets/images/23root.png',
              'assets/images/23root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/23flower.png',
            'image_paths': [
              'assets/images/23flower.png',
              'assets/images/23flower.png',
              'assets/images/23flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'apetalous',
            'sepals': 'yellow green, fused',
            'stamen': 'numerous, white; yellow pollen',
            'size': '0.5-1 cm long,0.2-0.5 cm diameter',
            'description': 'usually 3 flowers per cluster'
          },
          'leaf': {
            'path': 'assets/images/23leaf.png',
            'image_paths': [
              'assets/images/23leaf.png',
              'assets/images/23leaf.png',
              'assets/images/23leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'emarginate',
            'base': 'sessile',
            'upperSurface': 'smooth, pale green',
            'underSurface': 'smooth, pale green',
            'size': '4 (3-6) cm long, 2 (1-3) cm wide',
            'description': 'thin, brittle'
          },
          'fruit': {
            'path': 'assets/images/23fruit.png',
            'image_paths': [
              'assets/images/23fruit.png',
              'assets/images/23fruit.png',
              'assets/images/23fruit.png',
            ],
            'name': '',
            'shape': 'capsule',
            'color': 'pale green',
            'texture': 'hairy (dense)',
            'size': '0.7-1 cm long,0.3-0.5 cm diameter',
            'description': 'calyx completely encases fruit'
          },
        },   
        {
          'path': 'assets/images/24tree.png',
          'image_paths': [
            'assets/images/24tree.png',
            'assets/images/24tree.png',
            'assets/images/24tree.png',
          ],
          'name': ' Lythraceae',
          'local_name': 'bantigi',
          'scientific_name': 'Pemphis acidula',
          'description': 'Shrubs 3-5 m tall, along the high tide line of coralline-rocky and sandy foreshores, often in association with O. octodonta and A. f loridum. It has irregularly shaped branches, small leaves, and small white flowers. Distribution in Panay is limited to small stands in Carles, Iloilo; Taklong Island, Guimaras; and Anini-y, Antique. The twigs are used for fuel and also as fish-aggregating devices, like O. octodonta. Wood of Pemphis acidula is very hard and strong, hence it is used in house and fence construction. Because of its small size and sturdy nature, the species is a favorite material of bonsai enthusiasts (see opposite, bottom left photo). Some ten years ago, the Department of Environment and Natural Resources confiscated specimens collected from Nogas Is., Antique which were to be smuggled to Taiwan and sold at Philippine Pesos (PhP) 2,000 per plant.',
          'summary': '',
          'root': {
            'path': 'assets/images/24root.png',
            'image_paths': [
              'assets/images/24root.png',
              'assets/images/24root.png',
              'assets/images/24root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/24flower.png',
            'image_paths': [
              'assets/images/24flower.png',
              'assets/images/24flower.png',
              'assets/images/24flower.png',
            ],
            'name': '',
            'inflorescence':'single, axillary',
            'petals':'6, white',
            'sepals': '12, fused',
            'stamen': '12',
            'size': '0.7-1 cm long, 0.9-1.8 cm diameter',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/24leaf.png',
            'image_paths': [
              'assets/images/24leaf.png',
              'assets/images/24leaf.png',
              'assets/images/24leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'elliptical',
            'margin': 'entire - smooth',
            'apex': 'acute to obtuse',
            'base': 'acute',
            'upperSurface': 'velvety, pale green',
            'underSurface': 'velvety, whitish green',
            'size': '2-3 cm long, 1 cm wide',
            'description': 'covered with minute hairs'
          },
          'fruit': {
            'path': 'assets/images/24fruit.png',
            'image_paths': [
              'assets/images/24fruit.png',
              'assets/images/24fruit.png',
              'assets/images/24fruit.png',
            ],
            'name': '',
            'shape': 'capsule',
            'color': 'brown',
            'texture': 'smooth',
            'size': '0.4-0.9 cm long, 0.3-0.6 cm diameter',
            'description': 'fruit encased in a bell-like structure'
          },
        },
        {
          'path': 'assets/images/25tree.png',
          'image_paths': [
            'assets/images/25tree.png',
            'assets/images/25tree.png',
            'assets/images/25tree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'bakhaw, bakhaw lalaki, bulubaladaw (Antique)',
          'scientific_name': 'Rhizophora apiculata',
          'description': 'Medium to tall trees reaching 20 m on loose mud of tidal rivers and creeks, and sandy mud of the seaward zone behind the outer 5. alba-A. marina band where Rhizophoraapiculata forms monospecific stands. Its wide distribution in Panay and elsewhere in the Philippines is due to its pioneering nature and popularity for replanting. It is the preferred species for plantations because of availability of propagules and fast growth. The inflorescence usually bears 2 sessile flowers on a very short peduncle. The buds are compact and used by children as bullets for toy guns. The fruits are long, smooth and viviparous. The leaves are dark green and flat, and may be fed to pigs (see opposite page, bottom left photo); the interpetiolary stipules are dark pink to red. ',
          'summary': '',
          'root': {
            'path': 'assets/images/25root.png',
            'image_paths': [
              'assets/images/25root.png',
              'assets/images/25root.png',
              'assets/images/25root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/25flower.png',
            'image_paths': [
              'assets/images/25flower.png',
              'assets/images/25flower.png',
              'assets/images/25flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4, white',
            'sepals': '4, yellow to red outside',
            'stamen': '12, brown',
            'size': '1.2-1.4 cm long',
            'description': '2 flowers per duster, no style'
          },
          'leaf': {
            'path': 'assets/images/25leaf.png',
            'image_paths': [
              'assets/images/25leaf.png',
              'assets/images/25leaf.png',
              'assets/images/25leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'apiculate',
            'base': 'acute',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'smooth, green',
            'size': '13 (9-10) cm long, 5 (4-7) cm wide',
            'description': 'stipules dark red'
          },
          'fruit': {
            'path': 'assets/images/25.png',
            'image_paths': [
              'assets/images/25fruit.png',
              'assets/images/25fruit.png',
              'assets/images/25fruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, straight',
            'color': 'dark green',
            'texture': 'smooth',
            'size': '24 (22-26) cm long, 0.9-1 cm diameter',
            'description': 'viviparous; short ( ~ 1 cm) peduncle so the upper part tends to be curved; yellowish cotelydonary collar'
          },
        },
        {
          'path': 'assets/images/26tree.png',
          'image_paths': [
            'assets/images/26tree.png',
            'assets/images/26tree.png',
            'assets/images/26tree.png',
          ],
          'name': ' Rhizophoraceae',
          'local_name': 'bakhaw',
          'scientific_name': 'Rhizophora x lamarckii',
          'description': 'A sterile hybrid of Rhizophora apiculata x R. stylosa, this species can be found on the sandy-muddy substrate along the seaward fringe of protected islands. The trees are usually isolated but close to the parent plants. The characters are the same as R. apiculata - reddish interpetiolary stipules but slightly longer peduncles with two flowers each which never develop into fruits. The buds look like those of R. apiculataand the style is shorter than in R. stylosa. A single specimen has been found in the Taklong Island National Marine Reserve, Nueva Valencia, Guimaras (10°24’22.46” N, 122°30’46.26” E). This hybrid has also been reported by Yao (1999) from various sites in central Visayas – Okiot, Dewey Is., Bais and Tinguib, Ayongon both in Negros Oriental; Pagangan Is., Calape and Handayan Is., Getafe both in Bohol; and Taug, Carcar, Cebu.',
          'summary': '',
          'root': {
            'path': 'assets/images/26root.png',
            'image_paths': [
              'assets/images/26root.png',
              'assets/images/26root.png',
              'assets/images/26root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/26flower.png',
            'image_paths': [
              'assets/images/26flower.png',
              'assets/images/26flower.png',
              'assets/images/26flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4, white, hairy',
            'sepals': '4, yellowish',
            'stamen': '',
            'size': '1.1-1.4 cm long',
            'description': '2 flowers per cluster, longer (2-3 cm) peduncle, sterile'
          },
          'leaf': {
            'path': 'assets/images/26leaf.png',
            'image_paths': [
              'assets/images/26leaf.png',
              'assets/images/26leaf.png',
              'assets/images/26leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'apiculate',
            'base': 'acute',
            'upperSurface': 'waxy, dark green',
            'underSurface': 'smooth, yellow green',
            'size': '13-15 cm long, 5-6 cm wide',
            'description': 'stipules reddish'
          },
          'fruit': {
            'path': '',
            'image_paths': [
              'assets/images/fruit.png',
              'assets/images/fruit.png',
              'assets/images/fruit.png',
            ],
            'name': '',
            'shape': '',
            'color': '',
            'texture': '',
            'size': '',
            'description': ''
          },
        },
           {
          'path': 'assets/images/27tree.png',
          'image_paths': [
            'assets/images/27tree.png',
            'assets/images/27tree.png',
            'assets/images/27tree.png',
          ],
          'name': '  Rhizophoraceae',
          'local_name': 'bakhaw, bakhaw babae',
          'scientific_name': 'Rhizophora mucronata ',
          'description': 'Medium to big trees reaching 15 m in Panay (but 30 m in Aurora and other provinces). Its wide distribution overlaps with other Rhizophora species although R. mucronata is more strongly associated with the soft muds of estuarine rivers and tidal creeks. In the seaward fringe, it is typically found behind R. apiculata, the “front-line” species. R. mucronata has broader leaves with yellow to light green stipules, pendulous flowers, and long warty propagules. It is favored for fuelwood and charcoal because of its high heating value, like other Rhizophora species. In the past, it was cultivated with R. apiculata in fuelwood plantations around Manila and sold on the street (see opposite, bottom left photo). The dried hypocotyls were smoked as cigars. In the 1950s-70s, wood chips from these two species were exported from the Philippines, Malaysia and other Southeast Asian countries to Japanese rayon fiber factories.',
          'summary': '',
          'root': {
            'path': 'assets/images/27root.png',
            'image_paths': [
              'assets/images/27root.png',
              'assets/images/27root.png',
              'assets/images/27root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/27flower.png',
            'image_paths': [
              'assets/images/27flower.png',
              'assets/images/27flower.png',
              'assets/images/27flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4, white, hairy',
            'sepals': '4, light yellow',
            'stamen': '8, brown',
            'size': '1.2-2 cm long, 1-1.5 cm diameter',
            'description': '3-5 cm long peduncle, 2-6 flowers per cluster, 1 mm style'
          },
          'leaf': {
            'path': 'assets/images/27leaf.png',
            'image_paths': [
              'assets/images/27leaf.png',
              'assets/images/27leaf.png',
              'assets/images/27leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'mucronate',
            'base': 'acute',
            'upperSurface': ' smooth, dark green',
            'underSurface': ' smooth, dark green',
            'size': '14 (11-19) cm long, 7 (6-10) cm wide',
            'description': 'black dots, light green stipules'
          },
          'fruit': {
            'path': 'assets/images/27fruit.png',
            'image_paths': [
              'assets/images/27fruit.png',
              'assets/images/27fruit.png',
              'assets/images/27fruit.png',
            ],
            'name': '',
            'shape': 'cylindrical',
            'color': 'dark green',
            'texture': 'warty',
            'size': '57 (34-70) cm long, 1-2 cm diameter',
            'description': 'viviparous; yellow collar'
          },
        },
          {
          'path': 'assets/images/28tree.png',
          'image_paths': [
            'assets/images/28tree.png',
            'assets/images/28tree.png',
            'assets/images/28tree.png',
          ],
          'name': '  Rhizophoraceae',
          'local_name': 'bakhaw, bakhaw bato, bangkao',
          'scientific_name': 'Rhizophora stylosa ',
          'description': 'Small to medium trees up to 10 m high. Widely distributed, Rhizophora stylosa overlaps with the habitat of R. apiculata but prefers sandy and rocky intertidal shores. Leaves have sides which typically curl or roll downward, differentiating it from other Rhizophora species; the leaves on terminal branches slant or point upward. Like other mangroves, the roots are often overgrown by epiphytic algae (see opposite page, bottom right photo). Uses for fuelwood and dyes are similar to other Rhizophora species. It is also favored for planting - the provincial government of Antique provided funds for the almost yearly procurement from 1995 to 2001 of more than 70,000 R. stylosapropagules from Semirara Island for planting in Lipata, ',
          'summary': '',
          'root': {
            'path': 'assets/images/28root.png',
            'image_paths': [
              'assets/images/28root.png',
              'assets/images/28root.png',
              'assets/images/28root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/28flower.png',
            'image_paths': [
              'assets/images/28flower.png',
              'assets/images/28flower.png',
              'assets/images/28flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4, white, hairy',
            'sepals': '4, light yellow',
            'stamen': '8, brown',
            'size': '1.1-1.5 cm long, 1.4-2 cm diameter',
            'description': '~ 7 flowers per cluster, long peduncle, 6 mm style'
          },
          'leaf': {
            'path': 'assets/images/28leaf.png',
            'image_paths': [
              'assets/images/28leaf.png',
              'assets/images/28leaf.png',
              'assets/images/28leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'apiculate',
            'base': 'acute',
            'upperSurface': 'waxy, light green',
            'underSurface': 'smooth, yellow green',
            'size': '11 (8-14) cm long, 5 (3-7) cm wide',
            'description': 'leaves point upward, sides curling; stipules light green'
          },
          'fruit': {
            'path': 'assets/images/28fruit.png',
            'image_paths': [
              'assets/images/28fruit.png',
              'assets/images/28fruit.png',
              'assets/images/28fruit.png',
            ],
            'name': '',
            'shape': 'cylindrical, straight',
            'color': 'light green to green',
            'texture': 'warty',
            'size': '34 (26-42) cm long, 1-2 cm diameter',
            'description': 'viviparous; greenish collar'
          },
        },
          {
          'path': 'assets/images/29tree.png',
          'image_paths': [
            'assets/images/29tree.png',
            'assets/images/29tree.png',
            'assets/images/29tree.png',
          ],
          'name': '  Sonneratiaceae',
          'local_name': 'pagatpat',
          'scientific_name': 'Sonneratia alba',
          'description': 'Pioneering species of medium to large trees that co-occur with A. marina in fringing mangroves, but are dominant in more coralline-sandy substrates. Leaves are obovate to rounded, but those of seedlings and lowermost branches ~1 m aboveground are more elongated (see opposite, bottom left photo). The short-lived white flowers open at dusk and drop at dawn - standing in a Sonneratia alba grove as numerous white filaments fall from the canopy with the early morning breeze is a magical experience. This species hosts colonies of fireflies - a northern Agusan settlement was called Masawa (now Masao), meaning bright, from the insects sparkling lights that greeted seafarers on moonless nights. Likewise, the Spanish name of Siquijor Is. was Isla del Fuego, referring to the pagatpat-lined shore seemingly on fire. Past uses include housing construction materials, furnishing, and musical instruments. Due to salt content, woodwork required copper nails and screws.',
          'summary': '',
          'root': {
            'path': 'assets/images/29root.png',
            'image_paths': [
              'assets/images/29root.png',
              'assets/images/29root.png',
              'assets/images/29root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/29flower.png',
            'image_paths': [
              'assets/images/29flower.png',
              'assets/images/29flower.png',
              'assets/images/29flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, terminal',
            'petals':'4-6, white, thin',
            'sepals': '4-7 fused, green',
            'stamen': '300+ white filaments, 3-5 cm long',
            'size': '5-7 cm long,6-9 cm diameter',
            'description': 'long 5-6 cm style, light green'
          },
          'leaf': {
            'path': 'assets/images/29.png',
            'image_paths': [
              'assets/images/29leaf.png',
              'assets/images/29leaf.png',
              'assets/images/29leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'obovate to rounded',
            'margin': 'entire - smooth',
            'apex': 'round',
            'base': 'round',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'smooth, light green',
            'size': '8 (6-12) cm long, 7 (3-11) cm wide',
            'description': 'leathery, succulent, brittle'
          },
          'fruit': {
            'path': 'assets/images/29fruit.png',
            'image_paths': [
              'assets/images/29fruit.png',
              'assets/images/29fruit.png',
              'assets/images/29fruit.png',
            ],
            'name': '',
            'shape': 'rounded',
            'color': 'dark green',
            'texture': 'smooth',
            'size': '3-4 cm high,3-5 cm diameter',
            'description': 'contain many V- and U-shaped seeds (see inset)'
          },
        },
{
          'path': 'assets/images/30tree.png',
          'image_paths': [
            'assets/images/30tree.png',
            'assets/images/30tree.png',
            'assets/images/30tree.png',
          ],
          'name': ' Sonneratiaceae',
          'local_name': 'pedada, kalong-kalong',
          'scientific_name': 'Sonneratia caseolaris',
          'description': 'Prominent trees on the muddy substrate of low salinity upstream riverbanks; closely associated with N. fruticans. Sonneratia caseolaris can be distinguished from S. alba(with which it forms hybrids) by bigger pneumatophores that reach 1 m long when mature, bright red flowers, and elongated leaves with reddish petioles. Like S. alba,fireflies are also found on S. caseolaris. Heavy fruits cause the drooping branches to bend some more (see opposite, bottom left photo). Pneumatophores are used as floats for fishing nets and as corks (hence the vernacular term duol). Branches are used as firewood, the leaves as forage for goats and cows, and the bark yields tannin. The slightly acidic fruit is eaten raw or added to soups for souring, or made into vinegar. In the past, the sap was applied to the skin as cosmetic; other uses, e.g., firewood and forage, are similar to S. alba.',
          'summary': '',
          'root': {
            'path': 'assets/images/30root.png',
            'image_paths': [
              'assets/images/30root.png',
              'assets/images/30root.png',
              'assets/images/30root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/30flower.png',
            'image_paths': [
              'assets/images/30flower.png',
              'assets/images/30flower.png',
              'assets/images/30flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, terminal',
            'petals':'4-6, red, thin',
            'sepals': '4-7 lobed, green',
            'stamen': 'numerous (300+) filaments',
            'size': '6-9 cm long, 5-9 cm diameter',
            'description': 'filaments with red base and white tips'
          },
          'leaf': {
            'path': 'assets/images/30leaf.png',
            'image_paths': [
              'assets/images/30leaf.png',
              'assets/images/30leaf.png',
              'assets/images/30leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'elliptic',
            'margin': 'entire - smooth',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'smooth, light green',
            'underSurface': 'smooth, light green',
            'size': '8 (6-12) cm long, 4 (3-7) cm wide',
            'description': 'thin, petiole base reddish, leaf twigs drooping'
          },
          'fruit': {
            'path': 'assets/images/30fruit.png',
            'image_paths': [
              'assets/images/30fruit.png',
              'assets/images/30fruit.png',
              'assets/images/30fruit.png',
            ],
            'name': '',
            'shape': 'rounded',
            'color': 'light green',
            'texture': 'smooth, shiny',
            'size': '2.8-4 csour-sweet smell when ripe, many seeds smaller than S. alba (see inset)'
          },
        },
        {
          'path': 'assets/images/31tree.png',
          'image_paths': [
            'assets/images/31tree.png',
            'assets/images/31tree.png',
            'assets/images/31tree.png',
          ],
          'name': ' Sonneratiaceae',
          'local_name': ' pedada',
          'scientific_name': 'Sonneratia ovata',
          'description': 'Shorter trees that grow on firm mud in almost freshwater habitats located considerable distances from the shore; closely associated with N. fruticans. Areas may have access to seawater through seepage during months of higher tide. The white flowers of Sonneratia ovata are similar to those of S. alba, but the filaments fall from the tree earlier in the morning before sunrise. Leaves are bigger and more rounded, and fruits are much larger than those of S. alba and 5. caseolaris. Because their delicious sweetsour taste is much appreciated by children and local folk, fruits are plucked from trees as soon as they mature, as in Pan-ay, Capiz (see opposite page, bottom left photo). ',
          'summary': '',
          'root': {
            'path': 'assets/images/31root.png',
            'image_paths': [
              'assets/images/31root.png',
              'assets/images/31root.png',
              'assets/images/31root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/31flower.png',
            'image_paths': [
              'assets/images/31flower.png',
              'assets/images/31flower.png',
              'assets/images/31flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, terminal',
            'petals':'white, thin',
            'sepals': '5-6 lobed, thick, rough',
            'stamen': 'numerous filaments, white (300+)',
            'size': '6-8 cm long',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/31leaf.png',
            'image_paths': [
              'assets/images/31leaf.png',
              'assets/images/31leaf.png',
              'assets/images/31leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite',
            'bladeShape': 'round to ovate',
            'margin': 'entire - smooth',
            'apex': 'round',
            'base': 'round',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'smooth, green',
            'size': '9 (6-11) cm long, 6 (5-9) cm wide',
            'description': 'petiole base reddish'
          },
          'fruit': {
            'path': 'assets/images/31fruit.png',
            'image_paths': [
              'assets/images/31fruit.png',
              'assets/images/31fruit.png',
              'assets/images/31fruit.png',
            ],
            'name': '',
            'shape': 'rounded',
            'color': 'dark green',
            'texture': 'smooth',
            'size': '3-9 cm high, 5-0 cm diameter',
            'description': 'fleshy; sour-sweet smell when ripe; seeds are irregular granules larger than S. caseolaris (inset)'
          },
        },
           {
          'path': 'assets/images/32tree.png',
          'image_paths': [
            'assets/images/32tree.png',
            'assets/images/32tree.png',
            'assets/images/32tree.png',
          ],
          'name': ' Rubiaceae ',
          'local_name': 'bolaling, sagasa, hanbulali (Negros), nilad (Tag.)',
          'scientific_name': 'Scyphiphora hydrophyllacea',
          'description': 'Shrubs with multiple stems to trees up to 10 m tall, on firm mud near tidal creeks or sandy mud near river mouths; tolerate high salinity. The small pinkish-white flowers occur in dense clusters; fruits are deeply grooved and turn brown when ripe. Leaves have a distinct glossy or varnished appearance. Young stems and petioles are reddish and succulent like the leaves, which have been successfully tested as forage for goats and other livestock. Like other mangroves, the branches provide homes for birds (see opposite page, bottom left photo). Scyphiphora hydrophyllacea grows in monospecific stands – it was so abundant along Manila Bay and the Pasig River in pre-Hispanic times that the natives called the place “Maynilad” referring to the presence of nilad, its local name.',
          'summary': '',
          'root': {
            'path': 'assets/images/32root.png',
            'image_paths': [
              'assets/images/32root.png',
              'assets/images/32root.png',
              'assets/images/32root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/32flower.png',
            'image_paths': [
              'assets/images/32flower.png',
              'assets/images/32flower.png',
              'assets/images/32flower.png',
            ],
            'name': '',
            'inflorescence':'cyme, axillary',
            'petals':'4, whitish pink',
            'sepals': '4, fused',
            'stamen': '4, brown',
            'size': '0.6-1.5 cm long, 0.6-0.8 cm diameter',
            'description': '15-20 flowers per cluster'
          },
          'leaf': {
            'path': 'assets/images/32leaf.png',
            'image_paths': [
              'assets/images/32leaf.png',
              'assets/images/32leaf.png',
              'assets/images/32leaf.png',
            ],
            'name': '',
            'arrangement': 'simple, opposite, decussate',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round',
            'base': 'acute',
            'upperSurface': 'waxy, dark green',
            'underSurface': 'waxy, light green',
            'size': '7 (5-10) cm long, 4 (3-6) cm wide',
            'description': 'succulent, pointing upward, reddish petiole and stems'
          },
          'fruit': {
            'path': 'assets/images/32fruit.png',
            'image_paths': [
              'assets/images/32fruit.png',
              'assets/images/32fruit.png',
              'assets/images/32fruit.png',
            ],
            'name': '',
            'shape': 'barrel-like, with longitudinal ridges',
            'color': 'light green to brown when mature',
            'texture': 'smooth',
            'size': '0.7-0.9 cm long, 0.3-0.7 cm diameter',
            'description': ''
          },
        },
        {
          'path': 'assets/images/33tree.png',
          'image_paths': [
            'assets/images/33tree.png',
            'assets/images/33tree.png',
            'assets/images/33tree.png',
          ],
          'name': 'Meliaceae',
          'local_name': 'tabigi, tambigi',
          'scientific_name': 'Xylocarpus granatum',
          'description': '',
          'summary': '',
          'root': {
            'path': 'assets/images/33root.png',
            'image_paths': [
              'assets/images/33root.png',
              'assets/images/33root.png',
              'assets/images/33root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/33flower.png',
            'image_paths': [
              'assets/images/33flower.png',
              'assets/images/33flower.png',
              'assets/images/33flower.png',
            ],
            'name': '',
            'inflorescence':'panicle, axillary (a few terminal)',
            'petals':'4, white',
            'sepals': '4, lobed, yellowish green',
            'stamen': 'tubular',
            'size': '1.1- 1.2 cm long, 1.1- 1.4 cm dia',
            'description': 'unisexual'
          },
          'leaf': {
            'path': 'assets/images/33leaf.png',
            'image_paths': [
              'assets/images/33leaf.png',
              'assets/images/33leaf.png',
              'assets/images/33leaf.png',
            ],
            'name': '',
            'arrangement': 'paripinnate compound, opposite',
            'bladeShape': 'obovate',
            'margin': 'entire - smooth',
            'apex': 'round to emarginate',
            'base': 'acute',
            'upperSurface': 'smooth, dark green',
            'underSurface': 'smooth, light green',
            'size': '12 (7-19) cm long, 6 (4-9) cm wide',
            'description': '2-3 pairs of leaflets; sometimes deciduous'
          },
          'fruit': {
            'path': 'assets/images/33fruit.png',
            'image_paths': [
              'assets/images/33fruit.png',
              'assets/images/33fruit.png',
              'assets/images/33fruit.png',
            ],
            'name': '',
            'shape': 'like cannon ball or bowling ball',
            'color': 'green to brown',
            'texture': 'smooth to slightly rough',
            'size': '8-13 cm high, 8-14 cm diameter',
            'description': '10-12 irregularly-shaped seeds'
          },
        },
           {
          'path': 'assets/images/34tree.png',
          'image_paths': [
            'assets/images/34tree.png',
            'assets/images/34tree.png',
            'assets/images/34tree.png',
          ],
          'name': '  Meliaceae',
          'local_name': 'piagao, lagutlot',
          'scientific_name': 'Xylocarpus moluccensis (',
          'description': 'Smaller trees on the firm substrate of back mangroves rarely appearing along the edges of rivers or creeks; they are also identified as X. mekongensis. Their low-salinity habitats overlap with those of X. granatum, but X . moluccensis has smaller pointed leaves; dark, rough and fissured bark; peg- or cone-shaped pneumatophores; and smaller, dark green fruits. The species is deciduous - the leaves turn golden brown to red then drop (see opposite, bottom left photo); the new leaves appear together with the short-lived flowers. Seeds were used for insect bites, diarrhea and as astringent, the fruits for diarrhea, and the bark as astringent. Past uses of the wood were as poles, railroad ties, posts, beams and for interior finish, musical instruments and high grade furniture. The royal throne of the king of Malaysia is made of X . moluccensis wood because of its fine grain and deep dark color.',
          'summary': '',
          'root': {
            'path': 'assets/images/34root.png',
            'image_paths': [
              'assets/images/34root.png',
              'assets/images/34root.png',
              'assets/images/34root.png',
            ],
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/34flower.png',
            'image_paths': [
              'assets/images/34flower.png',
              'assets/images/34flower.png',
              'assets/images/34flower.png',
            ],
            'name': '',
            'inflorescence':'panicle, mainly axillary',
            'petals':'4, white',
            'sepals': '4, lobed, pale yellow-green',
            'stamen': 'fused, white',
            'size': '0.6-0.7 cm long,0.9-1.0 cm diameter',
            'description': 'unisexual'
          },
          'leaf': {
            'path': 'assets/images/leaf.png',
            'image_paths': [
              'assets/images/leaf.png',
              'assets/images/leaf.png',
              'assets/images/leaf.png',
            ],
            'name': '',
            'arrangement': 'paripinnate compound, opposite',
            'bladeShape': 'elliptical',
            'margin': 'entire - smooth',
            'apex': 'acute',
            'base': 'acute',
            'upperSurface': 'smooth, green',
            'underSurface': 'smooth, light green',
            'size': '8 (5-12) cm long, 4 (2.5) cm wide',
            'description': 'usually with 3-4 pairs of leaflets; deciduous'
          },
          'fruit': {
            'path': 'assets/images/fruit.png',
            'image_paths': [
              'assets/images/fruit.png',
              'assets/images/fruit.png',
              'assets/images/fruit.png',
            ],
            'name': '',
            'shape': 'like small cannon ball',
            'color': ' light green',
            'texture': 'smooth to slightly rough',
            'size': '8-9 cm high, 9-10 cm diameter',
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
          imagePath: mangrove['path'],
          name: mangrove['name'],
          local_name: mangrove['local_name'], 
          scientific_name: mangrove['scientific_name'], 
          description: mangrove['description'], 
          summary: mangrove['summary']
        );

        int newMangrooveId = await dbHelper.insertDBMangroveData(newMangroove);

        print("============newMangrooveId========");
        print(newMangrooveId);

        if(mangrove['image_paths'] != null) {
          for (var treeImgPath in mangrove['image_paths']) {
            final tree = MangroveImagesModel(mangroveId: newMangrooveId, imagePath: treeImgPath);
            await dbHelper.insertMangroveImages(tree);
          }
        }

        final newRoot = RootModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob: rootImageBytes, 
          imagePath: mangrove['root']['path'],
          name: mangrove['root']['name'],
          description: mangrove['root']['description'],
        );

        final newFlower = FlowerModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob: flowerImageBytes, 
          imagePath: mangrove['flower']['path'],
          name: mangrove['flower']['name'],
          inflorescence: mangrove['flower']['inflorescence'],
          petals: mangrove['flower']['petals'],
          sepals: mangrove['flower']['sepals'],
          stamen: mangrove['flower']['stamen'],
          size: mangrove['flower']['size'],
          description: mangrove['flower']['description']
        );

        final newLeaf = LeafModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob: leafImageBytes, 
          imagePath: mangrove['leaf']['path'],
          name: mangrove['leaf']['name'],
          arrangement: mangrove['leaf']['arrangement'],
          bladeShape: mangrove['leaf']['bladeShape'],
          margin: mangrove['leaf']['margin'],
          apex: mangrove['leaf']['apex'],
          base: mangrove['leaf']['base'],
          upperSurface: mangrove['leaf']['upperSurface'],
          underSurface: mangrove['leaf']['underSurface'],
          size: mangrove['leaf']['size'],
          description: mangrove['leaf']['description']
        );

        final newFruit = FruitModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob:  fruitImageBytes, 
          imagePath: mangrove['fruit']['path'],
          name: mangrove['fruit']['name'],
          shape: mangrove['fruit']['shape'],
          color: mangrove['fruit']['color'],
          texture: mangrove['fruit']['texture'],
          size: mangrove['fruit']['size'],
          description: mangrove['fruit']['description']
        );

        final root_id = await dbHelper.insertDBRootData(newRoot);
        final flower_id = await dbHelper.insertDBFlowerData(newFlower);
        final leaf_id = await dbHelper.insertDBLeafData(newLeaf);
        final fruit_id = await dbHelper.insertDBFruitData(newFruit);

        if( mangrove['root']['image_paths'] != null) {
          for (var rootImgPath in mangrove['root']['image_paths']) {
            final tree = RootImagesModel(rootId: root_id, imagePath: rootImgPath);
            await dbHelper.insertRootImages(tree);
          }
        }

        if( mangrove['flower']['image_paths'] != null) {
          for (var flowerImgPath in mangrove['flower']['image_paths']) {
            final tree = FlowerImagesModel(flowerId: flower_id, imagePath: flowerImgPath);
            await dbHelper.insertFlowerImages(tree);
          }
        }

        if( mangrove['leaf']['image_paths'] != null) {
          for (var leafImgPath in mangrove['leaf']['image_paths']) {
            final tree = LeafImagesModel(leafId: leaf_id, imagePath: leafImgPath);
            await dbHelper.insertLeafImages(tree);
          }
        }

        if( mangrove['fruit']['image_paths'] != null) {
          for (var fruitImgPath in mangrove['fruit']['image_paths']) {
            final tree = FruitImagesModel(fruitId: fruit_id, imagePath: fruitImgPath);
            await dbHelper.insertFruitImages(tree);
          }
        }
      }
    }
  }

  Future<void> setFlagInTempStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_seed', true);
  }

  Future<bool> getFlagFromTempStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_seed') ?? false; // Use a default value if the flag is not set.
  }

  Future<void> updateFlagInTempStorage(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_seed', newValue);
  }

  Future<List<Map>> getImagesFromMangrove() async {
    final db = await database;
    List<Map> mangroveImages = await db.rawQuery('SELECT id, imageBlob, imagePath, local_name, scientific_name FROM mangrove');

    return mangroveImages;
  }

  Future<List<Map>> getImagesFromFlower() async {
    final db = await database;
    List<Map> flowerImages = await db.rawQuery('SELECT id, mangroveId, imageBlob, imagePath, name FROM flower');

    return flowerImages;
  }

  Future<List<Map>> getImagesFromFruit() async {
    final db = await database;
    List<Map> fruitImages = await db.rawQuery('SELECT id, mangroveId, imageBlob, imagePath, name FROM fruit');

    return fruitImages;
  }

  Future<List<Map>> getImagesFromLeaf() async {
    final db = await database;
    List<Map> leafImages = await db.rawQuery('SELECT id, mangroveId, imageBlob, imagePath, name FROM leaf');

    return leafImages;
  }

  Future<List<Map>> getImagesFromRoot() async {
    final db = await database;
    List<Map> rootImages = await db.rawQuery('SELECT id, mangroveId, imageBlob, imagePath, name FROM root');

    return rootImages;
  }
}
