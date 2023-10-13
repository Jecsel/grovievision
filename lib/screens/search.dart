// lib/main.dart
import 'package:flutter/material.dart';
import 'package:grovievision/components/show_mangroove.dart';
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

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> mangrooveData = [];

  @override
  void initState() {
    super.initState();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbHelper.copyDatabase();
  }


  Future<void> fetchData() async {
    // final result = await dbHelper.fetchData();
    // print("============");
    // print res
    // setState(() {
    //   mangrooveData = result;
    // });
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
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ShowMangroove()));
                      // Define the action to be performed when the item is tapped.
                      // For example, you can navigate to a detailed view or show a dialog.
                      // In this example, we'll simply show a snackbar.
                      final imageData = searchResults[index];
                      final snackBar = SnackBar(
                        content: Text('Tapped on ${imageData}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(
                      title: Text(searchResults[index]),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mangrooveData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Mangrove: ${mangrooveData[index]}')
                  );
                },
              )
            )
          ],
        ),
      )
    );
  }
}
