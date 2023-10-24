// lib/main.dart
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

  SearchPage({required this.searchKey});

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
      print("======= initState ===========");
      dbHelper = MangroveDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    String searchKey = widget.searchKey;
    print("======= Result Start ===========");
    List<MangrooveModel> result = await dbHelper.getMangroveDataList();
    print(result.length);
    print("======= Result End ===========");

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
    String searchKey = widget.searchKey;

    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
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
            child: searchKey == 'TREE' 
            ? ListView.builder(
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
                  // leading: Image.memory(
                  //   imageData.imageBlob,
                  //   width: 60,
                  //   height: 60,
                  // ),
                )
                );
              },
            )
            : ListView.builder(
              itemCount: mangrooveData.length,
              itemBuilder: (context, index) {
                final imageData = mangrooveData[index];
                final mangroveId= mangrooveData[index].mangroveId;

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
                  title: Text('Name: ${imageData.name}'),
                  // leading: Image.memory(
                  //   imageData?.imageBlob,
                  //   width: 60,
                  //   height: 60,
                  // ),
                )
                );
              },
            )
          )
        ],
      ),
    ));
  }
}
