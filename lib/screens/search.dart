// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // This is for decoding the image

import 'package:flutter/material.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/view_species.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';

class SearchPage extends StatefulWidget {
  String searchKey;
  String pageType;

  SearchPage({required this.searchKey, required this.pageType});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  List<String> searchResults = [];

  late MangroveDatabaseHelper dbHelper;
  List<dynamic> mangrooveData = [];

  @override
  void initState() {
    super.initState();
      dbHelper = MangroveDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    String searchKey = widget.searchKey;
    List<MangrooveModel> result = await dbHelper.getMangroveDataList();

    List<FruitModel> fruits = await dbHelper.getFruitDataList();
    List<LeafModel> leaves = await dbHelper.getLeafDataList();
    List<RootModel> roots = await dbHelper.getRootDataList();
    List<FlowerModel> flowers = await  dbHelper.getFlowerDataList();
    
    
    setState(() {
      switch (searchKey) {
        case 'TREE':
            mangrooveData = result;
          break;
        case 'ROOT':
            mangrooveData = roots;
          break;
        case 'FRUIT':
            mangrooveData = fruits;
          break;
        case 'LEAF':
            mangrooveData = leaves;
          break;
        case 'FLOWER':
            mangrooveData = flowers;
          break;
        default:
          mangrooveData = result;
      }
    
    });
  }

  Future<Widget> loadImageFromFile(String filePath) async {
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return Image.asset(filePath, width: 60, height: 60);
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return Image.file(file, width: 60, height: 60,);
      }
    }

  // If no valid image is found, return a default placeholder
  return Image.asset("assets/images/default_placeholder.png", width: 60, height: 60,); // You can replace this with your placeholder image
}
  void search(String keyword) {
    // Create a new list to store the filtered data
    List<MangrooveModel> filteredData = [];

    // Iterate through the original data and add matching items to the filtered list
     if(keyword != '') {
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

     } else {
      fetchData();
     }

  }

  Future<void> _handleRefresh() async {
    // Simulate a refresh action (e.g., fetch new data from a server)
    fetchData();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    String searchKey = widget.searchKey;
    String pageType = widget.pageType;

    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              if(pageType == 'Admin') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminScreen()));
              } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              }
            },
          ),
          title: Text('Search Tree'), // Add your app title here
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
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
              child: searchKey == 'TREE' 
              ? ListView.builder(
                itemCount: mangrooveData.length,
                itemBuilder: (context, index) {
                  final imageData = mangrooveData[index];
                  final mangroveId= mangrooveData[index].id;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(mangroveId: mangroveId ?? 0, treePart: searchKey, pageType: pageType, isFromResult: false)));
                        final imageData = mangrooveData[index];
                        // final snackBar = SnackBar(
                        //   content: Text('Tapped on ${imageData}'),
                        // );
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(
                    title: Text('Name: ${imageData.name}'),
                    subtitle: Text('Local Name: ${imageData.local_name}'),
                    leading: FutureBuilder<Widget>(
                      future: loadImageFromFile(imageData.imagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? CircularProgressIndicator();
                        } else {
                          return CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                  )
                  );
                },
              )
              : ListView.builder(
                itemCount: mangrooveData.length,
                itemBuilder: (context, index) {
                  final imageDt = mangrooveData[index];
                  final mangId= mangrooveData[index].mangroveId;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(mangroveId: mangId ?? 0, treePart: searchKey, pageType: pageType, isFromResult: false)));
                        // final snackBar = SnackBar(
                        //   content: Text('Tapped on ${mangId}'),
                        // );
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(  
                    title: Text('Name: ${imageDt.name}'),
                    leading: FutureBuilder<Widget>(
                      future: loadImageFromFile(imageDt.imagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? CircularProgressIndicator();
                        } else {
                          return CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                  )
                  );
                },
              )
            )
          ],
        ),
      )
      
      
    ));
  }
}
