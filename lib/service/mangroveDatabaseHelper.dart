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
            'path': 'assets/images/root.png',
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
            'path': 'assets/images/root.png',
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
            'image_paths': [],
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
