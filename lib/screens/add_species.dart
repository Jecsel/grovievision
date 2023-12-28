// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/search.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/mangrove_images.dart';

class AddSpecies extends StatefulWidget {
  @override
  _AddSpeciesState createState() => _AddSpeciesState();
}

class _AddSpeciesState extends State<AddSpecies> {

  List<File>? mangroveFileImageArray;
  List<String> mangrovePathImageArray = [];
  List<File> tempMangroveFileImageArray = [];
  List<String> mangroveImagePathList = [];

  final picker = ImagePicker();
  File? mangroveImage;
  File? fruitImage;
  File? leafImage;
  File? flowerImage;
  File? rootImage;

  File? takenImage;

  String? mangroveImagePath = 'assets/images/default_placeholder.png';
  String? fruitImagePath = 'assets/images/default_placeholder.png';
  String? leafImagePath = 'assets/images/default_placeholder.png';
  String? flowerImagePath = 'assets/images/default_placeholder.png';
  String? rootImagePath = 'assets/images/default_placeholder.png';

  //For Main Tree
  TextEditingController nameController = TextEditingController();
  TextEditingController localNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //For Root
  TextEditingController rootNameInput = TextEditingController();
  TextEditingController rootDescInput = TextEditingController();
  //For Flower
  TextEditingController flowerNameInput = TextEditingController();
  TextEditingController flowerDescInput = TextEditingController(); 
  TextEditingController inflorescenceInput = TextEditingController();
  TextEditingController petalsInput = TextEditingController();
  TextEditingController sepalsInput = TextEditingController();
  TextEditingController stamenInput = TextEditingController();
  TextEditingController sizeFlowerInput = TextEditingController();
  //For Leaf
  TextEditingController leafNameInput = TextEditingController();
  TextEditingController leafDescInput = TextEditingController();
  TextEditingController arrangementInput = TextEditingController();
  TextEditingController bladeShapeInput = TextEditingController();
  TextEditingController marginInput = TextEditingController();
  TextEditingController apexInput = TextEditingController();
  TextEditingController baseInput = TextEditingController();
  TextEditingController upperSurfaceInput = TextEditingController();
  TextEditingController underSurfaceInput = TextEditingController();
  TextEditingController sizeleafInput = TextEditingController();
  //For fruit
  TextEditingController fruitNameInput = TextEditingController();
  TextEditingController fruitDescInput = TextEditingController();
  TextEditingController shapeInput = TextEditingController();
  TextEditingController colorInput = TextEditingController();
  TextEditingController textureInput = TextEditingController();
  TextEditingController sizefruitInput = TextEditingController();

  MangroveDatabaseHelper? dbHelper;
  List<MangrooveModel> mangroveDataList = [];
  List<FruitModel> fruitDataList = [];
  List<LeafModel> leafDataList = [];
  List<FlowerModel> flowerDataList = [];
  List<RootModel> rootDataList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = MangroveDatabaseHelper.instance;
  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    print('======== bytes ========');
    print(bytes);

    print('========  Uint8List.fromList(bytes) ========');
    print( Uint8List.fromList(bytes));
    return Uint8List.fromList(bytes);
  }

  Future<void> _insertMangrooveData() async {
    print('======== mangroveImage ========');
    print(mangroveImage);

    if(mangroveImage != null){
      print('======== mangroveImages is not null ========');

      final List<int> bytes = await mangroveImage!.readAsBytes();
      final List<int> rootBytes = await mangroveImage!.readAsBytes();
      final List<int> flowerBytes = await mangroveImage!.readAsBytes();
      final List<int> leafBytes = await mangroveImage!.readAsBytes();
      final List<int> fruitBytes = await mangroveImage!.readAsBytes();
      
      Uint8List.fromList(bytes);
      Uint8List.fromList(rootBytes);
      Uint8List.fromList(flowerBytes);
      Uint8List.fromList(leafBytes);
      Uint8List.fromList(fruitBytes);

      final newMangroove = MangrooveModel(
        imagePath: mangroveImagePath,
        name: nameController.text,
        local_name: localNameController.text,
        scientific_name: scientificNameController.text,
        description: descriptionController.text
      );
      
      final insertedMangrove = await dbHelper?.insertDBMangroveData(newMangroove);

      for (var treeImgPath in mangroveImagePathList) {
        final fav = MangroveImagesModel(
          mangroveId: insertedMangrove ?? 1,
          imagePath: treeImgPath
        );

        await dbHelper?.insertMangroveImages(fav);
      }

      final newRoot = RootModel(
        imagePath: rootImagePath,
        mangroveId: insertedMangrove ?? 0,
        name: '',
        description: rootDescInput.text,
      );

      final newFlower = FlowerModel(
        imagePath: flowerImagePath,
        mangroveId: insertedMangrove ?? 0,
        name: '',
        inflorescence: inflorescenceInput.text,
        petals: petalsInput.text,
        sepals: sepalsInput.text,
        stamen: stamenInput.text,
        size: sizeFlowerInput.text,
        description: flowerDescInput.text
      );

      final newLeaf = LeafModel(
        imagePath: leafImagePath,
        mangroveId: insertedMangrove ?? 0,
        name: '',
        description: leafDescInput.text,
        arrangement: arrangementInput.text,
        bladeShape: bladeShapeInput.text,
        margin: marginInput.text,
        apex: apexInput.text,
        base: baseInput.text,
        upperSurface: upperSurfaceInput.text,
        underSurface: underSurfaceInput.text,
        size: sizeleafInput.text
      );

      final newFruit = FruitModel(
        imagePath: fruitImagePath,
        mangroveId: insertedMangrove ?? 0,
        name: '',
        shape: shapeInput.text,
        color: colorInput.text,
        texture: textureInput.text,
        size: sizefruitInput.text,
        description: fruitDescInput.text,
      );

      final root_id = dbHelper?.insertDBRootData(newRoot);
      final flower_id = dbHelper?.insertDBFlowerData(newFlower);
      final leaf_id = dbHelper?.insertDBLeafData(newLeaf);
      final fruit_id = dbHelper?.insertDBFruitData(newFruit);
    }

    _gotoSearchList();
  }

  _gotoSearchList() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE', pageType: 'Admin')));
  }

  Future _getFromGallery(fromField) async {
    /// Get from gallery
    final pickedFileFromGallery = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFileFromGallery != null) {
      setState(() {
        switch (fromField) {
          case "mangrove":
            print('===******===== pickedFileFromGallery.path ===*****=====');
            print(pickedFileFromGallery.path);
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;


            mangroveFileImageArray?.add(mangroveImage!);
            mangrovePathImageArray.add(pickedFileFromGallery.path);

            mangroveImagePathList.add( pickedFileFromGallery.path);
            break;
          case "root":
            rootImage = File(pickedFileFromGallery.path);
            rootImagePath = pickedFileFromGallery.path;
            break;
          case "flower":
            flowerImage = File(pickedFileFromGallery.path);
            flowerImagePath = pickedFileFromGallery.path;
            break;
          case "leaf":
            leafImage = File(pickedFileFromGallery.path);
            leafImagePath = pickedFileFromGallery.path;
            break;
          case "fruit":
            fruitImage = File(pickedFileFromGallery.path);
            fruitImagePath = pickedFileFromGallery.path;
            break;
          default:
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;
        }
        
      });
    }
  }

  Future<void> removeImageInArray(int index) async {

    setState(() {
      tempMangroveFileImageArray.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mangroveImage != null) {
      tempMangroveFileImageArray.add(mangroveImage!);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Add your arrow icon here
              onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminScreen()));
              },
              
            ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Mangrove Tree",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150.0,
                      child: tempMangroveFileImageArray.isNotEmpty ? 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tempMangroveFileImageArray.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(tempMangroveFileImageArray[index],
                                    width: 150.0, // Adjust the width as needed
                                    height: 150.0, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        removeImageInArray(index);
                                      },
                                      child: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )

                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    ),
                    // mangroveImage != null
                    //     ? Image.file(
                    //         mangroveImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('mangrove');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Mangrove Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: scientificNameController,
                        decoration:
                            const InputDecoration(labelText: 'Scientific Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: localNameController,
                        decoration: const InputDecoration(labelText: 'Local Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Family Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    const Text(
                      "Root",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    rootImage != null
                        ? Image.file(
                            rootImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('root');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Root Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: rootNameInput,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: rootDescInput,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Flower",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    flowerImage != null
                        ? Image.file(
                            flowerImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('flower');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Flower Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: flowerNameInput,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: inflorescenceInput,
                        decoration: const InputDecoration(labelText: 'Inflorescence'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: petalsInput,
                        decoration: const InputDecoration(labelText: 'Petals'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: sepalsInput,
                        decoration: const InputDecoration(labelText: 'Sepals'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: stamenInput,
                        decoration: const InputDecoration(labelText: 'Stamen'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: sizeFlowerInput,
                        decoration: const InputDecoration(labelText: 'Size'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: flowerDescInput,
                        decoration: const InputDecoration(labelText: 'Others'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Leaf",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    leafImage != null
                        ? Image.file(
                            leafImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('leaf');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Leaf Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: leafNameInput,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: arrangementInput,
                        decoration: const InputDecoration(labelText: 'Arrangement'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: bladeShapeInput,
                        decoration: const InputDecoration(labelText: 'Blade Shape'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: marginInput,
                        decoration: const InputDecoration(labelText: 'Margin'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: apexInput,
                        decoration: const InputDecoration(labelText: 'Apex'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: baseInput,
                        decoration: const InputDecoration(labelText: 'Base'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: upperSurfaceInput,
                        decoration: const InputDecoration(labelText: 'Upper Surface'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: underSurfaceInput,
                        decoration: const InputDecoration(labelText: 'Under Surface'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: sizeleafInput,
                        decoration: const InputDecoration(labelText: 'Size'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: leafDescInput,
                        decoration: const InputDecoration(labelText: 'Others'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Fruit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    fruitImage != null
                        ? Image.file(
                            fruitImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('fruit');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Fruit Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: TextField(
                    //     controller: fruitNameInput,
                    //     decoration: InputDecoration(labelText: 'Name'),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: shapeInput,
                        decoration: const InputDecoration(labelText: 'Shape'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: colorInput,
                        decoration: const InputDecoration(labelText: 'Color'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: textureInput,
                        decoration: const InputDecoration(labelText: 'Texture'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: sizefruitInput,
                        decoration: const InputDecoration(labelText: 'Size'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: fruitDescInput,
                        decoration: const InputDecoration(labelText: 'Others'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _insertMangrooveData();
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              backgroundColor:  const Color.fromARGB(255, 2, 191, 5),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SUBMIT'),
                              Icon(Icons.upload)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
  }
