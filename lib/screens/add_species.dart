// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
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
              title: Text("Add Species"),
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
