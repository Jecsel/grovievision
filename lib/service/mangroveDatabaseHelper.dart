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
        stamens TEXT,
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
      whereArgs: [id],
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
          'name': ' Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus ebracteatus',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
          'root': {
            'path': '',
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/oneflower.png',
            'name': '',
            'description': 'The plants inflorescence presents itself as a spike emerging terminally, showcasing a striking visual display. The petals of these flowers start as a pristine white hue but gradually transition to a subtle brownish shade as they mature over time. Each petal measures between 2 to 3 centimeters in length, contributing to the delicate yet captivating appearance of the blossoms. This transformation in color adds an intriguing dimension to the overall aesthetic of the plants flowering phase, creating an engaging contrast as the petals age gracefully.'
          },
          'leaf': {
            'path': 'assets/images/oneleaf.png',
            'name': '',
            'description': 'The leaves of this particular plant exhibit a fascinating arrangement, alternating between simple, opposite, and decussate patterns. Their blade shape varies from elliptic to oblong, complemented by deeply lobed and serrated margins adorned with sharp spines. Tapering to an acute apex and base, these leaves measure between 10 to 20 centimeters in length and 4 to 6 centimeters in width. Their upper surface boasts a captivating dark green hue, rendering a shiny appearance, while the undersurface maintains a similarly dark green coloration. Notably stiff in texture, these leaves also possess salt crystals, adding to their unique characteristics.'
          },
          'fruit': {
            'path': 'assets/images/onefruit.png',
            'name': '',
            'description': 'The capsule, slightly flattened in its shape, embodies a spectrum of green hues, ranging from a vibrant green to a deep, luscious dark green. Its surface boasts a smooth texture, inviting touch with a sleekness that glides under fingertips. Measuring between 2 to 3 centimeters in length and approximately 1 centimeter in diameter, this diminutive yet alluring form holds a quiet allure, captivating attention with its subtle curvature and rich, verdant tones. Its sleek, slender silhouette suggests a graceful presence, evoking a sense of understated elegance within its compact dimensions.'
          },
        },
        {
          'path': 'assets/images/twotree.png',
          'name': 'Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus ilicifolius',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
           'root': {
            'path': '',
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/twoflower.png',
            'name': '',
            'description': 'The plants inflorescence showcases a spike structure emerging from the terminal ends, where the flowers are arranged closely together. These flowers present petals that are light blue, displaying a captivating hint of purple within their hue. Each petal measures around 2 to 3 centimeters in length, contributing to the overall delicate yet vibrant appearance of the inflorescence.'
          },
          'leaf': {
            'path': 'assets/images/twoleaf.png',
            'name': '',
            'description': 'The arrangement of the leaves follows a distinct pattern, starting with a simple alignment and transitioning to an opposite arrangement before adopting a decussate formation. These leaves exhibit an elliptic to oblong shape, featuring margins that are slightly lobed and serrated, often adorned with sharp spines. Their apex and base both culminate in acute points, while the upper surface boasts a pale green hue with a subtle yellowish tinge, offering a smooth texture. Conversely, the undersurface presents a contrasting green shade. These leaves typically measure 18 to 22 centimeters in length and 6 to 7 centimeters in width, maintaining a stiff quality throughout.'
          },
          'fruit': {
            'path': 'assets/images/twofruit.png',
            'name': '',
            'description': 'The plants seed capsules are distinctly shaped as slightly flattened capsules, showcasing a green coloration that is consistent throughout. Their surface texture is notably smooth, adding to their visual appeal. These capsules typically range in size, measuring between 2.5 to 3 centimeters in length and 1 to 1.5 centimeters in diameter, offering ample space for the development and containment of seeds within their structure.'
          },
        },
        {
          'path': 'assets/images/trestree.png',
          'name': 'Acanthaceae',
          'local_name': 'lagiwliw, ragoyroy',
          'scientific_name': 'Acanthus volubilis',
          'description': 'Characteristic ground flora of mangroves, Acanthus ebracteatus, A. ilicifolius and A. volubilis may form extensive shrubs up to 1.5 m high which are initially erect but recline with age, for the latter two. The closely related species are found in soft muds of the upper to middle reaches of estuarine rivers and creeks, and firm muds of back mangroves. Undergrowth is dense in open sunlight along forest margins, less so in partial shade and on mud lobster mounds. Leaves are elliptic to oblong, simple and decussate, with short petiole and a pair of spines at each leaf insertion or node - armed species have spiny leaves and stems. Flowers form a terminal spike up to 20 cm long. Oton, Iloilo folks boil the dried flowers and drink the water to relieve cough. Fruit capsules are dark green and slightly flattened. Often found together, these 3 are sometimes treated as a single variable species indicating the need for more field work on Acanthus eco-genetics. Presently, they are distin g u ish ed by the appearance of the leaves, flowers and fruits.',
          'summary': '',
          'root': {
            'path': '',
            'name': '',
            'description': ''
          },
          'flower': {
            'path': 'assets/images/tresflower.png',
            'name': '',
            'description': 'The plant showcases an inflorescence structure that takes the form of a spike, prominently located at the terminal ends of the stem. Within this inflorescence, the petals of the flowers initially appear white but tend to transition to a brownish hue as they age. These petals, measuring approximately 2 centimeters in length, undergo a subtle transformation in color, presenting a delicate shift from their pristine white appearance to a warm, earthy brown as they mature.'
          },
          'leaf': {
            'path': 'assets/images/tresleaf.png',
            'name': '',
            'description': 'The leaves exhibit a complex arrangement starting with a simple alignment, progressing to an opposite layout, and finally adopting a decussate pattern. They vary in blade shape, ranging from elliptic to lanceolate, with margins that are mostly entire, providing a smooth edge, occasionally displaying rare serrations. The apex of these leaves tends to be acute to acuminate, while the base remains acute. On the upper surface, a rich, dark green hue prevails, contributing to a smooth texture, while the undersurface mirrors this dark green coloration. Typically, these leaves measure between 15 to 18 centimeters in length and 4 to 6 centimeters in width. Notably, younger leaves situated higher on the stem tend to be wider, often with a smooth margin, while older leaves found lower on the stem are narrower and may feature small spines along the edges.'
          },
          'fruit': {
            'path': 'assets/images/tresfruit.png',
            'name': '',
            'description': 'The plants seed capsules are shaped as slightly flattened capsules, exhibiting a color spectrum ranging from green to a deeper, darker green. Their surfaces maintain a smooth texture, adding to their visual allure. These capsules typically measure around 2 centimeters in length with a diameter of approximately 1 centimeter, providing adequate space for the containment of seeds while showcasing a consistent and visually appealing appearance along their green-to-dark-green gradient.'
          },
        },
       {
          'path': 'assets/images/fourtree.png',
          'name': 'Myrsinaceae',
          'local_name': 'saging-saging, tayokan, kawilan (Visayan), tinduk-tindukan (Tagalog)',
          'scientific_name': ' Aegiceras corniculatum',
          'description': 'Shrubs to small trees typically 2-3 m tall but may reach 5 m. The species grows in isolated clumps never forming extensive stands along tidal creeks and river mouths. Widely distributed in Panay but has never been found together with its sister species A. floridum (see following). Substrate is sandy to compact mud. The leaves are often notched and have a prominent midrib on the undersurface which merges with the pinkish petiole. The strongly curved fruits hang in clusters like small bananas (hence the local names referring to banana varieties) and are pale green to pinkish-red. In Panay, the species is used for firewood and the bark for tanning and fish poison. Elsewhere in the Philippines, the wood is made into knife handles.',
          'summary': '',
          'root': {
            'path': 'assets/images/fourroot.png',
            'name': '',
            'description': 'The shrub to small tree presents a modest height ranging from 2 to 5 meters, adorned with bark that embodies shades of dark brown to black, displaying a lenticellate pattern. Its unique character is accentuated by surface-level aerial roots, relatively diminutive in size yet striking in their adventitious nature. These roots, with their ability to develop from unexpected plant parts, contribute to the plants resilience and adaptability, making it a distinctive presence in its environment.'
          },
          'flower': {
            'path': 'assets/images/fourflower.png',
            'name': '',
            'description': 'The plants inflorescence takes the form of an umbel, clustered and positioned terminally on the plant. Within this arrangement, delicate flowers unfold, presenting five white petals that gracefully fold outward, complemented by five green sepals enveloping the base. The inner composition includes five stamens exhibiting shades ranging from orange to brown, adding a contrasting visual element to the flowers. These blooms measure approximately 0.6 to 0.7 centimeters in length, with a diameter spanning between 0.8 to 1.0 centimeters. Notably, these flowers offer a delightful scent, enhancing their aesthetic appeal and attracting pollinators with their fragrant allure.'
          },
          'leaf': {
            'path': 'assets/images/fourleaf.png',
            'name': '',
            'description': 'The leaves of this plant follow a primarily simple and alternate arrangement, occasionally displaying a rare opposite pattern, and are spirally arranged along the stem. Characterized by an obovate shape, these leaves boast margins that are entirely smooth, contributing to their aesthetic appeal. Their apex varies from round to emarginate, while the base remains acute. The upper surface of these leaves appears smooth and exhibits a deep, dark green hue, while the undersurface tends toward a brownish-green tone, featuring a prominent midrib. Typically, these leaves measure around 7 centimeters in length, ranging from 5 to 12 centimeters, and approximately 5 centimeters in width, spanning from 3 to 7 centimeters. Additionally, these leaves often bear salt crystals, a distinctive feature adding to their unique characteristics.'
          },
          'fruit': {
            'path': 'assets/images/fourfruit.png',
            'name': '',
            'description': 'The plants distinctive structures exhibit a cylindrical shape, notably strongly curved, with pointed tips adding to their unique appearance. These formations showcase a color spectrum ranging from light green to hues of purple, offering a visually striking display. Their surfaces maintain a smooth texture, enhancing their aesthetic appeal. Typically, these structures measure approximately 4 to 8 centimeters in length, with a diameter ranging between 0.4 to 0.6 centimeters. An intriguing aspect of these formations is their cryptoviviparous nature, signifying their ability to produce seeds internally while still attached to the parent plant, highlighting an intriguing aspect of their reproductive cycle.'
          },
        },
        {
          'path': 'assets/images/fivetree.png',
          'name': ' Myrsinaceae',
          'local_name': 'saging-saging, katuganung, kwasay (Visayan); tinduk-tindukan (Tagalog)',
          'scientific_name': 'Aegiceras floridum',
          'description': 'Small trees (4 m tall) on sandy or rocky substrate that tolerate higher salinities. More limited in distribution than A . corniculatum, this species has been observed on Taklong Is. in Guimaras, and Carles and Pedada Bay, Ajuy in Iloilo. Although similar in appearance, A. floridum has smaller leaves, white flowers on branched flower stalks, and fruits that are smaller, slightly curved and brighter red compared to A. corniculatum. Leaves are also characterized by salt crystals on the upper surface, and insect bites. This and the previous species are cryptoviviparous, i.e., the germinating seed remains hidden within the intact fruit wall while still attached to the parent plant (see opposite page, bottom left photo). The wood is used for fuel and the bark has a small amount of tannin.',
          'summary': '',
          'root': {
            'path': 'assets/images/fiveroot.png',
            'name': '',
            'description': 'The small trees, standing at a height of 3 to 4 meters, boast a slender elegance accentuated by a diameter at breast height (DBH) ranging between 6 to 12 centimeters. Their bark, adorned in a tapestry of dark brown with mottled patterns, showcases a lenticellate texture that adds an exquisite dimension to their appearance. A distinguishing feature lies in their surface-level aerial roots, which intertwine with the landscape, enhancing the trees stability and resilience while contributing to their distinctive visual allure.'
          },
          'flower': {
            'path': 'assets/images/fiveflower.png',
            'name': '',
            'description': 'The plants inflorescence takes the form of a raceme, located at the terminal end of the stem, where multiple flowers are arranged along an elongated axis. Each flower showcases five petals that transition from white to shades of brown, adding depth and visual interest to the blooms. Surrounding the petals are five green sepals that encase the base of the flower. These flowers typically bear five stamens, contributing to their reproductive structures. Measuring about 1 centimeter in length and approximately 0.7 centimeters in diameter, these blooms present a modest yet captivating appearance, forming a delicate and visually appealing raceme at the pinnacle of the plant.'
          },
          'leaf': {
            'path': 'assets/images/fiveleaf.png',
            'name': '',
            'description': 'The leaves display a simple, alternate arrangement, often appearing in a spiral formation along the stem. These obovate-shaped leaves feature margins that are entirely smooth, contributing to their sleek appearance. Their apex ranges from round to emarginate, while the base remains acute. The upper surface of these leaves boasts a smooth texture and a light green hue, while the undersurface, also smooth, presents a slightly different shade, tending towards a whitish green. Typically, these leaves measure around 4 centimeters in length, spanning from 3 to 6 centimeters, and approximately 2 centimeters in width, varying from 1 to 3 centimeters. Notably, these leaves often bear salt crystals and may also exhibit signs of insect bites, adding to their distinct characteristics and history of interactions within their environment.'
          },
          'fruit': {
            'path': 'assets/images/fivefruit.png',
            'name': '',
            'description': 'The plants distinctive structures exhibit a cylindrical shape, resembling small bananas due to their straight form. These formations boast colors ranging from pink tones to vibrant hues of bright red, adding a striking visual contrast to their environment. Their surfaces maintain a smooth texture, enhancing their overall aesthetic appeal. Typically measuring between 2 to 3 centimeters in length and with a diameter ranging from 0.4 to 0.5 centimeters, these structures draw attention due to their unique appearance. Notably, these formations possess cryptoviviparous tendencies, showcasing an intriguing reproductive process wherein seeds develop internally while still attached to the parent plant, highlighting an exceptional aspect of their life cycle.'
          },
        },
        {
          'path': 'assets/images/sixtree.png',
          'name': ' Avicenniaceae',
          'local_name': 'bungalon, api-api, miapi',
          'scientific_name': ' Avicennia alba',
          'description': 'Medium-sized trees reaching 12 m high, which tolerate high salinity and colonize the soft, muddy banks of rivers and tidal flats. This species can be found interspersed among the more widely distributed stands of A . marina. Small monospecific groves of A. alba are found in Pan-ay, Capiz; Batan, Aklan and Makato River, Aklan. The whitish undersides of leaves give the canopy a silvery-white appearance from a distance, differentiating it from the green to golden canopy of A .marina. A. alba differs from the latter by its elongated leaves, conical or chili-like fruits, and relatively dark, sooty trunk (see opposite page, bottom left photo). The wood is used for fuel and the leaves for forage. Past uses include a resinous secretion for birth control, bark as astringent, and an ointment from seeds to relieve smallpox ulceration. Table 4 summarizes the characters used to separate the four Avicennia species.',
          'summary': '',
          'root': {
            'path': 'assets/images/sixroot.png',
            'name': '',
            'description': 'The stately tree commands attention with its imposing height, reaching an impressive range of 5 to 12 meters, standing tall and proud. Its robust trunk, boasting a diameter at breast height (DBH) between 10 to 25 centimeters, supports a canopy that spreads majestically. The bark, finely textured and tinged in shades from dark brown to black, creates a rugged yet captivating exterior. A unique feature lies in its aerial roots, resembling pencil-like pneumatophores that extend from the base, contributing to the trees stability, aiding in respiration, and enhancing its distinctive aesthetic presence within its habitat.'
          },
          'flower': {
            'path': 'assets/images/sixflower.png',
            'name': '',
            'description': 'The plants flowering structure takes the form of a spike, positioned either terminally at the end of the stem or in the axils of the leaves. Each flower within this arrangement features four petals exhibiting a light yellow-orange hue, adding a vibrant and appealing color contrast. Encompassing the base of these petals are four fused sepals, displaying a light green shade. The flowers typically bear four yellow stamens, contributing to the floral composition. These blooms measure around 0.5 to 0.6 centimeters in diameter, presenting a modest yet visually pleasing appearance. Additionally, these flowers emit a slight, delicate scent, enhancing their allure and adding to their overall charm.'
          },
          'leaf': {
            'path': 'assets/images/sixleaf.png',
            'name': '',
            'description': 'The leaves showcase a distinctive arrangement, starting as simple and opposite, transitioning into a decussate pattern. Characterized by an elliptic shape, these leaves feature margins that are entirely smooth, contributing to their sleek appearance. Their apex and base both culminate in acute points, adding to their defined structure. The upper surface of these leaves presents a smooth texture and a vibrant green coloration, while the undersurface, also smooth, displays a contrasting silvery hue. Typically, these leaves measure around 10 centimeters in length, varying from 7 to 15 centimeters, and approximately 4 centimeters in width, spanning from 2 to 5 centimeters. This combination of characteristics contributes to their unique visual appeal and adaptability within their ecosystem.'
          },
          'fruit': {
            'path': 'assets/images/sixfruit.png',
            'name': '',
            'description': 'The plant exhibits conical structures reminiscent of chili peppers in shape, characterized by their elongated and tapering form. These structures boast a light green coloration, contributing to their fresh and vibrant appearance. Their surface texture is notably covered in fine hairs, adding a delicate and textured feel to the touch. Typically measuring between 3 to 5 centimeters in length and 1 to 2 centimeters in width, these formations stand out due to their unique shape and coloring, adding a distinct visual element to the plants overall presentation.'
          },
        },
        {
          'path': 'assets/images/sevtree.png',
          'name': 'Avicenniaceae ',
          'local_name': 'bungalon, api-api, miapi, bayabason (Iloilo)',
          'scientific_name': 'Avicennia marina',
          'description': 'The most widely distributed mangrove species, it colonizes muddy, sandy and even coralline rock substrates in fringing mangroves - forming stands, often with S. alba - and along river banks and on higher ground. It is also found as shrubs in mudflats and abandoned fishponds. Leaves are highly variable, and often exhibit leaf curling. The yellow green leaves give the stand a golden appearance in sunlight. The bark is mottled, light green to brown and flaky. Pneumatophores are pencil-shaped. Coastal dwellers plant this species to protect their homes from typhoons (see opposite, bottom left photo). A. marina is preferred for firewood because it coppices, i.e., produces new branches after cutting. The smoke of dried branches acts as mosquito repellent. Leaves are fed to livestock. Newly-sprouted Avicennia seedlings are cooked as vegetables. Christmas trees built from branches are sold along Roxas Blvd. in Manila.',
          'summary': '',
          'root': {
            'path': 'assets/images/sevroot.png',
            'name': '',
            'description': 'The tree, ranging from 2 to 10 meters in height, boasts a sturdy trunk with a diameter at breast height (DBH) spanning between 10 to 70 centimeters. Its bark is a striking feature, displaying a smooth texture adorned with thin flakes, showcasing hues of greenish-brown that complement the natural surroundings. What distinguishes this tree are its pencil-like aerial roots that intricately sprawl outwards, lending both support and a unique aesthetic. Additionally, this remarkable tree produces pneumatophores, enhancing its adaptability by enabling efficient gas exchange in challenging environments. Its presence not only graces the landscape but also offers a testament to natures innovation and resilience.'
          },
          'flower': {
            'path': 'assets/images/sevflower.png',
            'name': '',
            'description': 'The plants inflorescence takes the form of a spike, appearing either at the terminal end of the stem or in the axils of the leaves. Each flower within this arrangement features four petals displaying a vibrant yellow-orange color with distinct brown margins, adding a striking contrast to the bloom. Surrounding the base of the petals are four fused sepals in a light green shade. The flowers typically bear four very short yellow stamens, contributing to the floral structure. Additionally, there is a single short pistil, typically yellow in color. These blossoms measure approximately 0.5 to 0.7 centimeters in diameter, presenting a modest yet visually appealing appearance, characterized by their unique coloration and floral structure.'
          },
          'leaf': {
            'path': 'assets/images/sevleaf.png',
            'name': '',
            'description': 'The leaves are organized in a simple, opposite, and decussate pattern along the stem. They exhibit an elliptic shape with entirely smooth margins, enhancing their sleek appearance. Their apex varies from acute to round, while the base remains acute, contributing to their distinct form. Both the upper and undersurfaces of the leaves are smooth, showcasing shades ranging from green to yellow-green, displaying variability in coloration. Typically, these leaves measure around 7 centimeters in length, spanning from 4 to 11 centimeters, and approximately 3 centimeters in width, varying from 2 to 6 centimeters. Notably, these leaves exhibit numerous insect bites and show signs of curling and rolling, indicating a high degree of variability and adaptation to environmental factors, adding to their unique and evolving characteristics.'
          },
          'fruit': {
            'path': 'assets/images/sevfruit.png',
            'name': '',
            'description': 'The plants structures take on a heart-shaped form with a distinct short beak, adding a unique characteristic to their appearance. They present a light green coloration, contributing to their fresh and natural aesthetic. The surfaces of these structures are covered in fine hairs, giving them a pubescent texture. Typically measuring between 2 to 3 centimeters in both length and width, these formations exhibit a balanced and compact size, showcasing their distinctive heart-shaped silhouette and textured surface.'
          },
        },
        {
          'path': 'assets/images/eyttree.png',
          'name': 'Avicenniaceae ',
          'local_name': 'api-api, miapi, bungalon',
          'scientific_name': 'Avicennia officinalis',
          'description': 'Medium to large trees up to 20 m on firm mud of the upper intertidal in estuarine areas. The species has a crooked trunk and shiny, dark green leaves with spreading crown. Among the four Avicennia species, A. officinalis has the biggest flowers (1.5 cm wide), fruits (4 cm long) and leaves (14 cm long x 7 cm wide) with conspicuous salt crystals (see opposite, bottom left photo), and rarely forms monospecific stands. In addition, the orange flowers have the darkest shade and strongest scent. Ashes of branches are placed in a funnel through which seawater is filtered. The filtrate is evaporated by boiling to obtain a solid lump of salt. In the past, the wood was used to smoke fish and build rice mortars and pestles. Fruits were used as astringent, bark and roots as aphrodisiac, and seeds and roots as poultice to treat ulcers, etc.',
          'summary': '',
          'root': {
            'path': 'assets/images/eytroot.png',
            'name': '',
            'description': 'Standing tall at heights varying between 5 to 20 meters, this distinctive tree boasts a robust trunk with a diameter at breast height (DBH) ranging from 20 to 80 centimeters. Its striking aerial roots, a blend of pneumatophores and pencil-like extensions, intricately cling to the ground, often manifesting as stilt roots along the trunk. The bark, a defining feature, presents a rough texture enveloped in hues of dark brown, adding a sense of rugged elegance to its appearance. What sets this tree apart is its unique form, with a trunk that doesnt adhere to straightness and branches that sprawl in irregular patterns, contributing to its character and individuality within its habitat. This tree stands as a testament to the diverse and captivating variations found in natures design.'
          },
          'flower': {
            'path': 'assets/images/eytflower.png',
            'name': '',
            'description': 'The plants flowering pattern appears in a spike formation, positioned either terminally at the end of the stem or within the leaf axils. Each flower consists of four petals, characterized by a rich, dark yellow-orange hue, lending a vibrant and visually captivating aspect to the blooms. Encompassing the base of these petals are four fused sepals in a light green shade. The flowers typically bear four yellow stamens, contributing to the floral structure. Measuring between 0.9 to 1.5 centimeters in diameter, these blossoms present a modest yet visually appealing appearance. Notably, among the Avicennia spp, these flowers stand out as the most aromatic, emitting a distinctive and alluring fragrance that enhances their appeal and makes them noteworthy within the genus.'
          },
          'leaf': {
            'path': 'assets/images/eytleaf.png',
            'name': '',
            'description': 'The leaves of this plant exhibit a simple, opposite, and decussate arrangement along the stem. They vary in shape, ranging from elliptic to oblong, with margins that are entirely smooth, contributing to their sleek appearance. The apex of these leaves is typically rounded, while the base remains acute, forming a distinct structure. On the upper surface, the leaves present a shiny and deep dark green color, while the undersurface appears glabrous with a yellow-green hue. Generally, these leaves measure about 10 centimeters in length, fluctuating between 6 to 14 centimeters, and approximately 5 centimeters in width, spanning from 3 to 7 centimeters. An intriguing feature is the presence of salt crystals on these leaves. Additionally, due to the bending downwards of their sides, the leaves often appear slightly convex, adding a unique dimension to their overall appearance.'
          },
          'fruit': {
            'path': 'assets/images/eytfruit.png',
            'name': '',
            'description': 'The plants structures take on a heart-shaped form that is elongated with a pointed tip, contributing to their distinctive appearance. They showcase a yellowish-green coloration, imparting a subtle yet vibrant hue to their overall look. The surfaces of these structures exhibit a rugose texture, characterized by wrinkled or corrugated areas, and are finely hairy, providing an additional tactile dimension. Typically measuring between 3 to 4 centimeters in length and spanning approximately 2 to 3 centimeters in width, these formations stand out due to their unique shape, texture, and color, adding to the visual allure of the plant.'
          },
        },
        {
          'path': 'assets/images/ninetree.png',
          'name': ' Avicenniaceae ',
          'local_name': 'api-api, miapi, bungalon',
          'scientific_name': 'Avicennia rumphiana',
          'description': 'Formerly referred to as Avicennia lanata, this species forms medium to large trees. They grow on firm mud of middle to high intertidal areas. Avicennia rumphiana forms an almost monospecific grove of dozens of old, big trees in Bugtong Bato, Ibajay, Aklan with maximum 20 m height, 2.5 m diameter and 8 m circumference (see opposite page, bottom left photo). It differs from other Avicennia species by the brownish color and woolly hairs of fruits and undersurface of leaves. The canopy of an A .rumphiana stand looks light brown from a distance, in contrast to the silvery white appearance of A. alba.Sometimes A . rumphiana occurs with A officinalis, but its young leaves and branches are typically upright, whereas those of A . officinalis point in all directions. Also used as fuelwood and for furniture-making with its fine-grained wood.',
          'summary': '',
          'root': {
            'path': 'assets/images/nineroot.png',
            'name': '',
            'description': 'The tree stands gracefully, reaching a height between 5 to 20 meters, with a robust trunk measuring from 0.5 to 2.5 meters in diameter. Its majestic presence is accentuated by the slightly rough, brown bark that wraps around the sturdy frame. Pencil-like aerial roots cascade down from the branches, creating an enchanting visual as they reach towards the ground. These aerial roots not only lend an ethereal quality to the tree but also serve as pneumatophores, aiding in respiration and ensuring the trees survival in wet or marshy environments. Amidst its towering stature and intricate root system, this tree embodies resilience and natural splendor.'
          },
          'flower': {
            'path': 'assets/images/nineflower.png',
            'name': '',
            'description': 'The inflorescence of this particular plant exhibits a spike-like structure that can emerge either terminally or axillary. Each flower showcases four striking yellow-orange petals, giving the plant a vibrant and eye-catching appearance. The sepals, also numbering four, are light green and fused together, forming a protective covering for the delicate inner components of the flower. Within the flower, four yellow stamens stand prominently, contributing to the overall visual allure. These flowers typically measure between 0.5 to 0.7 centimeters in diameter, their modest size not detracting from their bold and appealing display of colors.'
          },
          'leaf': {
            'path': 'assets/images/nineleaf.png',
            'name': '',
            'description': 'The leaves of this plant are arranged in a simple, opposite fashion, forming a distinctive decussate pattern along the stem. Each leaf blade is elliptic in shape, showcasing a smooth margin without any serrations, giving it a sleek and uniform appearance. The apex of the leaf is rounded, while the base tapers to an acute point. The upper surface of the leaf is smooth and exhibits a rich, dark green hue, contributing to its striking visual appeal. In contrast, the undersurface of the leaf is densely covered in fine hairs, imparting a yellow-green coloration and a slightly fuzzy texture. These leaves typically measure around 8 centimeters in length, ranging between 5 to 11 centimeters, and approximately 4 centimeters in width, varying between 3 to 5 centimeters across, showcasing a moderate size with slight variations within this range.'
          },
          'fruit': {
            'path': 'assets/images/ninefruit.png',
            'name': '',
            'description': 'The heart-shaped form of this object, characterized by its rounded contours and a blunt tip, reflects a unique and endearing appearance. Its distinctive yellow-green hue adds a touch of vibrancy and warmth, drawing attention to its charming nature. The texture, described as woolly, imparts a soft and cozy feel, inviting to the touch. Measuring between 1 to 3 centimeters in length and 1 to 2 centimeters in width, its diminutive size amplifies its allure, making it an intriguing and delightful object to behold. Overall, this petite, woolly-textured, yellow-green item with its heart-shaped outline and gentle, rounded edges exudes an undeniable appeal, capturing attention and curiosity alike.'
          },
        },
        {
          'path': 'assets/images/tentree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'pototan, busain (Tagalog)',
          'scientific_name': 'Bruguiera cylindrica',
          'description': 'Small to medium-sized trees with rounded crown, reaching 10 m high and 20 cm DBH. Bruguiera cylindrica colonizes newly-established substrates behind the pioneering Avicennia-Rhizophora zone along estuarine riverbanks and tidal creeks. When found beside taller Rhizophora trees, the species appears short (hence the local name pototan). B. cylindrica is also found as single trees on compact muds of open, more inland sites. Among the Bruguiera species, it has the smallest leaves and flowers next to B. parviflora (Table 5). The stipules (at times called leaf sheaths) are pale green. The mottled bark becomes more dark and rough in older trees (see opposite page, bottom left photos). The short and thin pencil-like propagules bear a calyx cap whose lobes are reflexed. In the past, B. cylindrica timber was harvested for household and construction use. Present uses are limited to firewood and as source of tannin.',
          'summary': '',
          'root': {
            'path': 'assets/images/tenroot.png',
            'name': '',
            'description': 'The tree stands gracefully with a modest height ranging from 2 to 10 meters, its trunk measuring between 10 to 20 centimeters in diameter. Its distinctive appearance is characterized by the slightly to very rough bark, displaying a spectrum of colors from light brown to grayish tones. The bark, adorned with few lenticels, adds texture to its surface, hinting at the trees age and resilience. Notably, knee roots and small buttresses emerge from the base, creating a captivating sight as they support and anchor the tree, adding both stability and visual intrigue to its form. This trees charming blend of modest height, diverse bark textures, and unique root structures showcases its adaptability and innate beauty in natural landscapes.'
          },
          'flower': {
            'path': 'assets/images/tenflower.png',
            'name': '',
            'description': 'The inflorescence of this captivating specimen is singular in nature, emerging from the axils of its foliage. The petals, numbering between 11 to 14, are a striking shade of orange, each displaying distinctive notches and adorned with fine hairs, lending a unique and textured appearance. Surrounding the petals are the sepals, also numbering between 11 to 14, exhibiting hues ranging from pink to vivid red. These sepals are fused, creating a protective and decorative enclosure around the vibrant petals. The stamens, occurring in 11 to 14 pairs, add further intricacy to the floral structure, contributing to its ornate beauty. In its entirety, this flower measures between 3 to 4 centimeters in length, boasting a remarkable blend of colors, textures, and fused elements that collectively create a mesmerizing and captivating botanical wonder.'
          },
          'leaf': {
            'path': 'assets/images/tenleaf.png',
            'name': '',
            'description': 'The arrangement of these leaves is elegantly simple, positioned opposite each other along the stem. Their blade shape is characterized by an elliptic form, presenting a sleek and elongated structure. With a smooth and unbroken margin, these leaves exude a seamless, uninterrupted surface. At the apex, they taper to either an acute or acuminate point, showcasing a refined and sharp tip. The base follows suit, tapering to an acute point as well. The upper surface displays a smooth texture, boasting a deep and lush shade of dark green, while the lower surface presents a contrasting waxy texture with a lighter hue of green, creating a subtle yet striking contrast. These leaves attain a size of approximately 15 centimeters in length, spanning within a range of 10 to 20 centimeters, and about 6 centimeters in width, fluctuating between 4 to 8 centimeters. Additionally, these leaves exhibit reddish stipules, adding a touch of color and further visual interest to their overall appearance.'
             },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/elevtree.png',
          'name': 'Rhizophoraceae ',
          'local_name': 'pototan; bakhaw (Antique), busain (Tagalog)',
          'scientific_name': 'Bruguiera gymnorrhiza',
          'description': 'Medium to large trees reaching 10 m high and 30 cm DBH, found on muddy substrate along riverbanks, sandy-muddy substrate in island mangroves, and compact mud in inner mangroves. They differ from the other Bruguiera species in that they have the largest leaves, flowers, propagules, and lenticels. B. gymnorrhiza has very heavy wood which was used in the past as timber for saltwater and foundation pilings, house posts, flooring, cabinetwork and furniture. It was also used as source of dyes for fishnets, ropes, sails and clothing and powdered bark (baluk) for the preparation of tuba, a popular drink made from coconut sap. Trees can survive partial debarking to obtain dye if limited to a small section of the trunk (see opposite page, bottom left photo). Present uses are charcoal and firewood, while the knee roots are utilized in planting rituals in Palanan, Isabela so cultivated tubers will grow big.',
          'summary': '',
          'root': {
            'path': 'assets/images/elevroot.png',
            'name': '',
            'description': 'The tree stands elegantly, boasting a height ranging from 2 to 10 meters and a robust trunk measuring between 10 to 30 centimeters in diameter. Its striking appearance is defined by the rough, dark brown bark, exuding a sense of strength and maturity. The barks surface is adorned with prominent lenticels, adding texture and character to the trees exterior. Notably, knee roots and small buttresses extend from the base, creating a captivating visual display while also providing stability and support. These aerial roots contribute to the trees resilience, allowing it to thrive and anchor itself firmly within its environment. With its impressive stature, textured bark, and unique root formations, this tree epitomizes both grace and resilience in its natural habitat.'
          },
          'flower': {
            'path': 'assets/images/elevflower.png',
            'name': '',
            'description': 'The plants inflorescence showcases a solitary structure emerging from the axils, highlighting a single and distinct floral arrangement. Its petals, numbering between 11 to 14, boast a vibrant orange hue, characterized by notched edges and a fine layer of hairs, imbuing the blooms with a captivating texture. In complement, the sepals, also numbering between 11 to 14, exhibit hues ranging from pink to red, fused together to form a protective covering around the floral assembly. Adding to the ornate nature of the blossom, the stamens appear in pairs, numbering 11 to 14, contributing to the overall abundance and visual richness. These blossoms measure approximately 3 to 4 centimeters in length, creating a compact yet visually striking appearance, combining both color and texture to make an eye-catching floral display.'
          },
          'leaf': {
            'path': 'assets/images/elevleaf.png',
            'name': '',
            'description': 'The leaves of this plant demonstrate a simple and opposite arrangement, showcasing an elliptic blade shape with an entirely smooth margin. Their apex varies from acute to acuminate, contributing to a sharp and distinct appearance, while the base remains acute, reinforcing the leafs overall structure. On the upper surface, these leaves present a smooth texture with a rich, dark green color, providing an elegant visual contrast. Conversely, the lower surface of the leaves displays a waxy texture and a lighter shade of green, accentuating its distinctiveness. These leaves typically measure around 15 centimeters in length, with a range spanning from 10 to 20 centimeters, and approximately 6 centimeters in width, fluctuating between 4 to 8 centimeters. Notably, these leaves feature reddish stipules, adding an additional touch of color and detail to their overall appearance.'
             },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/tweltree.png',
          'name': 'Rhizophoraceae ',
          'local_name': 'hangalai, langarai, mangalai (Tagalog)',
          'scientific_name': 'Bruguiera parviflora',
          'description': 'Bruguiera parviflora forms solid stands of slender, tall trees reaching 15 m high. Among Bruguiera species, it has the darkest trunk, the most delicate flowers, and the finest leaves that appear stellate or star-shaped from a distance. The slender propagules have a distinctive calyx appressed to the fruit, unlike other Bruguiera spp. At first green and erect, the propagules become brown and pendulous when mature. The yellow-green leaves form a golden canopy in full sunlight. Older trees have cracked bark with reddish interior (see opposite page, bottom left photo). Like other Bruguiera species, past uses include saltwater and foundation pilings, house posts, flooring, cabinetwork and as a source of tannin',
          'summary': '',
          'root': {
            'path': 'assets/images/twelroot.png',
            'name': '',
            'description': 'The tree stands tall and stately, reaching a height of 5 to 15 meters, with a sturdy trunk measuring between 15 to 25 centimeters in diameter. Its commanding presence is emphasized by the rough, dark bark that envelops the tree, exuding an air of maturity and resilience. The barks texture and hue convey strength and durability, showcasing the trees ability to weather the passage of time. Remarkably, dark knee roots extend from the base, serving as aerial structures that provide support and aid in anchoring the tree firmly into the ground. Alongside, low buttresses further reinforce its stability, contributing to its robustness within its natural habitat. The combination of its impressive height, robust trunk, dark aerial roots, and low buttresses forms an image of strength and vitality, defining the trees distinct and enduring presence in the landscape.'
          },
          'flower': {
            'path': 'assets/images/twelflower.png',
            'name': '',
            'description': 'The axillary cyme inflorescence of this particular plant bears white petals and eight yellow-green sepals. The petals exhibit a pristine white hue, while the sepals, numbering eight, display a vibrant yellow-green coloration. These floral components collectively form a bloom with dimensions spanning from 0.9 to 1.3 centimeters in length and 0.4 to 0.6 centimeters in diameter, contributing to the delicate and intricate appearance of the flower.'
          },
          'leaf': {
            'path': 'assets/images/twelleaf.png',
            'name': '',
            'description': 'The leaf exhibits a straightforward yet contrasting arrangement with an elliptic blade shape. Its margins present a seamless, smooth contour, while the apex is notably acuminate, forming a sharp point. The base, in contrast, tapers to an acute angle. The upper surface showcases a smooth texture and a striking light green hue, in stark comparison to the waxy, pale green undersurface. This leaf typically measures around 8 centimeters in length, ranging between 6 to 10 centimeters, and approximately 3 centimeters in width, spanning between 2 to 4 centimeters. Adding to its distinct features are the whitish to light yellow stipules, further enhancing its unique appearance.'
         },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/tertree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'pototan, karakandang (Antique)',
          'scientific_name': 'Bruguiera sexangula',
          'description': 'A medium tree up to 10 m tall in the compact sandy-muddy substrate of landward mangroves; with limited distribution in Panay. Bruguiera sexangula groves are found in the innermost portion of the mangroves in Bugtong Bato, Ibajay, Aklan and Lipata, Culasi, Antique. The species has big flowers with yellow-orange petals and sepals, short and stout propagules, and prominent buttress and knee roots with lenticels. Bark is light brown with large corky lenticels (see opposite page, bottom left photo) and sometimes covered with lichens. Presently used for firewood and charcoal. Past uses include piles, mine timber and house posts. Roots and leaves were used to treat burns, leaves have alkaloids that are tumor inhibitors, and a lotion made from the fruit was used to treat sore eyes. Young leaves and fruits were cooked as vegetables, fruits used as betel nut substitutes, and roots made into incense wood.',
          'summary': '',
          'root': {
            'path': 'assets/images/terroot.png',
            'name': '',
            'description': 'The tree stands gracefully, its stature reaching between 5 to 10 meters in height, with a robust trunk measuring from 10 to 25 centimeters in diameter. Its appearance is marked by the rough, brown bark adorned with lenticels, creating a textured surface that adds character to its exterior. These lenticels not only enhance the visual appeal but also facilitate gas exchange, contributing to the trees overall health. Notably, knee roots extend from the base, intertwining with low buttresses, offering both stability and an aesthetic dimension to its structure. These aerial roots and buttresses provide essential support, anchoring the tree firmly in its environment. The trees harmonious blend of modest height, textured bark, and well-defined aerial roots and buttresses showcases its adaptability and resilience, painting a picture of natural beauty and strength within its landscape.'
          },
          'flower': {
            'path': 'assets/images/terflower.png',
            'name': '',
            'description': 'The plant showcases a singular and axillary inflorescence. Its petals, numbering between 10 to 11, display an intriguing range of colors from shades of orange to brown, creating an eye-catching contrast. The sepals, numbering between 10 to 12, exhibit a fused structure and a vibrant yellow-orange hue, further enhancing the floral appeal. Within the bloom, there are approximately 10 to 11 pairs of stamens, contributing to the overall symmetry and balance of the flower. These blooms typically measure between 3 to 3.2 centimeters in length, with a diameter spanning between 1 to 2 centimeters, creating a visually striking and well-proportioned floral display.'
          },
          'leaf': {
            'path': 'assets/images/terleaf.png',
            'name': '',
            'description': 'The leaf structure presents a simple, opposite arrangement with an elliptic blade shape. Its margins exhibit a seamless, smooth outline, while the apex culminates into an acuminate point, adding definition to its form. The base contrasts with an acute tapering. On the upper surface, a smooth, verdant green texture captures attention, while the undersurface, characterized by a waxy texture, adopts a yellow-green hue, providing a striking contrast. Typically measuring around 12 centimeters in length, ranging between 8 to 15 centimeters, and approximately 4 centimeters in width, spanning between 3 to 6 centimeters, this leaf boasts a well-defined size and proportion. Additionally, it features pale green to yellowish stipules, enhancing its overall appearance with subtle yet distinctive hues.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/forttree.png',
          'name': 'Bombacaceae',
          'local_name': 'gapas-gapas',
          'scientific_name': 'Camptostemon philippinensis',
          'description': 'Also called Camptostemon philippinense, this species has small to medium-sized trees reaching 15 m tall and 50 cm DBH, along rivers and tidal creeks. The leaves are thick, covered with fine scales (like the buds and fruits), and crowded at the end. Surface roots emanate from the base of the trunk and spread out around mature trees - both the knobby roots and lower trunk have many lenticels and give the species a distinctive gnarled appearance. The capsule-shaped fruits have seeds covered by numerous thick white threads, hence the local name gapas-gapas meaning cotton (see opposite page, bottom left photo). The ground in a C. philippinensis grove appears white from the cottony threads of newly-fallen seeds. In Panay, the wood is used for fuel and elsewhere in the Philippines, for making household utensils and carvings.',
          'summary': '',
          'root': {
            'path': 'assets/images/fortroot.png',
            'name': '',
            'description': 'The tree stands tall and majestic, reaching heights ranging from 5 to 15 meters, boasting a substantial trunk diameter spanning 10 to 50 centimeters. Its commanding presence is accentuated by the rough, brown-gray bark, adorned with irregular flakes that add a unique texture and charm to its exterior. The presence of lenticels on the bark not only enhances its visual appeal but also aids in the exchange of gases vital for the trees well-being. Notably, surface roots, gnarled and curling, grace the trees base, intertwining with lenticels, creating a captivating and intricate aerial root system. These aerial roots not only contribute to the trees structural support but also add to its character, highlighting its adaptability and resilience in diverse environments. The amalgamation of its impressive height, robust trunk, textured bark with irregular flakes, and intricate aerial roots forms a picturesque representation of strength, resilience, and natural splendor within its habitat.'
          },
          'flower': {
            'path': 'assets/images/fortflower.png',
            'name': '',
            'description': 'The plant displays a cymose inflorescence located terminally, showcasing an elegant arrangement of flowers. Within each bloom, there are five petals, exhibiting a color spectrum ranging from pristine white to mesmerizing reddish-brown shades, creating a captivating visual contrast. Surrounding these petals are five green sepals, adding a complementary touch to the floral composition. Each bloom typically measures between 1 to 1.3 centimeters in diameter, providing a delicate and proportionate appearance. Moreover, this floral arrangement comprises clusters with an average of 3 to 4 flowers per grouping, contributing to a charming and clustered display of blossoms.'
          },
          'leaf': {
            'path': 'assets/images/fortleaf.png',          
            'name': '',
            'description': 'The leaf structure showcases a simple yet dynamic arrangement, alternating in a spiral fashion along the stem. Its blade takes on an obovate shape, featuring smooth, entire margins, creating a seamless outline. The apex of the leaf ranges from round to slightly emarginate, contributing to its distinct appearance, while the base tapers to an acute point. Its upper surface, characterized by a leathery texture, boasts a rich, dark green coloration, standing in contrast to the smooth, light green undersurface which is adorned with scales. Measuring approximately 8 centimeters in length, with a range between 5 to 9 centimeters, and around 5 centimeters in width, spanning between 3 to 7 centimeters, this leaf possesses a well-proportioned size. Additionally, a unique feature of these leaves includes the presence of fine salt crystals, further distinguishing this foliage and adding an intriguing element to its visual appeal.'
            },
          'fruit': {
            'path': 'assets/images/fortfruit.png',
            'name': '',
            'description': 'The object exhibits a rounded shape and is dehiscent in nature, implying its ability to open spontaneously to release its contents. Its color transitions from a vibrant green to an earthy brown hue, presenting a shift in appearance as it matures. The texture inside is notably cottony, adding a unique tactile quality to its characteristics. In terms of dimensions, it measures approximately 1 to 2 centimeters in length, boasting a diameter of around 7 centimeters, creating a visually substantial item. Additionally, this object possesses an intriguing quality—it is notably attractive to big red ants, perhaps due to certain compounds or elements present within it that appeal to these particular insects, adding an extra layer of interest to its attributes.'
          },
        },
        {
          'path': 'assets/images/fifthtree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'baras-baras, lapis-lapis, malatangal (Tagalog)',
          'scientific_name': 'Ceriops decandra',
          'description': 'Shrubs reaching 3 m tall that grow on the compact mud or sandy-mud of inner mangroves. This pioneer species occurs as monospecific stands that provide the leading edge of mangrove invasion of grasslands, up to the high tide limit (see opposite page, bottom left photo), but may also form the understory portion of a mixed mangrove community. Ceriops decandra differs from C. tagal by its shorter height, multiple stems, and shorter fruits (with red cotyledonary collar) that point in all directions. Roots have small flaky buttresses that give the trunk a swollen appearance. Commonly used as firewood, and as Christmas trees in Luzon. The bark of mature trees is harvested for the baluk powder used in making local tuba, although the preferred species is C. tagal.',
          'summary': '',
          'root': {
            'path': 'assets/images/fifthroot.png',
            'name': '',
            'description': 'The shrub stands gracefully, reaching a modest height between 2 to 3 meters, presenting an elegant yet compact form within its environment. Its bark, rough in texture and ranging in shades from gray to brown, showcases subtle earthy tones. With minimal lenticels, the bark adds texture to its surface while hinting at the shrubs maturity. Small aerial roots resembling buttresses delicately emerge from the base, contributing to the shrubs stability and support. These aerial roots, though diminutive, provide a unique visual element while serving a crucial role in anchoring the shrub firmly into the ground. The combination of its modest stature, textured bark with sparse lenticels, and the subtle yet effective buttress-like aerial roots, portrays the shrub as a testament to natural elegance and resilience in its habitat.'
          },
          'flower': {
            'path': 'assets/images/fifthflower.png',
            'name': '',
            'description': 'The plant showcases an axillary cymose inflorescence, featuring a clustered arrangement of flowers. Each bloom within this inflorescence consists of five white petals adorned with fine hairs, imparting a delicate and textured appearance. The five sepals, fused together, present a light green hue, encasing the floral structure. These blooms typically measure between 0.3 to 0.5 centimeters in diameter, portraying a small yet intricately detailed size. Within each cluster, there are approximately 6 to 8 flowers, each positioned on short, thick stalks, contributing to a compact and visually appealing arrangement. This floral composition with its clustered presentation and minute details presents an aesthetic charm in its overall design.'
          },
          'leaf': {
            'path': 'assets/images/fifthleaf.png',
            'name': '',
            'description': 'The leaf configuration follows a straightforward and opposite arrangement, featuring predominantly obovate-shaped blades with smooth, entire margins. The apex of the leaf varies between a round and slightly emarginate form, while the base tapers to an acute point. Its upper surface presents a smooth texture, adorned in a vibrant shade of green, providing a striking contrast to the smooth and light green undersurface. These leaves typically measure around 7 centimeters in length, ranging from 4 to 10 centimeters, and approximately 4 centimeters in width, with a range of 3 to 8 centimeters, showcasing a variable yet well-proportioned size. The uniformity of the leafs surface and its distinctive coloration contribute to its aesthetic appeal and overall visual presence.'
           },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/sixthtree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'ungog, tangal, tagasa (Tagalog)',
          'scientific_name': 'Ceriops tagal',
          'description': 'Small trees reaching 6 m tall, on firm sandy to muddy substrates of inner mangroves. Compared to C. decandra, trees are taller with a single straight trunk, and longer fruits point downwards. Leaves turn yellowish green in sunlight. Roots have small flaky buttresses; knee roots appear in older trees. Among the Rhizophoraceae, the dried C. tagal bark gives the best quality baluk powder used in making tuba, bahalina (a special tuba variety in Leyte and Samar), and basi (rice wine), and in dyeing fish nets and clothing. Wood is used for fuel, charcoal, poles for baklad (fish corrals) and house posts. In the past, big trees provided hard, fine-textured wood for furniture and house construction. The bark was used to treat hemorrhages and ulcers; older folks chewed on dried bark. Only isolated trees of C. tagal are found in Panay, aside from a small 20-year old plantation in Naisud, Ibajay, Aklan.',
          'summary': '',
          'root': {
            'path': 'assets/images/sixthroot.png',
            'name': '',
            'description': 'This tree or shrub presents a modest yet charming stature, ranging between 2 to 6 meters in height, with a trunk diameter spanning 5 to 10 centimeters. Its bark, rough in texture and displaying hues from light brown to gray, adds a rustic appeal to its appearance, characterized by its flaky nature that gives a unique touch to its surface. Notably, knee roots and low buttresses grace its base, contributing to both its visual aesthetics and structural stability. These aerial roots play a dual role, providing support and anchorage while enhancing the overall appeal of the tree or shrub. This amalgamation of a modest size, textured bark with flaky features, and the presence of knee roots and low buttresses encapsulates a harmonious blend of strength, resilience, and natural beauty within its habitat.'
          },
          'flower': {
            'path': 'assets/images/sixthflower.png',
            'name': '',
            'description': 'The plant exhibits an axillary cymose inflorescence, characterized by clusters of flowers arranged in a cyme structure. Each bloom comprises 4 to 6 white petals adorned with delicate brown hairs, imparting a textured and visually appealing aspect to the petals. The sepals, numbering between 4 to 6, are fused together, displaying a light green coloration and encasing the floral components. Within the blooms, there are typically 4 to 6 stamens, each adorned with a brown tip, adding a contrasting element to the flowers appearance. These blossoms typically measure between 0.6 to 0.9 centimeters in both length and diameter, showcasing a small yet proportionate size. The combination of white petals with brown hairs, fused light green sepals, and stamens with brown-tipped accents creates an intricate and captivating floral display within this plants axillary inflorescence.'
          },
          'leaf': {
            'path': 'assets/images/leaf.png',
            'name': '',
            'description': 'The leaf arrangement adheres to a simple and opposite pattern, predominantly displaying obovate-shaped blades with smooth margins that curl gently downwards. These leaves feature a round apex and an acute base, contributing to their distinct appearance. Their upper surface showcases a smooth texture, transitioning in color from green to yellow-green, while the undersurface maintains a consistent smooth texture with a yellow-green hue. Measuring around 8 centimeters in length, varying between 5 to 12 centimeters, and approximately 4 centimeters in width, ranging from 2 to 6 centimeters, these leaves present a variable yet well-proportioned size. Notably, these leaves exhibit an upward orientation and possess a brittle nature, adding to their unique characteristics and creating an intriguing visual appeal.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/sevthtree.png',
          'name': 'Euphorbiaceae',
          'local_name': ' lipata, alipata (Visayan), buta-buta (Cebuano)',
          'scientific_name': 'Excoecaria agallocha',
          'description': 'Small to medium trees with surface roots on sandy-muddy substrate along tidal creeks or on hard mud in the inner mangroves and along dikes of ponds. The leaves are highly variable in size, shape and color. They fall off in the dry season just before the flowers appear, but sometimes flowering trees show leaves. The only dioecious mangrove species, female and male plants can be distinguished during the reproductive period. Male flowers in full bloom, which are longer than those of females, present a spectacular but short-lived sight of numerous golden catkins hanging from bare branches. The twigs are used as pest repellent, burnt ashes for salt extraction, and leaves to treat epilepsy. Its milky sap, which flows from any cut surface on the leaf, twig or trunk can cause skin irritation and alleged blindness, hence the local name butabuta. The sap is used to treat toothache and ulcers, and as fish poison.',
          'summary': '',
          'root': {
            'path': 'assets/images/sevthroot.png',
            'name': '',
            'description': 'The tree stands tall and commanding, boasting a height ranging from 5 to 15 meters, with a substantial trunk diameter spanning between 10 to 60 centimeters. Its presence is characterized by the slightly rough bark, displaying hues of grayish-brown that often showcase a mottled appearance due to the presence of lichens. This unique combination not only adds texture to the trees surface but also emphasizes its adaptability within its environment. Remarkably, surface roots grace the tree, intertwining with the surrounding landscape. These aerial roots contribute to the trees stability and serve as a testament to its ability to thrive in diverse conditions. The trees impressive size, textured bark often adorned with lichens, and surface aerial roots collectively portray a picture of resilience and natural elegance, marking its prominence within its habitat.'
          },
          'flower': {
            'path': 'assets/images/sevthflower.png',
            'name': '',
            'description': 'The plant showcases an axillary inflorescence in the form of catkins. These catkins, bearing both male and female flowers, exhibit a striking yellow hue across their petals and stamens. In the male flowers, the catkins typically measure between 1.9 to 3.0 centimeters in length, while the female flowers are notably smaller, ranging from 0.3 to 0.7 centimeters in length. Both male and female flowers present vibrant yellow petals and stamens, contributing to a cohesive and visually appealing display. The catkins contrasting sizes and the vivid yellow coloration of the petals and stamens offer an intriguing aesthetic characteristic to the plants axillary inflorescence.'
          },
          'leaf': {
            'path': 'assets/images/sevthleaf.png',
            'name': '',
            'description': 'The leaves demonstrate a simple yet dynamic arrangement, appearing alternately and spirally along the stem. Each leaf possesses an elliptical shape with smooth, entire margins, culminating in an acute apex and base. The upper surface maintains a smooth texture and displays a vibrant green coloration, while the undersurface features a similarly smooth texture but in a lighter shade of green. Measuring about 5 centimeters in length, ranging from 3 to 8 centimeters, and approximately 3 centimeters wide, spanning between 2 to 4 centimeters, these leaves showcase a variable yet well-proportioned size. Additionally, these leaves release a white milky sap when damaged and are deciduous in nature, shedding their foliage seasonally, adding to their distinct characteristics.'
          },
          'fruit': {
            'path': 'assets/images/sevthfruit.png',
            'name': '',
            'description': 'The object presents a rounded form characterized by three distinct lobes, adding dimension to its shape. Initially green, it transitions to a brown hue upon reaching maturity. Its surface texture remains consistently smooth throughout its growth. Measuring between 0.4 to 0.6 centimeters in diameter, this object maintains a modest size. Notably, its short style splits into three curling strands, creating an intricate and visually engaging feature that contributes to its unique appearance and adds to its overall appeal.'
          },
        },
        {
          'path': 'assets/images/eytitree.png',
          'name': 'Sterculiaceae',
          'local_name': 'dungon, dungon-late',
          'scientific_name': 'Heritiera littoralis',
          'description': 'Medium-sized trees up to 20 m high found in back mangroves, often on dry land along forest margins. The big, dark green leaves have a characteristic silvery-white undersurface, and the hard, shiny fruits are boat-shaped with a ridge. Prominent buttress roots have flattened extensions, called plank roots, that criss-cross the substrate. These buttresses reach ~ 3 m high in the magnificent Heritiera littoralisstand in Iriomote, Okinawa, southern Japan (S. Baba, personal communication). The species is widely distributed in the Philippines - evidence of its previous abundance are two neighboring barangays both named Dungon in Jaro, Iloilo City. Past uses of the hard, heavy wood include piles, bridges and wharves. The pre-Hispanic balanghaiboats excavated from Agusan del Norte were made of dungon. Roots used as fish poison, seed extracts to treat diarrhea and dysentery.',
          'summary': '',
          'root': {
            'path': 'assets/images/eytiroot.png',
            'name': '',
            'description': 'The tree stands majestically, reaching heights spanning from 5 to 20 meters, boasting a substantial trunk diameter ranging between 20 to 50 centimeters. Its presence is defined by the rough, dark brown bark that adds a sense of robustness to its appearance, characterized by its flaky texture. Notably, the tree displays prominent buttresses that lend both visual allure and structural support, enhancing its stability within the ecosystem. Alongside these buttresses, the tree showcases plank or ribbon-like aerial roots, which further reinforce its anchorage and contribute to its resilience. This amalgamation of impressive height, robust trunk, textured bark with flaky features, and the presence of prominent buttresses and distinct plank or ribbon-like aerial roots exemplifies a resilient and commanding presence within its natural surroundings.'
          },
          'flower': {
            'path': 'assets/images/eytiflower.png',
            'name': '',
            'description': 'The plant showcases an axillary panicle inflorescence, characterized by a branching cluster of flowers. These flowers notably lack petals. Instead, each bloom comprises four sepals that exhibit a hairy texture. The inner side of these sepals presents a striking pink-red hue, while the outer side displays a contrasting yellow-green coloration. These sepals typically measure between 0.3 to 0.5 centimeters in diameter, presenting a modest yet visually appealing size. An additional notable aspect is that these flowers are unisexual, indicating that individual plants may bear either male or female reproductive structures, contributing to the diversity and complexity of the plants reproductive strategy.'
          },
          'leaf': {
            'path': 'assets/images/eytileaf.png',
            'name': '',
            'description': 'The leaves of this particular plant exhibit a fascinating arrangement that follows a simple, alternating, and spiral pattern. Their blade shape ranges from elliptical to oblong, contributing to their distinctive appearance. Sporting entire to undulate margins, these leaves boast an acute apex and a base that varies from acute to round, showcasing a diverse morphology. Their upper surface presents a robust, leathery texture, adorned with a deep green hue, while the undersurface is characterized by minuscule scales that shimmer in a silvery tone. Typically measuring around 17 centimeters in length (with a range of 11 to 27 centimeters) and 8 centimeters in width (varying from 5 to 14 centimeters), these leaves display significant size diversity. Notably, some of these leaves bear intriguing insect galls, adding an additional layer of interest and complexity to their overall appearance, as depicted in the accompanying photo.'
          },
          'fruit': {
            'path': 'assets/images/eytifruit.png',
            'name': '',
            'description': 'These particular entities stand out due to their distinctive boat-shaped configuration, a defining trait that captures attention. Ranging in color from a vibrant green to a more earthy brown, their appearance can vary widely, showcasing natures diverse palette. The texture of these structures is notably glossy and robust, characterized by a hard exterior that adds to their allure. Measuring between 5 to 9 centimeters in length and 4 to 6 centimeters in diameter, they possess a moderate yet noticeable size. One unique feature lies in their central ridge or keel, adding a defining element to their overall structure and augmenting their visual intrigue.'
          },
        },
        {
          'path': 'assets/images/ninethtree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'tangal',
          'scientific_name': 'Kandelia candel',
          'description': 'Kandelia candel has been found in only two sites in the Philippines - Castillo, Baler (~ 10 specimens) and Cozo, Casiguran Bay – both in Aurora Province on the eastern side of Luzon. It was first identified in May 1996 (Zisman et al., 1998). Except for this report, K. candel is not mentioned in any of the published lists of Philippine mangrove species. The Aurora plants are small, slender trees up to 5 m tall on muddy substrate along tidal creeks and rivers where they are associated with N. fruticans and S. alba. In other Southeast Asian countries, the trees are reported to be taller, with bigger buttresses, prop roots and pneumatophores.',
          'summary': '', 
          'root': {
            'path': 'assets/images/ninethroot.png',
            'name': '',
            'description': 'The tree stands gracefully, reaching a height between 3 to 5 meters, adorned with a sturdy trunk measuring 5 to 15 centimeters in diameter at breast height (DBH). Its bark, smooth and textured in shades of rich brown, exudes a calming presence, embellished with distinctive lenticels that add a unique pattern to its surface. At the base, low buttresses extend outwards, providing stability and character to the trees foundation. Amidst its canopy, aerial roots delicately entwine, weaving a network that supports and nourishes this arboreal marvel, showcasing natures intricate design and resilience.'
          },
          'flower': {
            'path': 'assets/images/ninethflower.png',
            'name': '',
            'description': 'The arrangement of these blooms is characterized by a cyme structure that emerges from the axils, presenting an elegant display. Each flower comprises 4 to 5 delicate, thin petals that boast a pristine white hue, contributing to their understated beauty. Surrounding these petals are 4 to 5 reflexed sepals, forming a complementary backdrop to the floral ensemble. Within each bloom, numerous white stamens create an intricate and captivating focal point. These flowers typically measure between 1.5 to 2 centimeters in length, a modest yet charming size. Notably, they tend to cluster in pairs, with each cluster showcasing the graceful harmony of two blossoms, further enhancing their overall aesthetic appeal.'
          },
          'leaf': {
            'path': 'assets/images/ninethleaf.png',
            'name': '',
            'description': 'The leaves of this particular plant exhibit a straightforward yet striking arrangement, growing in a simple pattern that aligns opposite each other along the stem. Their blade shape ranges from oblong to elliptic, framing a foliage that exudes elegance. With smooth and entire margins, these leaves culminate in an apex that varies from obtuse to round while showcasing an acute base. Their upper surface maintains a smooth texture, displaying a vibrant spectrum from yellow-green to a rich green hue, while the underside presents a consistent smoothness in a lush green tone. Measuring between 10 to 16 centimeters in length and 3 to 5 centimeters in width, these leaves possess a moderate size, offering a substantial yet graceful presence. Noteworthy are the reddish to yellow stipules accompanying these leaves, adding a touch of color contrast, and a prominent midrib that elegantly traverses through the leaf, accentuating its overall structure.'
           },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
         },
        },
        {
          'path': 'assets/images/twentree.png',
          'name': 'Combretaceae',
          'local_name': 'abao, libato (Tagalog)',
          'scientific_name': 'Lumnitzera littorea',
          'description': 'Medium to tall trees reaching 12 m high in stands along tidal creeks and on muddy to sandy-muddy substrates of back mangroves. In Palawan, a natural stand provides shade to a multispecies mangrove nursery (see opposite page, bottom left photo). Lumnitzera littorea is easily differentiated from L. racemosa by its bigger size, darker green leaves, and bright red flowers whose buds look like small lipsticks. The beautiful decorative flowers make L. littorea suitable for planting in beach resorts. Old L. littoreatrees in a small pristine mangrove patch in Jawili, Tangalan, Aklan have branches bent close to the ground and a dark trunk that is crooked. Branches can be used for fuel and for smoking fish. A decoction of the leaves is used to treat thrush in infants. In the past, the hard, strong wood was used for heavy construction - bridges, wharves, ships, cart axles, flooring and furniture',
          'summary': '',
          'root': {
            'path': 'assets/images/twenroot.png',
            'name': '',
            'description': 'Standing tall at heights ranging from 3 to 12 meters, this tree boasts a commanding presence with a robust trunk that spans between 10 to 60 centimeters in diameter at breast height (DBH). Its bark, textured and resilient, presents a fibrous and rough exterior marked by deep fissures, cloaked in a distinguished shade of dark brown. The intricate patterns on the bark denote its enduring strength and age, weathered by time and the elements. Extending outwards, its aerial roots form an expansive and intricate network across the surface, intertwining like delicate threads to anchor and fortify the trees foundation. This remarkable display of extensive surface roots embodies the trees resilience and adaptability, showcasing the artistry of natures design.'
          },
          'flower': {
            'path': 'assets/images/twenflower.png',
            'name': '',
            'description': ''
          },
          'leaf': {
            'path': 'assets/images/twenleaf.png',
            'name': '',
            'description': 'The arrangement of leaves on this plant is characterized by a simple and alternate pattern, forming a captivating spiral along the stem. These leaves, shaped obovate, boast smooth, entire margins, contributing to their sleek appearance. Their apex ranges from round to slightly emarginate, while their sessile base adds to their distinctive structure. The upper surface of these leaves presents a smooth texture and a lush green color, mirrored by the smooth, green undersurface. Sized at 6 centimeters on average, with variability between 4 to 9 centimeters in length and 2 to 4 centimeters in width, these leaves exhibit a succulent, brittle nature, further enhancing their unique attributes within the plants composition.'
          },
          'fruit': {
            'path': 'assets/images/twenfruit.png',
            'name': '',
            'description': 'The silhouette of this plant is reminiscent of a vase, boasting a distinct vase-shaped structure that captures attention. Its color palette showcases a dark green hue with a reddish base, adding depth and character to its appearance. The texture of this specimen is notably smooth, offering a sleek and polished surface. Measuring between 1 to 2 centimeters in length and ranging from 0.3 to 0.7 centimeters in diameter, these formations exhibit a succulent nature, emphasizing their capacity to store water. This combination of features - from its unique shape to the rich coloration and smooth texture - defines a captivating and visually striking presence within its botanical surroundings.'
          },
        },
        {
          'path': 'assets/images/21tree.png',
          'name': ' Combretaceae',
          'local_name': 'tabao, culasi, bolali (Negros Occidental)',
          'scientific_name': 'Lumnitzera racemosa',
          'description': 'A pioneering species of small trees up to 6 m high often found in the muddy back mangrove where it forms thick stands and on sandy beaches near the high water line. It has multiple stems, surface roots and succulent leaves with many conspicuous insect bites; older trees have a single trunk and looping roots. Lumnitzera racemosa is so widely distributed that many Philippine towns and villages are named after it (Table 8). Interestingly, the two sister species are rarely found together, except in Naisud, Ibajay, Aklan. Aside from firewood, the dried twigs are used as fish-aggregating devices and the leaves as forage for livestock. The trunks of bigger trees are used as house posts. Villagers in Taba-ao, Sagay, Negros Occid. use both cut stems, and planted L. racemosainterspersed with B. cylindrica, to form a living fence around their dwellings (see opposite, bottom left photos). It is also planted along dikes of fishponds.',
          'summary': '',
          'root': {
            'path': 'assets/images/21root.png',
            'name': '',
            'description': 'The tree or shrub, standing at a height range of 3 to 6 meters, presents a remarkable sight with its sturdy form. Its trunk, measuring between 3 to 10 centimeters in diameter, is enveloped in a coarse, fibrous bark, tinted in rich shades of brown and deeply fissured, showcasing the passage of time and resilience to the elements. The aerial roots, particularly noticeable in mature specimens, manifest as a web of surface roots, gracefully looping and intertwining, offering additional support and anchorage to the plant. This captivating combination of height, bark texture, and looping aerial roots embodies the unique and enduring characteristics of this striking tree or shrub.'
          },
          'flower': {
            'path': 'assets/images/21flower.png',
            'name': '',
            'description': 'The floral arrangement of this plant manifests in a spike formation nestled within the axils, showcasing delicate beauty. Comprising five white petals, these blooms exude elegance against the backdrop of five fused green sepals, forming a cohesive ensemble. Within this assembly, ten stamens stand out with their pale yellow coloration, adding a subtle yet charming contrast to the overall composition. Measuring between 1 to 1.6 centimeters in length and spanning from 0.6 to 1 centimeter in diameter, these blossoms epitomize a delicate grace, both in their size and in the harmonious blend of colors that contribute to their serene allure.'
          },
          'leaf': {
            'path': 'assets/images/21leaf.png',
            'name': '',
            'description': 'The foliage of this plant exhibits a simple, alternate arrangement, spiraling along the stem in an organized fashion. Its obovate-shaped leaves feature smooth, entire margins, contributing to their refined appearance. With an apex that ranges from emarginate to round and a sessile base, these leaves boast symmetry in their structure. Their upper surface, characterized by a smooth texture and a light green hue, complements the equally smooth and light green undersurface. Measuring around 6 centimeters in length on average, with variability between 4 to 9 centimeters, and spanning 2 to 4 centimeters in width, these leaves portray a succulent nature, signifying their ability to store moisture. This combination of traits - from their distinct shape and smooth texture to the vibrant yet soothing coloration - defines their graceful presence within the plants overall form.'
          },
          'fruit': {
            'path': 'assets/images/21fruit.png',
            'name': '',
            'description': 'The distinctive form of this plant structure resembles that of a pitcher, characterized by its unique shape. Sporting a vivid green hue, it stands out in its natural environment. The surface texture is smooth and waxy, adding a sleek and polished quality to its appearance. Sized between 1.1 to 1.8 centimeters in length and spanning 0.5 to 0.7 centimeters in diameter, this structure embodies a balanced proportion. Notably, one side of this component slightly bulges, creating an intriguing asymmetry, while the other side remains flat, enhancing its distinctiveness. This blend of features - from its pitcher-like shape and smooth texture to the uniform green coloration - contributes to its visually appealing and unique presence within the plants configuration.'
          },
        },
        {
          'path': 'assets/images/22tree.png',
          'name': 'Palmae',
          'local_name': 'nipa, sapsap, sasa (Tagalog)',
          'scientific_name': 'Nypa fruticans',
          'description': 'The only palm among true mangrove species, Nypa fruticans forms extensive belts along muddy edges of brackish to almost freshwater creeks and rivers. Individual plants are also found in mixed mangrove communities. It has creeping stems called rhizomes from which tall (up to 8 m high) compound leaves arise. Commercially important, its products include the local drink tuba, vinegar and alcohol from the sap of the inflorescence (see opposite, bottom left photo); roofing material, native hats (salakot), raincoats, baskets, bags, mats, and wrappers from leaflets; and brooms from midribs. The fruit endosperm is eaten fresh or cooked, and the trunk pith is prepared as salad. The Sanskrit name Nypatithau was that of a generous man who gave everything of himself. Coincidentally, Nypa was first applied in Indonesia to this palm species, which gives of its every useful part so to speak (M. Vannucci, personal communication).',
          'summary': '',
          'root': {
            'path': 'assets/images/22root.png',
            'name': '',
            'description': 'The palm, characterized by its distinctive shape, spans a height ranging from 2 to 8 meters, projecting a graceful and towering silhouette against the sky. Its roots, identified as creeping rhizomes, sprawl beneath the earths surface, forming an intricate network that aids in stability and nutrient absorption. This particular growth pattern not only contributes to the palms structural support but also facilitates its ability to thrive in various soil conditions. Coupled with its varying heights, the palms utilization of creeping rhizomes underscores its adaptability and resilience, marking it as an emblem of natural elegance and adaptiveness in diverse environments.'
          },
          'flower': {
            'path': 'assets/images/22flower.png',
            'name': '',
            'description': 'The plants  inflorescence takes the form of a catkin, elegantly arranged within the axils of its foliage. The petals exhibit a striking range of colors, varying from yellow to vivid orange, while the sepals complement this palette with their vibrant orange hue. Within this floral assembly, the stamens stand out prominently in a contrasting yellow shade, adding depth and visual allure to the bloom. Notably, the floral elements exhibit a dimorphic nature, indicating distinct structural differences between certain reproductive parts. This unique characteristic contributes to the intricate and captivating display of the plants flowering stage, creating an eye-catching spectacle within its natural setting.'
          },
          'leaf': {
            'path': 'assets/images/22leaf.png',
            'name': '',
            'description': 'The arrangement of this plants foliage presents a compound structure characterized by an odd pinnate formation, projecting a distinctive botanical pattern. Its lanceolate leaflets display smooth and entire margins, embodying an acute apex and a sessile base, creating a unified and balanced leaflet composition. On the upper surface, these leaflets showcase a smooth texture and a vibrant green color, while the undersurface boasts a powdery texture, presenting a lighter shade of green. Each leaflet measures between 40 to 120 centimeters in length and spans from 4 to 9 centimeters in width, contributing to the grandeur of this foliage. Impressively, a single leaf can bear between 80 to 120 leaflets, and there are typically 10 to 20 leaves forming a cluster, culminating in a striking and densely packed arrangement that defines the plants majestic appearance.'
          },
          'fruit': {
            'path': 'assets/images/22fruit.png',
            'name': '',
            'description': 'The ball-shaped cluster of fruits boasts a rich spectrum of colors, ranging from light to dark brown, creating an enticing visual allure. Each individual fruit within this cluster exhibits a smooth, shiny texture, adding to the overall appeal. The collective size of this fruit assembly spans a diameter of 20 to 40 centimeters, presenting a substantial and captivating sight. Moreover, within these fruits lies an edible endosperm, often referred to as the meat, offering a delightful treat for those who indulge in its flavorsome bounty. This unique combination of appearance, texture, size, and edible content renders this ball-shaped cluster of fruits a fascinating and tempting natural marvel.'
          },
        },
        {
          'path': 'assets/images/23tree.png',
          'name': 'Myrtaceae',
          'local_name': ' bunot-bunot, tawalis, dukduk (Negros)',
          'scientific_name': 'Osbornia octodonta',
          'description': 'Shrubs to small trees reaching 6 m tall with surface roots, often with multiple irregular stems. They can tolerate high salinity and are found in stands on the high tide line on exposed rocky and sandy shores or the sheltered elevated flats of the foreshore. Osbornia octodonta is sometimes associated with other high shore species like P. acidula and A. floridum, and shares a superficial resemblance with the latter. It has small, brittle leaves which emit an aroma when crushed, small white flowers, capsuleshaped fruits, deeply fissured bark and cable roots often exposed on rocky shores. Aside from fuelwood, the dried twigs (see opposite page, bottom left photo) are made into baskets and used as fish-aggregating devices by local fishers.',
          'summary': '',
          'root': {
            'path': 'assets/images/23root.png',
            'name': '',
            'description': 'The tree or shrub, with a stature reaching between 3 to 6 meters in height, boasts a commanding presence in its environment. Its trunk, measuring approximately 5 to 15 centimeters in diameter, is encased in a robust and textured bark. This bark, characterized by its thickness, sponginess, and rough texture with long fissures, displays a color palette transitioning from shades of brown to subdued grays, showcasing a weathered yet enduring exterior. Along its surface, this botanical marvel showcases aerial roots, delicately extending and intertwining, establishing a network that contributes to the plants stability and sustenance. The amalgamation of its size, bark texture, and surface aerial roots depicts an arboreal or shrubbery masterpiece, illustrating strength, adaptability, and an organic harmony within its ecosystem.'
          },
          'flower': {
            'path': 'assets/images/23flower.png',
            'name': '',
            'description': 'The inflorescence is a cyme structure, delicately arranged in the axils, exuding an understated yet captivating presence. Within this arrangement, the absence of petals characterizes the flowers as apetalous, drawing attention to other distinct features. The sepals, a radiant yellow-green hue, appear fused together, forming a protective enclosure around the delicate inner components. Numerous stamens, in a pristine white shade, stand out amidst the vibrant sepals, boasting yellow pollen that adds a subtle yet striking contrast. Each flower measures between 0.5 to 1 centimeters in length and spans a diameter of 0.2 to 0.5 centimeters, presenting a dainty and intricate floral display. Typically, clusters consist of three flowers, contributing to a charming and balanced arrangement that highlights the unique beauty of each delicate bloom.'
          },
          'leaf': {
            'path': 'assets/images/23leaf.png',
            'name': '',
            'description': 'The leaves showcase a simple yet elegant arrangement, positioned oppositely in a decussate manner, exhibiting a distinctive charm. Their obovate shape characterizes a broader top tapering down to a narrower base, creating a visually appealing outline. The smooth, entire margins contribute to their graceful appearance, emphasizing a seamless continuity along the edges. These leaves culminate with an emarginate apex and a sessile base, further enhancing their overall allure. Displaying a smooth, pale green upper and undersurface, each leaf measures around 4 (ranging from 3 to 6) centimeters in length and 2 (with a span of 1 to 3) centimeters in width. Additionally, their thin and brittle nature adds a delicate quality, accentuating their understated beauty with a fragile elegance.'
          },
          'fruit': {
            'path': 'assets/images/23fruit.png',
            'name': '',
            'description': 'The fruit takes the form of a capsule, presenting a visually subtle yet distinctive pale green coloration that lends it a delicate charm. Its surface texture is characterized by a dense covering of fine hairs, imparting a slightly rough and tactile quality to the touch. Measuring between 0.7 to 1 centimeter in length and spanning a diameter of 0.3 to 0.5 centimeters, the capsule encapsulates the seeds within its confines. Notably, the calyx entirely encases the fruit, serving as a protective shield for the developing seeds within, further adding to its overall appeal and contributing to its unique botanical characteristics.'
          },
        },
        {
          'path': 'assets/images/24tree.png',
          'name': 'Lythraceae',
          'local_name': 'bantigi',
          'scientific_name': 'Pemphis acidula',
          'description': 'Shrubs 3-5 m tall, along the high tide line of coralline-rocky and sandy foreshores, often in association with O. octodonta and A. f loridum. It has irregularly shaped branches, small leaves, and small white flowers. Distribution in Panay is limited to small stands in Carles, Iloilo; Taklong Island, Guimaras; and Anini-y, Antique. The twigs are used for fuel and also as fish-aggregating devices, like O. octodonta. Wood of Pemphis acidula is very hard and strong, hence it is used in house and fence construction. Because of its small size and sturdy nature, the species is a favorite material of bonsai enthusiasts (see opposite, bottom left photo). Some ten years ago, the Department of Environment and Natural Resources confiscated specimens collected from Nogas Is., Antique which were to be smuggled to Taiwan and sold at Philippine Pesos (PhP) 2,000 per plant.',
          'summary': '',
          'root': {
            'path': 'assets/images/24root.png',
            'name': '',
            'description': 'The shrub or tree stands gracefully, reaching a height of 3 to 5 meters and exuding an understated yet remarkable presence. Its trunk, with a diameter spanning between 5 to 12 centimeters, is adorned with an outer layer of rough, grayish-brown bark, distinguished by prominent large lenticels that create a textured and visually appealing surface. This bark, while showcasing a subdued hue, speaks volumes about the trees endurance and resilience. Interestingly, unlike some counterparts, this species exhibits less noticeable aerial roots, relying more on its root system beneath the soil for stability and nourishment. Despite the absence of prominent aerial roots, the amalgamation of its height, bark texture, and sturdy form embodies a quiet strength and elegance, complementing its environment with subtle sophistication.'
          },
          'flower': {
            'path': 'assets/images/24flower.png',
            'name': '',
            'description': 'The flowers of this plant are characterized by a single, axillary inflorescence, where blooms emerge from the leaf axils. Each flower features six white petals, creating an aesthetically pleasing and delicate appearance. The sepals, totaling twelve in number, are fused, providing structural support to the blossoms. Within the flower, there are twelve stamens, contributing to the reproductive apparatus. The size of these flowers is relatively small, with a length ranging from 0.7 to 1 centimeter and a diameter spanning 0.9 to 1.8 centimeters. This combination of floral features, from the arrangement to the color and size, adds to the overall allure of this plants reproductive structures, contributing to its botanical identity.'
          },
          'leaf': {
            'path': 'assets/images/24leaf.png',
            'name': '',
            'description': 'The leaves of this plant exhibit a distinctive arrangement, being simple and arranged in an opposite, decussate fashion. Their blade shape is elliptical, boasting smooth margins and an apex that ranges from acute to obtuse. With a base characterized as acute, these leaves measure 2-3 centimeters in length and 1 centimeter in width. The upper surface showcases a velvety texture in a pale green hue, while the undersurface is also velvety but with a whitish-green tint. Notably, the leaves are covered with minute hairs, contributing to their unique texture and appearance. This combination of characteristics underscores the intricate and nuanced nature of this plants foliage, making it easily identifiable within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/24fruit.png',
            'name': '',
            'description': 'The fruits of this plant take the form of capsules, contributing to their distinct appearance. These capsules exhibit a brown color and a smooth texture, adding to their overall visual appeal. In terms of size, they measure between 0.4 and 0.9 centimeters in length, with a diameter ranging from 0.3 to 0.6 centimeters. Notably, the fruit is enclosed in a bell-like structure, enhancing its unique and intricate design. This feature not only serves as a distinctive characteristic but also plays a role in protecting and containing the seeds within. The combination of capsule shape, brown coloration, smooth texture, and the enclosing bell-like structure contributes to the overall botanical profile of this plants fruits, completing the life cycle with a notable reproductive feature.'
          },
        },
        {
          'path': 'assets/images/25tree.png',
          'name': 'Rhizophoraceae ',
          'local_name': 'bakhaw, bakhaw lalaki, bulubaladaw (Antique)',
          'scientific_name': 'Rhizophora apiculata',
          'description': 'Medium to tall trees reaching 20 m on loose mud of tidal rivers and creeks, and sandy mud of the seaward zone behind the outer 5. alba-A. marina band where Rhizophoraapiculata forms monospecific stands. Its wide distribution in Panay and elsewhere in the Philippines is due to its pioneering nature and popularity for replanting. It is the preferred species for plantations because of availability of propagules and fast growth. The inflorescence usually bears 2 sessile flowers on a very short peduncle. The buds are compact and used by children as bullets for toy guns. The fruits are long, smooth and viviparous. The leaves are dark green and flat, and may be fed to pigs (see opposite page, bottom left photo); the interpetiolary stipules are dark pink to red. Other differentiating features are found in Table 6.',
          'summary': '',
          'root': {
            'path': 'assets/images/25root.png',
            'name': '',
            'description': 'This particular tree is characterized by its impressive stature and distinctive form, presenting itself as a tree with a height ranging from 4 to 20 meters. The diameter at breast height (DBH) typically falls within the range of 10 to 40 centimeters, indicating a robust and well-established specimen. The bark of the tree is rough in texture, displaying shades of grayish to brown, adding to its visual appeal. Notably, this tree features prop roots that extend above the ground, contributing to its structural stability and adaptation to its environment. These aerial roots provide additional support to the tree, anchoring it securely in the soil. The combination of these features underscores the resilience and adaptability of this tree species, making it a notable presence in the natural landscape.'
          },
          'flower': {
            'path': 'assets/images/25flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in cymes, emerging from axillary positions on the branches. Each individual flower features four white petals, providing a striking visual contrast. The sepals, numbering four, exhibit an intriguing coloration, appearing yellow to red on the outside. Within the flower, twelve brown stamens contribute to the reproductive structure. These flowers are relatively small, measuring between 1.2 and 1.4 centimeters in length. Notably, the trees flowering pattern includes the presence of two flowers per cluster, creating a visually appealing arrangement. Its worth mentioning that these flowers lack a distinct style. This combination of floral characteristics, from coloration to arrangement and reproductive features, adds to the overall botanical identity of this tree, making it a unique and identifiable presence in its ecological niche.'
          },
          'leaf': {
            'path': 'assets/images/25leaf.png',
            'name': '',
            'description': 'The leaves of this tree are characterized by a simple, opposite arrangement, showcasing an elliptic blade shape with smooth and entire margins. The apex of the leaves is apiculate, adding a distinctive pointed feature. The base is acute, contributing to the overall symmetry of the foliage. These leaves exhibit a smooth texture, with the upper surface displaying a dark green hue, while the undersurface maintains a smooth and green appearance. Notably, dark red stipules further enhance the visual interest of the foliage. The size of the leaves ranges from 9 to 10 centimeters in length and 4 to 7 centimeters in width, creating a proportionate and well-balanced aspect to the trees overall canopy. This combination of characteristics, from the leaf arrangement to size and coloration, contributes to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/26tree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'bakhaw',
          'scientific_name': 'Rhizophoraceae Rhizophora x lamarckii',
          'description': 'A sterile hybrid of Rhizophora apiculata x R. stylosa, this species can be found on the sandy-muddy substrate along the seaward fringe of protected islands. The trees are usually isolated but close to the parent plants. The characters are the same as R. apiculata - reddish interpetiolary stipules but slightly longer peduncles with two flowers each which never develop into fruits. The buds look like those of R. apiculataand the style is shorter than in R. stylosa. A single specimen has been found in the Taklong Island National Marine Reserve, Nueva Valencia, Guimaras (10°24’22.46” N, 122°30’46.26” E). This hybrid has also been reported by Yao (1999) from various sites in central Visayas – Okiot, Dewey Is., Bais and Tinguib, Ayongon both in Negros Oriental; Pagangan Is., Calape and Handayan Is., Getafe both in Bohol; and Taug, Carcar, Cebu. Uses of the various Rhizophora species are similar (see opposite page).',
          'summary': '',
          'root': {
            'path': 'assets/images/26root.png',
            'name': '',
            'description': 'This tree presents itself with a distinct and imposing form, manifesting as a tree with a height reaching up to 12 meters. The diameter at breast height (DBH) measures 15 centimeters, indicating a mature and substantial specimen. The bark of the tree is characterized by a rough texture, displaying tones ranging from grayish to brown, contributing to its natural aesthetics. Notably, this tree features prop roots that extend above the ground, enhancing its structural stability and adaptation to its environment. These aerial roots, in the form of prop roots, serve not only as a unique feature but also play a crucial role in providing additional support to the tree, anchoring it securely in the soil. The combination of these features underscores the resilience and adaptability of this tree, making it a notable and distinctive presence in its ecological context.'
          },
          'flower': {
            'path': 'assets/images/26flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in cymes, emerging from axillary positions on the branches. Each flower presents four white petals, adding to its visual allure, and notable hairy textures. The calyx comprises four yellowish sepals, contributing to the overall color contrast. These flowers are relatively small, with a size ranging from 1.1 to 1.4 centimeters in length. Noteworthy features include the occurrence of two flowers per cluster and a longer peduncle, measuring between 2 and 3 centimeters. Additionally, these flowers are sterile, underscoring their role in reproductive processes. The combination of these floral characteristics, from the arrangement to petal features and reproductive traits, adds to the overall botanical identity of this tree, making it a unique and identifiable presence in its ecological niche.'
          },
          'leaf': {
            'path': 'assets/images/bakhawleaf.png',
            'name': '',
            'description': 'The leaves of this tree are characterized by a simple, opposite arrangement, featuring elliptic blades with smooth and entire margins. The apex is apiculate, lending a pointed finish to each leaf, while the base is acute, contributing to the overall symmetry of the foliage. These leaves exhibit distinctive features, with the upper surface appearing waxy and displaying a rich, dark green color. In contrast, the undersurface is smooth and showcases a yellow-green hue. The size of the leaves ranges from 13 to 15 centimeters in length and 5 to 6 centimeters in width, providing a proportionate and well-balanced aspect to the trees overall canopy. Notably, reddish stipules further enhance the visual interest of the foliage, adding to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/27tree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'bakhaw, bakhaw babae',
          'scientific_name': 'Rhizophora mucronata',
          'description': 'Medium to big trees reaching 15 m in Panay (but 30 m in Aurora and other provinces). Its wide distribution overlaps with other Rhizophora species although R. mucronata is more strongly associated with the soft muds of estuarine rivers and tidal creeks. In the seaward fringe, it is typically found behind R. apiculata, the “front-line” species. R. mucronata has broader leaves with yellow to light green stipules, pendulous flowers, and long warty propagules. It is favored for fuelwood and charcoal because of its high heating value, like other Rhizophora species. In the past, it was cultivated with R. apiculata in fuelwood plantations around Manila and sold on the street (see opposite, bottom left photo). The dried hypocotyls were smoked as cigars. In the 1950s-70s, wood chips from these two species were exported from the Philippines, Malaysia and other Southeast Asian countries to Japanese rayon fiber factories.',
          'summary': '',
          'root': {
            'path': 'assets/images/27root.png',
            'name': '',
            'description': 'This tree exhibits a distinctive and stately form, presenting itself in the characteristic shape of a tree with a height ranging from 4 to 15 meters. The diameter at breast height (DBH) measures between 8 and 20 centimeters, indicating a mature and substantial specimen. The bark of the tree is textured with a rough surface, displaying hues that transition from grayish to brown, contributing to its natural aesthetic. A notable feature of this tree is the presence of prop roots, extending above the ground. These prop roots serve not only as a unique and visually interesting aspect of the tree but also play a functional role in providing additional support and stability, anchoring the tree securely in the soil. The combination of these features underscores the resilience and adaptability of this tree, making it a noteworthy and distinctive presence in its botanical context.'
          },
          'flower': {
            'path': 'assets/images/27flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in cymes, emerging from axillary positions on the branches. Each flower features four white petals with a distinctive hairy texture, creating an aesthetically appealing contrast. The sepals, numbering four, exhibit a light yellow coloration, contributing to the overall vibrancy of the blooms. Within the flower, there are eight brown stamens, adding to the reproductive structure. The size of these flowers ranges from 1.2 to 2 centimeters in length and 1 to 1.5 centimeters in diameter, providing a delicate and intricate appearance. Noteworthy features include a 3 to 5 centimeter-long peduncle, accommodating 2 to 6 flowers per cluster, enhancing the visual impact. Additionally, the flowers are characterized by a 1 mm style, further detailing their reproductive attributes. This combination of floral characteristics, from coloration to arrangement and reproductive features, adds to the overall botanical identity of this tree, making it a unique and identifiable presence in its ecological niche.'
          },
          'leaf': {
            'path': 'assets/images/27leaf.png',
            'name': '',
            'description': 'The leaves of this tree showcase a simple and opposite arrangement, featuring elliptic blades with smooth and entire margins. The apex of the leaves is characterized as mucronate, adding a subtle pointed projection. The base is acute, contributing to the overall symmetry of the foliage. These leaves exhibit a smooth texture, with the upper surface presenting a rich, dark green color, while the undersurface is smooth and displays a yellow-green hue. The size of the leaves varies, ranging from 11 to 19 centimeters in length and 6 to 10 centimeters in width, creating a proportionate and well-balanced aspect to the trees overall canopy. Notably, the leaves are adorned with black dots, adding a distinctive pattern, and light green stipules further enhance the visual interest of the foliage. This combination of characteristics contributes to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/28tree.png',
          'name': 'Rhizophoraceae',
          'local_name': 'bakhaw, bakhaw bato, bangkao',
          'scientific_name': 'Rhizophora stylosa',
          'description': 'Small to medium trees up to 10 m high. Widely distributed, Rhizophora stylosa overlaps with the habitat of R. apiculata but prefers sandy and rocky intertidal shores. Leaves have sides which typically curl or roll downward, differentiating it from other Rhizophora species; the leaves on terminal branches slant or point upward. Like other mangroves, the roots are often overgrown by epiphytic algae (see opposite page, bottom right photo). Uses for fuelwood and dyes are similar to other Rhizophora species. It is also favored for planting - the provincial government of Antique provided funds for the almost yearly procurement from 1995 to 2001 of more than 70,000 R. stylosapropagules from Semirara Island for planting in Lipata, Culasi by the people’s organization OMMMALI (see Table 13).',
          'summary': '',
          'root': {
            'path': 'assets/images/28root.png',
            'name': '',
            'description': 'This distinctive tree assumes the form of a graceful and compact structure, presenting itself as a tree with a height ranging from 3 to 10 meters. The diameter at breast height (DBH) measures between 6 and 15 centimeters, indicative of a moderately sized and well-established specimen. The trees bark, textured with a rough surface, showcases earthy tones transitioning from grayish to brown, contributing to its natural aesthetics. Notably, this tree features aerial roots, specifically in the form of prop roots. These roots extend above the ground, serving both functional and ornamental purposes by providing additional support and stability while adding visual interest to the trees overall profile. The combination of these features underscores the resilience and adaptability of this tree, making it a distinctive and noteworthy presence within its botanical context.'
          },
          'flower': {
            'path': 'assets/images/28flower.png',
            'name': '',
            'description': 'The flowers of this tree form an elegant display with an inflorescence arrangement in cymes emerging from axillary positions on the branches. Each flower showcases four white petals adorned with fine hairs, creating a delicate and textured appearance. The four light yellow sepals provide a subtle yet complementary contrast to the white petals. The reproductive structure is characterized by eight brown stamens. The size of these blossoms ranges from 1.1 to 1.5 centimeters in length and 1.4 to 2 centimeters in diameter, imparting a dainty and intricate quality to the floral cluster. Notable features include an approximate arrangement of seven flowers per cluster, hanging from a long peduncle, adding to the overall grace of the flowering pattern. Additionally, the flowers are equipped with a 6 mm style, contributing to their reproductive attributes. This combination of floral characteristics, from coloration to arrangement and reproductive features, contributes to the overall botanical identity of this tree, making it a unique and identifiable presence in its ecological niche.'
          },
          'leaf': {
            'path': 'assets/images/28leaf.png',
            'name': '',
            'description': 'The leaves of this tree exhibit a simple and opposite arrangement, featuring elliptic blades with smooth and entire margins. The apex of the leaves is apiculate, adding a subtle pointed feature, while the base is acute, contributing to the overall symmetry of the foliage. These leaves display a waxy texture on the upper surface, presenting a light green hue, while the undersurface is smooth and exhibits a yellow-green coloration. Notably, the leaves are characterized by a distinctive upward orientation, with the sides gently curling, enhancing their overall visual appeal. The size of the leaves ranges from 8 to 14 centimeters in length and 3 to 7 centimeters in width, creating a proportionate and well-balanced aspect within the trees canopy. Light green stipules further complement the overall aesthetic of the foliage. This combination of features contributes to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': '',
            'name': '',
            'description': ''
          },
        },
        {
          'path': 'assets/images/29tree.png',
          'name': 'Sonneratiaceae',
          'local_name': 'pagatpat',
          'scientific_name': 'Sonneratia alba',
          'description': 'Pioneering species of medium to large trees that co-occur with A. marina in fringing mangroves, but are dominant in more coralline-sandy substrates. Leaves are obovate to rounded, but those of seedlings and lowermost branches ~1 m aboveground are more elongated (see opposite, bottom left photo). The short-lived white flowers open at dusk and drop at dawn - standing in a Sonneratia alba grove as numerous white filaments fall from the canopy with the early morning breeze is a magical experience. This species hosts colonies of fireflies - a northern Agusan settlement was called Masawa (now Masao), meaning bright, from the insects sparkling lights that greeted seafarers on moonless nights. Likewise, the Spanish name of Siquijor Is. was Isla del Fuego, referring to the pagatpat-lined shore seemingly on fire. Past uses include housing construction materials, furnishing, and musical instruments. Due to salt content, woodwork required copper nails and screws.',
          'summary': '',
          'root': {
            'path': 'assets/images/29root.png',
            'name': '',
            'description': 'This tree presents a remarkable form, taking the shape of a substantial and towering specimen with a height ranging from 5 to 20 meters. The diameter at breast height (DBH) spans an impressive 20 to 120 centimeters, highlighting the robust nature of this species. The bark of the tree is characterized by a rough texture, exhibiting a brown coloration. It further showcases a distinctive pattern with fissures and flaky sections, contributing to the trees visual appeal. Notably, this tree features aerial roots in the form of conical, corky pneumatophores. These specialized structures play a crucial role in aiding in oxygen exchange and stabilizing the tree in waterlogged or swampy environments. The combination of these features, from the towering height to the distinctive bark and unique aerial roots, underscores the adaptability and resilience of this tree, making it a notable and distinctive presence within its botanical context.'
          },
          'flower': {
            'path': 'assets/images/29flower.png',
            'name': '',
            'description': 'The flowers of this plant are arranged in cymes, forming a terminal inflorescence that adds a graceful touch to its overall appearance. The petals, numbering between 4 and 6, are delicate and white, contributing to the flowers subtle elegance. The sepals, ranging from 4 to 7, are fused and display a green coloration, providing a complementary backdrop to the petals. The reproductive structure is characterized by an impressive assembly of over 300 white filaments forming the stamens, each measuring 3 to 5 centimeters in length. The overall size of the flower ranges from 5 to 7 centimeters in length and 6 to 9 centimeters in diameter, creating a captivating bloom. Noteworthy features include a long 5-6 cm style, extending gracefully from the center of the flower and adding to its overall aesthetic. The combination of these floral characteristics, from petal arrangement to the abundance of stamens and the lengthy style, contributes to the unique and striking nature of this plant within its botanical context.'
          },
          'leaf': {
            'path': 'assets/images/29leaf.png',
            'name': '',
            'description': 'The leaves of this plant exhibit a simple and opposite arrangement, with obovate to rounded blade shapes, creating a distinctive and symmetrical appearance. The margins are smooth and entire, with a rounded apex and base, contributing to the overall rounded contour of the foliage. The upper surface of the leaves is characterized by a smooth, dark green texture, while the undersurface is smooth and displays a contrasting light green hue. These leaves range in size from 6 to 12 centimeters in length and 3 to 11 centimeters in width, providing a compact and well-proportioned aspect to the plants overall structure. Notably, the leaves are leathery, succulent, and brittle, adding unique textural qualities to the plant. This combination of features, from the leaf arrangement to texture and size, contributes to the distinctive and identifiable nature of this plant within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/29fruit.png',
            'name': '',
            'description': 'The fruits of this plant are characterized by their rounded shape, presenting a visually appealing aspect. Their dark green color adds to the allure, creating a striking contrast against the backdrop of the foliage. The texture of the fruits is smooth, providing a tactile quality to their appearance. Measuring between 3 to 4 centimeters in height and 3 to 5 centimeters in diameter, these fruits are of moderate size, contributing to the overall balance of the plants reproductive structures. Notably, the fruits contain numerous V- and U-shaped seeds, as highlighted in the inset, showcasing an intriguing and distinctive pattern within. This combination of features, from shape and color to seed arrangement, adds to the plants overall botanical identity and reinforces its unique presence within its ecological niche.'
          },
        },
        {
          'path': 'assets/images/30tree.png',
          'name': 'Sonneratiaceae',
          'local_name': 'pedada, kalong-kalong',
          'scientific_name': 'Sonneratia caseolaris',
          'description': 'Prominent trees on the muddy substrate of low salinity upstream riverbanks; closely associated with N. fruticans. Sonneratia caseolaris can be distinguished from S. alba(with which it forms hybrids) by bigger pneumatophores that reach 1 m long when mature, bright red flowers, and elongated leaves with reddish petioles. Like S. alba,fireflies are also found on S. caseolaris. Heavy fruits cause the drooping branches to bend some more (see opposite, bottom left photo). Pneumatophores are used as floats for fishing nets and as corks (hence the vernacular term duol). Branches are used as firewood, the leaves as forage for goats and cows, and the bark yields tannin. The slightly acidic fruit is eaten raw or added to soups for souring, or made into vinegar. In the past, the sap was applied to the skin as cosmetic; other uses, e.g., firewood and forage, are similar to S. alba.',
          'summary': '',
          'root': {
            'path': 'assets/images/30root.png',
            'name': '',
            'description': 'This tree presents a commanding form, adopting the characteristic shape of a tree with a height ranging from 6 to 20 meters. The diameter at breast height (DBH) measures between 15 and 50 centimeters, indicating a substantial and mature specimen. The bark of the tree contributes to its visual appeal, featuring a rough texture that varies from light to dark brown. As the tree ages, the bark develops a cracked pattern, adding a weathered and distinctive aesthetic. In its youth, the bark is lenticellate, showcasing small, corky pores. A notable feature of this tree is the presence of aerial roots, specifically pneumatophores, which are long, slender, and pointed like a spear. These specialized roots play a vital role in aiding in oxygen exchange in waterlogged or swampy environments. The combination of these features, from bark characteristics to the unique aerial roots, underscores the adaptability and resilience of this tree, making it a notable and distinctive presence within its botanical context.'
          },
          'flower': {
            'path': 'assets/images/30flower.png',
            'name': '',
            'description': 'The flowers of this tree form an exquisite display with a cyme inflorescence emerging from terminal positions on the branches. Each flower is adorned with 4-6 thin, red petals, creating a vibrant and visually striking appearance. The sepals, ranging from 4-7 lobed, exhibit a green hue, providing a complementary backdrop to the red petals. The reproductive structure is particularly notable, with numerous stamens, exceeding 300 filaments, contributing to the overall opulence of the blooms. The size of these flowers ranges from 6 to 9 centimeters in length and 5 to 9 centimeters in diameter, creating a substantial and captivating floral cluster. Adding to their intricate beauty, the filaments feature a distinctive coloration with a red base and white tips. This combination of floral characteristics, from petal color to stamen arrangement, enhances the unique and identifiable nature of this tree within its botanical context.'
          },
          'leaf': {
            'path': 'assets/images/30leaf.png',
            'name': '',
            'description': 'The leaves of this tree exhibit a simple and opposite arrangement, featuring elliptic blades with entire and smooth margins. The leaves are characterized by an acute apex and base, contributing to their overall pointed and symmetrical appearance. The upper and undersurfaces of the leaves are smooth, displaying a uniform light green coloration. Measuring 6 to 12 centimeters in length and 3 to 7 centimeters in width, these leaves are relatively small, creating a proportionate aspect within the trees canopy. Notably, the leaves are thin, and the petiole base is reddish, adding a touch of color contrast. Another distinctive feature is the drooping nature of the leaf twigs, contributing to the overall aesthetics of the tree. This combination of characteristics, from the leaf arrangement to coloration and twig morphology, contributes to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/30fruit.png',
            'name': '',
            'description': 'The fruits of this tree exhibit a rounded shape, presenting a visually pleasing aspect to the observer. Their light green color adds to their overall freshness, creating an appealing contrast with the foliage. The texture of the fruits is smooth and shiny, providing a tactile quality to their appearance. Ranging in size from 2.8 to 4 centimeters in height and 4 to 8 centimeters in diameter, these fruits contribute to the balanced aesthetic of the trees reproductive structures. Notably, when ripe, these fruits emit a distinctive sour-sweet smell, enhancing their sensory appeal. Examining the fruits reveals numerous seeds, which are smaller than those of the Salix alba, as highlighted in the inset, underscoring the unique botanical characteristics of this tree. This combination of features, from shape and color to scent and seed size, adds to the overall botanical identity and contributes to the distinctive nature of this tree within its ecological context.'
          },
        },
        {
          'path': 'assets/images/31tree.png',
          'name': 'Sonneratiaceae',
          'local_name': 'pedada',
          'scientific_name': 'Sonneratia ovata',
          'description': 'Shorter trees that grow on firm mud in almost freshwater habitats located considerable distances from the shore; closely associated with N. fruticans. Areas may have access to seawater through seepage during months of higher tide. The white flowers of Sonneratia ovata are similar to those of S. alba, but the filaments fall from the tree earlier in the morning before sunrise. Leaves are bigger and more rounded, and fruits are much larger than those of S. alba and 5. caseolaris. Because their delicious sweetsour taste is much appreciated by children and local folk, fruits are plucked from trees as soon as they mature, as in Pan-ay, Capiz (see opposite page, bottom left photo). Other differentiating characters are listed in Table 7.',
          'summary': '',
          'root': {
            'path': 'assets/images/31root.png',
            'name': '',
            'description': 'This tree assumes an appealing form, presenting itself as a well-proportioned specimen with a tree shape and a height ranging from 5 to 10 meters. The diameter at breast height (DBH) measures between 15 and 30 centimeters, indicative of a mature and substantial presence. The bark of the tree is characterized by a rough texture, displaying earthy brown tones that add to its natural aesthetics. Notably, this tree features conical pneumatophores as aerial roots. These specialized structures serve the dual purpose of aiding in oxygen exchange and providing stability, particularly in waterlogged or swampy environments. The conical shape of the pneumatophores adds a unique visual element to the trees overall form, contributing to its adaptability and resilience in specific ecological niches. The combination of these features underscores the unique nature of this tree within its botanical context, showcasing its distinctive form and adaptations.'
          },
          'flower': {
            'path': 'assets/images/31flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in terminal cymes, contributing to an elegant and captivating display. Each flower features thin white petals, creating a delicate and refined appearance. The sepals, on the other hand, are robust and characterized by 5-6 lobes, exhibiting a thick and rough texture. The reproductive structure is adorned with numerous filaments forming the stamens, exceeding 300 in number and presenting a white coloration. The overall size of these blossoms ranges from 6 to 8 centimeters in length, creating a substantial and visually striking floral cluster. The combination of these floral features, from petal color to sepal texture and stamen abundance, adds to the unique and identifiable nature of this tree within its botanical context.'
          },
          'leaf': {
            'path': 'assets/images/31leaf.png',
            'name': '',
            'description': 'The leaves of this tree contribute to its distinctive appearance with a simple and opposite arrangement. These leaves are characterized by a round to ovate blade shape, providing a pleasing symmetry. The margins are entire and smooth, creating a uniform and sleek edge. The apex and base are both rounded, further enhancing the overall soft and rounded contour of the foliage. The upper surface of the leaves is smooth and showcases a dark green hue, while the undersurface maintains a smooth texture with a slightly lighter green coloration. Measuring 6 to 11 centimeters in length and 5 to 9 centimeters in width, these leaves are of moderate size, adding to the well-balanced aspect of the trees canopy. A distinctive touch is the reddish base of the petiole, which adds a subtle splash of color to the overall composition. This combination of features contributes to the unique and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/31fruit.png',
            'name': '',
            'description': 'The fruits of this tree present a distinctive rounded shape, creating an aesthetically pleasing appearance. Their dark green color adds to their visual allure, providing a rich contrast against the foliage. The texture of the fruits is smooth, contributing to a tactile quality. Ranging in size from 3 to 9 centimeters in height and 5 to 9 centimeters in diameter, these fleshy fruits are of moderate dimensions. When ripe, they emit a sour-sweet smell, enhancing their sensory appeal. Notably, the seeds within these fruits are irregular granules, larger than those of the Salix caseolaris, as depicted in the inset, emphasizing the unique botanical characteristics of this tree. This combination of features, from shape and color to scent and seed size, adds to the overall botanical identity and reinforces the distinctive nature of this tree within its ecological context.'
          },
        },
        {
          'path': 'assets/images/32tree.png',
          'name': 'Rubiaceae ',
          'local_name': 'bolaling, sagasa, hanbulali (Negros), nilad (Tag.)',
          'scientific_name': 'Scyphiphora hydrophyllacea',
          'description': 'Shrubs with multiple stems to trees up to 10 m tall, on firm mud near tidal creeks or sandy mud near river mouths; tolerate high salinity. The small pinkish-white flowers occur in dense clusters; fruits are deeply grooved and turn brown when ripe. Leaves have a distinct glossy or varnished appearance. Young stems and petioles are reddish and succulent like the leaves, which have been successfully tested as forage for goats and other livestock. Like other mangroves, the branches provide homes for birds (see opposite page, bottom left photo). Scyphiphora hydrophyllacea grows in monospecific stands – it was so abundant along Manila Bay and the Pasig River in pre-Hispanic times that the natives called the place “Maynilad” referring to the presence of nilad, its local name.',
          'summary': '',
          'root': {
            'path': 'assets/images/32root.png',
            'name': '',
            'description': 'This versatile plant showcases a variable form, appearing as both a shrub and a tree, with a height range spanning from 2 to 10 meters. The diameter at breast height (DBH) measures between 5 and 20 centimeters, reflecting the adaptable nature of this species. The bark of this plant is characterized by a smooth texture, displaying a light brown coloration that contributes to its overall aesthetic. Notably, the plant features surface aerial roots, which play a role in providing additional support and stability, particularly in environments where structural reinforcement is crucial. This combination of features, from the dual shrub and tree form to the smooth bark and surface aerial roots, underscores the adaptability and resilience of this plant, making it a notable and versatile presence within its botanical context.'
          },
          'flower': {
            'path': 'assets/images/32flower.png',
            'name': '',
            'description': 'The flowers of this plant are arranged in axillary cymes, creating a delicate and clustered inflorescence. Each flower features four whitish-pink petals, contributing to a subtle and graceful appearance. The sepals, numbering four, are fused, providing a cohesive backdrop to the petals. The stamens, four in number and brown in color, add a contrasting element to the floral ensemble. These petite flowers measure between 0.6 to 1.5 centimeters in length and 0.6 to 0.8 centimeters in diameter, creating a charming and modest bloom. Notably, the plant exhibits a social aspect with 15 to 20 flowers per cluster, forming a visually appealing arrangement. This combination of floral characteristics, from coloration to arrangement and cluster size, adds to the overall botanical identity of this plant, making it a unique and identifiable presence within its ecological niche'
          },
          'leaf': {
            'path': 'assets/images/32leaf.png',
            'name': '',
            'description': 'The leaves of this plant exhibit a unique arrangement, appearing as simple, opposite, and decussate. The obovate-shaped blades feature entire, smooth margins, presenting a symmetrical and well-defined outline. The apex is rounded, while the base is acute, contributing to the overall balanced appearance of the foliage. The upper surface of the leaves has a waxy texture and showcases a rich, dark green color, creating a lustrous sheen. Conversely, the undersurface is also waxy but displays a contrasting light green hue. Measuring 7 centimeters in length and 4 centimeters in width, with a range from 5 to 10 centimeters and 3 to 6 centimeters, respectively, these leaves are of moderate size. Notably, the leaves are succulent in nature, pointing upward, and feature a reddish petiole and stems, adding a touch of color contrast to the overall composition. This combination of characteristics contributes to the distinctive and identifiable nature of this plant within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/32fruit.png',
            'name': '',
            'description': 'The fruits of this plant are distinctive in their barrel-like shape, featuring longitudinal ridges that add to their unique visual appeal. Initially light green, these fruits transition to a brown hue as they mature, creating a nuanced color spectrum. The texture of the fruits is smooth, providing a tactile quality to their appearance. Measuring between 0.7 to 0.9 centimeters in length and 0.3 to 0.7 centimeters in diameter, these diminutive fruits contribute to the overall compact and proportionate nature of the plants reproductive structures. The barrel-like form and distinctive coloration, coupled with the smooth texture, make these fruits easily identifiable within the plants botanical context.'
          },
        },
         {
          'path': 'assets/images/33tree.png',
          'name': 'Meliaceae',
          'local_name': 'tabigi, tambigi',
          'scientific_name': 'Xylocarpus granatum',
          'description': 'Medium trees up to 17 m tall, found along estuarine rivers and tidal creeks, whose low buttresses extend as distinctive, snakelike plank roots. Xylocarpus granatum is also found in higher intertidal, inner mangroves as part of a mixed community that includes, among others X. moluccensis, C. decandra, and B. cylindrica. It has compound leaves which are shed in some trees, and big brown globose fruits with 10-12 irregularly shaped seeds. The smooth, light brown to greenish outer bark flakes off (see opposite, bottom left photo); the inner bark is red and a source of dye for tanning. Oil from seeds is used for lamps and for grooming hair, the fruits and seeds are used to treat diarrhea, and a bark decoction for cholera. Described as the best and most beautiful cabinet wood, its fine, glossy texture is suitable for furniture. It was also used for poles, railroad ties, posts and beams',
          'summary': '',
          'root': {
            'path': 'assets/images/33root.png',
            'name': '',
            'description': 'This tree exhibits a diverse and adaptable form, presenting itself as a tree with a height ranging from 3 to 17 meters. The diameter at breast height (DBH) measures between 10 and 70 centimeters, reflecting the considerable range of sizes within this species. The bark of the tree is characterized by a smooth texture, displaying a light brown coloration and featuring thin flakes that add to its aesthetic appeal. A notable feature of this tree is the presence of low buttresses, which may manifest in a plank or ribbon-like form. These aerial roots not only contribute to the structural support of the tree but also enhance its adaptability to different environmental conditions. The combination of height variation, bark characteristics, and the presence of low buttress aerial roots underscores the resilience and versatility of this tree, making it a distinctive and notable presence within its botanical context.'
          },
          'flower': {
            'path': 'assets/images/33flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in a panicle inflorescence, primarily axillary with a few terminal clusters. Each flower presents four white petals that contribute to an elegant and simplistic appearance. The calyx is distinctly lobed, exhibiting a yellowish-green coloration. The stamen structure is tubular, adding to the floral intricacy. The size of these unisexual flowers ranges from 1.1 to 1.2 centimeters in length and 1.1 to 1.4 centimeters in diameter, creating modest yet visually appealing blooms. The unisexual nature of the flowers adds an additional layer of botanical interest to the reproductive characteristics of this tree. This combination of floral features, from petal color to inflorescence type and sexual differentiation, contributes to the overall botanical identity of this tree, making it a unique and identifiable presence within its ecological context.'
          },
          'leaf': {
            'path': 'assets/images/33leaf.png',
            'name': '',
            'description': 'The leaves of this tree display a paripinnate compound arrangement, forming opposite pairs along the branches. Each leaflet has an obovate shape, contributing to the overall symmetry of the foliage. The margins are entire and smooth, creating a well-defined outline, while the apex varies from round to emarginate, and the base is acute. The upper surface of the leaves is smooth and boasts a rich, dark green color, while the undersurface maintains a smooth texture with a contrasting light green hue. The leaves measure 12 centimeters in length and 6 centimeters in width, with variations from 7 to 19 centimeters and 4 to 9 centimeters, respectively. Notably, the leaves are composed of 2-3 pairs of leaflets, and in some instances, they are deciduous, adding a dynamic aspect to the trees foliage. This combination of features contributes to the distinctive and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/33fruit.png',
            'name': '',
            'description': 'The fruits of this tree possess a distinctive and intriguing appearance, resembling cannonballs or bowling balls in shape. Transitioning from green to brown as they mature, these fruits showcase a captivating transformation in coloration. The texture of the fruits ranges from smooth to slightly rough, adding a tactile dimension to their aesthetic. Measuring between 8 to 13 centimeters in height and 8 to 14 centimeters in diameter, these sizable fruits contribute to the overall visual impact of the trees reproductive structures. Within each fruit, 10-12 irregularly-shaped seeds are housed, adding to the unique and intricate nature of the fruit composition. This combination of features, from shape and color to texture and seed arrangement, adds to the overall botanical identity and reinforces the distinctive nature of this tree within its ecological context.'
          },
        },
         {
          'path': 'assets/images/34tree.png',
          'name': 'Meliaceae ',
          'local_name': 'piagao, lagutlot',
          'scientific_name': 'Xylocarpus moluccensis',
          'description': 'Smaller trees on the firm substrate of back mangroves rarely appearing along the edges of rivers or creeks; they are also identified as X. mekongensis. Their low-salinity habitats overlap with those of X. granatum, but X . moluccensis has smaller pointed leaves; dark, rough and fissured bark; peg- or cone-shaped pneumatophores; and smaller, dark green fruits. The species is deciduous - the leaves turn golden brown to red then drop (see opposite, bottom left photo); the new leaves appear together with the short-lived flowers. Seeds were used for insect bites, diarrhea and as astringent, the fruits for diarrhea, and the bark as astringent. Past uses of the wood were as poles, railroad ties, posts, beams and for interior finish, musical instruments and high grade furniture. The royal throne of the king of Malaysia is made of X . moluccensis wood because of its fine grain and deep dark color.',
          'summary': '',
          'root': {
            'path': 'assets/images/34root.png',
            'name': '',
            'description': 'This tree displays a distinctive form, presenting itself as a tree with a height ranging from 3 to 10 meters. The diameter at breast height (DBH) spans from 10 to 50 centimeters, indicative of a well-established specimen. The bark of the tree contributes to its visual appeal, characterized by a rough texture with a dark brown coloration and a fissured pattern, reflecting the aging and weathering of the tree. Notably, this tree features aerial roots, specifically cone or peg roots, which arise from cable roots. These specialized roots contribute to the trees stability and adaptability, providing additional support and nourishment. The presence of these unique aerial root structures adds an interesting and distinctive element to the overall form of the tree, underscoring its resilience and adaptability within its ecological niche.'
          },
          'flower': {
            'path': 'assets/images/34flower.png',
            'name': '',
            'description': 'The flowers of this tree are arranged in panicles, primarily in axillary clusters, forming a delicate and graceful inflorescence. Each flower exhibits four white petals that contribute to a simple and elegant appearance. The calyx is distinctly lobed, presenting a pale yellow-green coloration. The stamen structure is fused and white, adding to the overall floral intricacy. These unisexual flowers are relatively small, with dimensions ranging from 0.6 to 0.7 centimeters in length and 0.9 to 1.0 centimeters in diameter, creating modest yet visually appealing blooms. The unisexual nature of the flowers adds an interesting layer to the trees reproductive characteristics, highlighting its unique adaptation. This combination of floral features, from petal color to inflorescence type and sexual differentiation, contributes to the overall botanical identity of this tree, making it a distinctive and identifiable presence within its ecological context.'
          },
          'leaf': {
            'path': 'assets/images/34leaf.png',
            'name': '',
            'description': 'The leaves of this tree are arranged in a paripinnate compound fashion, forming opposite pairs along the branches. Each leaflet has an elliptical shape, contributing to the overall symmetry of the foliage. The margins are entire and smooth, creating a well-defined outline, while both the apex and base are acute. The upper surface of the leaves is smooth and displays a vibrant green color, while the undersurface is also smooth with a lighter green hue. Measuring 8 centimeters in length and 4 centimeters in width, with variations from 5 to 12 centimeters and 2.5 centimeters respectively, these leaves are of moderate size, adding to the overall balance of the trees canopy. Typically, the leaves are composed of 3-4 pairs of leaflets, and they exhibit deciduous characteristics, contributing to the seasonal dynamics of the tree. This combination of features contributes to the distinctive and identifiable nature of this tree within its botanical context.'
          },
          'fruit': {
            'path': 'assets/images/34fruit.png',
            'name': '',
            'description': 'The fruits of this tree bear a distinctive resemblance to small cannonballs, adding a unique and intriguing element to their appearance. These fruit structures, with a light green color, create a visually appealing contrast against the surrounding foliage. The texture of the fruits is notably smooth, with subtle variations that lend a slightly rough quality, enhancing the tactile experience. Measuring between 8 to 9 centimeters in height and 9 to 10 centimeters in diameter, these compact fruits contribute to the overall aesthetic balance of the trees reproductive structures. The combination of their cannonball-like shape, light green coloration, and varied texture adds to the botanical identity of this tree, reinforcing its distinct presence within its ecological context.'
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
          description: mangrove['flower']['description']
        );

        final newLeaf = LeafModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob: leafImageBytes, 
          imagePath: mangrove['leaf']['path'],
          name: mangrove['leaf']['name'],
          description: mangrove['leaf']['description']
        );

        final newFruit = FruitModel(
          mangroveId: newMangrooveId ?? 0,
          imageBlob:  fruitImageBytes, 
          imagePath: mangrove['fruit']['path'],
          name: mangrove['fruit']['name'],
          description: mangrove['fruit']['description']
        );

        final root_id = dbHelper.insertDBRootData(newRoot);
        final flower_id = dbHelper.insertDBFlowerData(newFlower);
        final leaf_id = dbHelper.insertDBLeafData(newLeaf);
        final fruit_id = dbHelper.insertDBFruitData(newFruit);
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
