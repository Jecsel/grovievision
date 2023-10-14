// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';

class AddSpecies extends StatefulWidget {
  @override
  _AddSpeciesState createState() => _AddSpeciesState();
}

class _AddSpeciesState extends State<AddSpecies> {
  final picker = ImagePicker();
  File? localImage;
  File? takenImage;

  //For Main Tree
  TextEditingController localNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //For Root
  TextEditingController rootNameInput = TextEditingController();
  TextEditingController rootDescInput = TextEditingController();
  TextEditingController rootImputInput = TextEditingController();
  //For Flower
  TextEditingController flowerNameInput = TextEditingController();
  TextEditingController flowerDescInput = TextEditingController();
  TextEditingController flowerImputInput = TextEditingController();
  //For Trunk
  TextEditingController trunkNameInput = TextEditingController();
  TextEditingController trunkDescInput = TextEditingController();
  TextEditingController trunkImputInput = TextEditingController();
  //For Leaf
  TextEditingController leafNameInput = TextEditingController();
  TextEditingController leafDescInput = TextEditingController();
  TextEditingController leafImputInput = TextEditingController();
  //For fruit
  TextEditingController fruitNameInput = TextEditingController();
  TextEditingController fruitDescInput = TextEditingController();
  TextEditingController fruitImputInput = TextEditingController();

  late MangroveDatabaseHelper dbHelper;
  List<MangrooveModel> insertedDataList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = MangroveDatabaseHelper.instance;
  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _insertImage() async {
    // final ByteData assetData = await rootBundle.load('assets/images/splash_logo.png');
    final Uint8List imageBytes = await fileToUint8List(localImage!);

    final newMangroove = MangrooveModel(
      imageBlob: imageBytes, 
      local_name: localNameController.text,
      scientific_name: scientificNameController.text,
      description: descriptionController.text,
    );

    final id = await dbHelper.insertImageData(newMangroove);
    print("=================== ${id}");
    // final mangrooveModel = newMangroove.copy(id: id);

    setState(() {
      // insertedDataList.add(MangrooveModel);
    });
  }

  Future<void> _fetchInsertedData() async {
    final data = await dbHelper.getImageDataList();
    setState(() {
      insertedDataList = data.cast<MangrooveModel>();
    });
  }

  Future _getFromGallery() async {
    /// Get from gallery
    final pickedFileFromGallery = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print('pickFile');
    print(pickedFileFromGallery);

    if (pickedFileFromGallery != null) {
      setState(() {
        localImage = File(pickedFileFromGallery.path);
      });
    }
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
                MaterialPageRoute(builder: (context) => AdminScreen()));
              },
            ),
            title: Text('Search Tree'), // Add your app title here
        ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Mangrove Tree",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    localImage != null
                        ? Image.file(
                            localImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery();
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Mangrove Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: localNameController,
                        decoration: InputDecoration(labelText: 'Local Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: scientificNameController,
                        decoration:
                            InputDecoration(labelText: 'Scientific Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Fetch Inserted Data"),
                      onPressed:() => _insertImage(),
                    ),
                    // Text(
                    //   "Mangrove Fruit",
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // localImage != null
                    //     ? Image.file(
                    //         localImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    // SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         _getFromGallery();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           textStyle: TextStyle(fontSize: 20),
                    //           minimumSize: Size(double.infinity, 60)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Upload Mangrove Image'),
                    //           Icon(Icons.add)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: localNameController,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: scientificNameController,
                    //     decoration: InputDecoration(labelText: 'Description'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: descriptionController,
                    //     decoration: InputDecoration(labelText: 'Image'),
                    //     maxLines: 4, // You can adjust the number of lines
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   "Mangrove Leaf",
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // localImage != null
                    //     ? Image.file(
                    //         localImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    // SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         _getFromGallery();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           textStyle: TextStyle(fontSize: 20),
                    //           minimumSize: Size(double.infinity, 60)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Upload Mangrove Image'),
                    //           Icon(Icons.add)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: localNameController,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: scientificNameController,
                    //     decoration: InputDecoration(labelText: 'Description'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: descriptionController,
                    //     decoration: InputDecoration(labelText: 'Image'),
                    //     maxLines: 4, // You can adjust the number of lines
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   "Mangrove Trunk",
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // localImage != null
                    //     ? Image.file(
                    //         localImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    // SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         _getFromGallery();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           textStyle: TextStyle(fontSize: 20),
                    //           minimumSize: Size(double.infinity, 60)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Upload Mangrove Image'),
                    //           Icon(Icons.add)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: localNameController,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: scientificNameController,
                    //     decoration: InputDecoration(labelText: 'Description'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: descriptionController,
                    //     decoration: InputDecoration(labelText: 'Image'),
                    //     maxLines: 4, // You can adjust the number of lines
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   "Mangrove Flower",
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // localImage != null
                    //     ? Image.file(
                    //         localImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    // SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         _getFromGallery();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           textStyle: TextStyle(fontSize: 20),
                    //           minimumSize: Size(double.infinity, 60)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Upload Mangrove Image'),
                    //           Icon(Icons.add)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: localNameController,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: scientificNameController,
                    //     decoration: InputDecoration(labelText: 'Description'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: descriptionController,
                    //     decoration: InputDecoration(labelText: 'Image'),
                    //     maxLines: 4, // You can adjust the number of lines
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   "Mangrove Root",
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // localImage != null
                    //     ? Image.file(
                    //         localImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    // SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         _getFromGallery();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           textStyle: TextStyle(fontSize: 20),
                    //           minimumSize: Size(double.infinity, 60)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Upload Mangrove Image'),
                    //           Icon(Icons.add)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: localNameController,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: scientificNameController,
                    //     decoration: InputDecoration(labelText: 'Description'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: descriptionController,
                    //     decoration: InputDecoration(labelText: 'Image'),
                    //     maxLines: 4, // You can adjust the number of lines
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            )));
  }
}
