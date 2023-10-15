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
import 'package:grovievision/service/mangroveDatabaseHelper.dart';

class ViewSpecies extends StatefulWidget {
  final int mangroveId; // Define the data type you want to pass

  ViewSpecies({required this.mangroveId}); // Constructor that accepts data

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
    MangrooveModel? mangroveResultData = await dbHelper.getOneMangroveData(mangroveId);
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

      print("========== rootData ===========");
      print(rootData);
    });
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangroove Info'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                // Image.asset(
                //   'assets/images/aegiceras.png',
                // ),
                Image.memory(
                  mangroveData?.imageBlob ?? Uint8List(0),
                  width: 300, // Set the width and height as needed
                  height: 300,
                ),
                SizedBox(height: 10),
                Text(
                  mangroveData?.scientific_name ?? 'No Scientific Name',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Local Names: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                          mangroveData?.local_name ?? 'No Scientific Name'
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Description: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(mangroveData?.description ?? 'No Description')
                    ),
                  ],
                ),
                
                
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                      children: [
                        Text(
                          "Leaves",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Name: ${leafData?.name}' ?? 'No Name'),
                        Expanded(child: Text( 'Description: ${leafData?.description}' ?? 'No Description'))
                      ],
                    )),
                    Image.memory(
                      leafData?.imageBlob ?? Uint8List(0),
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "Fruit",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Name: ${fruitData?.name}' ?? 'No Name'),
                        Expanded(child: Text( 'Description: ${fruitData?.description}' ?? 'No Description'))
                      ],
                    )),
                    Image.memory(
                      fruitData?.imageBlob ?? Uint8List(0),
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "Flower",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Name: ${flowerData?.name}' ?? 'No Name'),
                        Expanded(child: Text( 'Description: ${flowerData?.description}' ?? 'No Description'))
                      ],
                    )),
                    Image.memory(
                      flowerData?.imageBlob ?? Uint8List(0),
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "Root",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Name: ${rootData?.name}' ?? 'No Name'),
                        Expanded(child: Text( 'Description: ${rootData?.description}' ?? 'No Description'))
                      ],
                    )),
                    Image.memory(
                      rootData?.imageBlob ?? Uint8List(0),
                      width: 80,
                      height: 80,
                    ),
                  ],
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
                    MaterialPageRoute(builder: (context) => AdminScreen()));
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
