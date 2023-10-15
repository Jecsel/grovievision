// lib/main.dart
import 'package:flutter/material.dart';
import 'package:grovievision/components/show_mangroove.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/update_image_screen.dart';
import 'package:grovievision/screens/view_species.dart';
import 'package:grovievision/service/databaseHelper.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
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

  late MangroveDatabaseHelper dbHelper;
  List<MangrooveModel> mangrooveData = [];

  @override
  void initState() {
    super.initState();
    dbHelper = MangroveDatabaseHelper.instance;
    fetchData();
  }

  Future<void> fetchData() async {
    List<MangrooveModel> result = await dbHelper.getMangroveDataList();
    setState(() {
      mangrooveData = result;
    });
  }

  void search(String keyword) {
    // Create a new list to store the filtered data
    List<MangrooveModel> filteredData = [];

    // Iterate through the original data and add matching items to the filtered list
    for (var item in mangrooveData) {
      if (item.local_name.toLowerCase().contains(keyword.toLowerCase()) ||
          item.scientific_name.toLowerCase().contains(keyword.toLowerCase())) {
        filteredData.add(item);
      }
    }

    setState(() {
      // Update the mangrooveData with the filtered data
      mangrooveData = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          title: Text('Search Tree'), // Add your app title here
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
          Expanded(
            child: ListView.builder(
              itemCount: mangrooveData.length,
              itemBuilder: (context, index) {
                final imageData = mangrooveData[index];
                final mangroveId= mangrooveData[index].id;

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(mangroveId: mangroveId ?? 0)));
                      final imageData = mangrooveData[index];
                      final snackBar = SnackBar(
                        content: Text('Tapped on ${imageData}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: ListTile(
                  title: Text('Local Name: ${imageData.local_name}'),
                  subtitle: Text('Scientific Name: ${imageData.scientific_name}' ),
                  leading: Image.memory(
                    imageData.imageBlob,
                    width: 60,
                    height: 60,
                  ),
                )
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
