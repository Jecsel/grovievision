import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  Future<void> copyDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFile = join(dbPath, "mangrove.db");

    // Check if the database already exists in the desired location
    if (await File(dbFile).exists()) {
      return;
    }

    // Copy the database from assets to the desired location
    final ByteData data = await rootBundle.load("assets/database/mangrove.db");
    final List<int> bytes = data.buffer.asUint8List();
    await File(dbFile).writeAsBytes(bytes, flush: true);
  }

  Future<List<Map<String, dynamic>>?> fetchData() async {
  final dbPath = await getDatabasesPath();
  final database = await databaseFactoryFfi.openDatabase(join(dbPath, "mangrove.db"));

  final result = await database.query("Mangroove");
  return result;
}
}
