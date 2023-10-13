// lib/main.dart
import 'package:flutter/material.dart';
import 'package:grovievision/components/show_mangroove.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:grovievision/screens/update_image_screen.dart';
import 'package:grovievision/service/databaseHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  List<String> searchResults = [];

  late DatabaseHelper dbHelper;
  List<MangrooveData> mangrooveData = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    fetchData();
  }

  Future<void> fetchData() async {
    List<MangrooveData> result = await dbHelper.getImageDataList();
    setState(() {
      mangrooveData = result;
    });
  }

  void search(String keyword) {
    // Implement your search logic here.
    // For now, let's just filter a list of dummy data.
    List<String> dummyData = ["Apple", "Banana", "Cherry", "Date", "Grape"];
    setState(() {
      searchResults = dummyData
          .where((item) => item.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Search Tree"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                search(value);
              },
              decoration: InputDecoration(
                labelText: "Search Tree",
                prefixIcon: Icon(Icons.image_search_rounded),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateImageScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    minimumSize: Size(double.infinity, 60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Upload Mangrove Image'), Icon(Icons.add)],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mangrooveData.length,
              itemBuilder: (context, index) {
                final imageData = mangrooveData[index];

                return ListTile(
                  title: Text('Mangrove: ${imageData.name}'),
                  leading: Image.memory(
                    imageData.imageBlob,
                    width: 60,
                    height: 60,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
