import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:grovievision/screens/about_us.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/mangroove.dart';
import 'package:grovievision/screens/search.dart';
import 'package:grovievision/screens/update_species.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:grovievision/ui/login.dart';

class ViewSpecies extends StatefulWidget {
  final int mangroveId; // Mangrove Id
  final String treePart; // What treePart of mangrove, if TREE, ROOT, ETC.
  final String pageType; //What type of User
  bool? isFromResult;

  ViewSpecies({required this.mangroveId, required this.treePart, required this.pageType, this.isFromResult}); // Constructor that accepts data

  @override
  State<StatefulWidget> createState() => _ViewSpeciesState();
}

class _ViewSpeciesState extends State<ViewSpecies> {
  int _selectedIndex = 0;
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  MangrooveModel? mangroveData;
  RootModel? rootData;
  FlowerModel? flowerData;
  FruitModel? fruitData;
  LeafModel? leafData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    int mangroveId = widget.mangroveId;
    MangrooveModel? mangroveResultData =
        await dbHelper.getOneMangroveData(mangroveId);
    RootModel? rootResultData = await dbHelper.getOneRootData(mangroveId);
    FlowerModel? flowerResultData = await dbHelper.getOneFlowerData(mangroveId);
    LeafModel? leafResultData = await dbHelper.getOneLeafData(mangroveId);
    FruitModel? fruitResultData = await dbHelper.getOneFruitData(mangroveId);

    setState(() {
      mangroveData = mangroveResultData;
      rootData = rootResultData;
      fruitData = fruitResultData;
      leafData = leafResultData;
      flowerData = flowerResultData;

      print("========== mangroveData  ImagePath ===========");
      print(mangroveData?.imagePath);

      print("========== mangroveData  ImageBlob ===========");
      print(mangroveData?.imageBlob);

    });
  }

  Future<void> deleteMangroveData() async {
    int mangroveId = widget.mangroveId;
    await dbHelper.deleteFlowerData(mangroveId);
    await dbHelper.deleteFruitData(mangroveId);
    await dbHelper.deleteLeafData(mangroveId);
    await dbHelper.deleteRootData(mangroveId);
    await dbHelper.deleteMangroveData(mangroveId);
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _gotoSearchList() {
    String pageType = widget.pageType;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE', pageType: pageType ?? 'User')));
  }

  _gotoUpdateSpecies() {
    int mangroveId = widget.mangroveId;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UpdateSpecies(mangroveId: mangroveId)));
  }

    Future<Widget> loadImageFromFile(String filePath) async {
      if (filePath.startsWith('assets/')) {
        // If the path starts with 'assets/', load from assets
        return Image.asset(filePath);
      } else {
        final file = File(filePath);

        if (await file.exists()) {
          // If the file exists in local storage, load it
          return Image.file(file);
        }
      }

      // If no valid image is found, return a default placeholder
      return Image.asset("assets/images/default_placeholder.png"); // You can replace this with your placeholder image
    }

    Future<Widget> loadImage(String filePath) async {
      if (filePath.startsWith('assets/')) {
        // If the path starts with 'assets/', load from assets
        return Image.asset(filePath, width: 80, height: 80);
      } else {
        final file = File(filePath);

        if (await file.exists()) {
          // If the file exists in local storage, load it
          return Image.file(file, width: 80, height: 80);
        }
      }

      // If no valid image is found, return a default placeholder
      return Image.asset("assets/images/default_placeholder.png", width: 80, height: 80); // You can replace this with your placeholder image
    }

  Widget _buildDrawerItem({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageType = widget.pageType;
    var searchKey = widget.treePart;
    bool? isFromResult = widget.isFromResult;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangroove Info'),
        backgroundColor: Colors.green, // Set the background color here
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              if(isFromResult!) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage(pageType: pageType, searchKey: searchKey,)));
              }
            },
          ),
        actions: <Widget>[
          Visibility(
            visible: pageType == 'Admin',
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _gotoUpdateSpecies();
              },
            ),
          ),
          Visibility(
            visible: pageType == 'Admin',
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteMangroveData();
                _gotoSearchList();
                const snackBar = SnackBar(
                  content: Text('Mangrove Delete!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<Widget>(
                  future: loadImageFromFile(mangroveData?.imagePath ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const CircularProgressIndicator();;
                    } else {
                      return const CircularProgressIndicator(); // Or another loading indicator
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  mangroveData?.scientific_name ?? 'No Scientific Name',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Local Names: ",
                      style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        mangroveData?.local_name ?? 'No Local Name')),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Family Name: ",
                      style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        mangroveData?.name ?? 'No Family Name')),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Description: ",
                    style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan( text: mangroveData?.description ?? 'No Description')
                          ]
                        )
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),
                Visibility(
                  visible: leafData?.imagePath != null && leafData?.imagePath != '',
                    child: const Text(
                    "Leaves",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: leafData?.imagePath != null && leafData?.imagePath != '',
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(leafData?.description ?? 'No Description'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child:  FutureBuilder<Widget>(
                        future: loadImage(leafData?.imagePath ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data ?? const CircularProgressIndicator();;
                            } else {
                              return const CircularProgressIndicator(); // Or another loading indicator
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Visibility(
                  visible: fruitData?.imagePath != null && fruitData?.imagePath != '',
                    child: const Text(
                    "Fruit",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: fruitData?.imagePath != null && fruitData?.imagePath != '',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(fruitData?.description ?? 'No Description'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FutureBuilder<Widget>(
                          future: loadImage(fruitData?.imagePath ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data ?? const CircularProgressIndicator();;
                            } else {
                              return const CircularProgressIndicator(); // Or another loading indicator
                            }
                          },
                        ), 
                      ),
                      
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Visibility(
                  visible: flowerData?.imagePath != null && flowerData?.imagePath != '',
                    child: const Text(
                    "Flower",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: flowerData?.imagePath != null && flowerData?.imagePath != '',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                          child: Text(flowerData?.description ?? 'No Description'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FutureBuilder<Widget>(
                        future: loadImage(flowerData?.imagePath ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data ?? const CircularProgressIndicator();;
                            } else {
                              return const CircularProgressIndicator(); // Or another loading indicator
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Visibility(
                  visible: rootData?.imagePath != null && rootData?.imagePath != '',
                    child: const Text(
                    "Root",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: rootData?.imagePath != null && rootData?.imagePath != '',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(rootData?.description ?? 'No Description'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FutureBuilder<Widget>(
                        future: loadImage(rootData?.imagePath ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data ?? const CircularProgressIndicator();;
                            } else {
                              return const CircularProgressIndicator(); // Or another loading indicator
                            }
                          },
                        ),
                      ) 
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _gotoSearchList();
                  },
                  child: const Text("Summary"),
                ),
                
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Admin',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 2,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}