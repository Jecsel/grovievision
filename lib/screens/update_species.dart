// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grovievision/models/flower_model.dart';
import 'package:grovievision/models/fruit_model.dart';
import 'package:grovievision/models/leaf_model.dart';
import 'package:grovievision/models/mangroove_model.dart';
import 'package:grovievision/models/mangrove_images.dart';
import 'package:grovievision/models/root_model.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/search.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UpdateSpecies extends StatefulWidget {
  final int mangroveId; // Define the data type you want to pass

  UpdateSpecies({required this.mangroveId}); // Constructor that accepts data

  @override
  _UpdateSpeciesState createState() => _UpdateSpeciesState();
}

class _UpdateSpeciesState extends State<UpdateSpecies> {
  final picker = ImagePicker();

  List<File>? mangroveFileImageArray;
  List<String> mangrovePathImageArray = [];
  List<File> tempMangroveFileImageArray = [];
  List<String> mangroveImagePathList = [];
  List<MangroveImagesModel>? mangroveImgs = [];

  Uint8List? mangroveImg;
  Uint8List? fruitImg;
  Uint8List? leafImg;
  Uint8List? flowerImg;
  Uint8List? rootImg;
  Uint8List? takenImg;

  String? mangroveImagePath = 'assets/images/default_placeholder.png';
  String? fruitImagePath = 'assets/images/default_placeholder.png';
  String? leafImagePath = 'assets/images/default_placeholder.png';
  String? flowerImagePath = 'assets/images/default_placeholder.png';
  String? rootImagePath = 'assets/images/default_placeholder.png';

  File? mangroveImage;
  File? fruitImage;
  File? leafImage;
  File? flowerImage;
  File? rootImage;
  File? takenImage;

  MangrooveModel? mangroveData;
  RootModel? rootData;
  FlowerModel? flowerData;
  LeafModel? leafData;
  FruitModel? fruitData;

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

  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  List<MangrooveModel> mangroveDataList = [];
  List<FruitModel> fruitDataList = [];
  List<LeafModel> leafDataList = [];
  List<FlowerModel> flowerDataList = [];
  List<RootModel> rootDataList = [];

  @override
  void initState() {
    super.initState();
    // dbHelper = MangroveDatabaseHelper.instance;
    fetchData();
    
  }

  Future<void> fetchData() async{
    int mangroveId = widget.mangroveId;

    MangrooveModel? mangroveResultData = await dbHelper.getOneMangroveData(mangroveId);
    RootModel? rootResultData = await dbHelper.getOneRootData(mangroveId);
    FlowerModel? flowerResultData = await dbHelper.getOneFlowerData(mangroveId);
    LeafModel? leafResultData = await dbHelper.getOneLeafData(mangroveId);
    FruitModel? fruitResultData = await dbHelper.getOneFruitData(mangroveId);


    mangroveImgs = await dbHelper.getMangroveImages(mangroveId);

    for (var imgPaths in mangroveImgs!) {
      tempMangroveFileImageArray.add(File(imgPaths.imagePath));
    }
    
    setState(() {
      mangroveData = mangroveResultData;
      rootData = rootResultData;
      flowerData = flowerResultData;
      leafData = leafResultData;
      fruitData = fruitResultData;

      

      if (mangroveData!.imagePath!.startsWith('assets/')) {
        mangroveImagePath = mangroveData!.imagePath;
      }

      if (rootData!.imagePath!.startsWith('assets/')) {
        rootImagePath = rootData!.imagePath;
      }

      if (flowerData!.imagePath!.startsWith('assets/')) {
        flowerImagePath = flowerData!.imagePath;
      }

      if (leafData!.imagePath!.startsWith('assets/')) {
        leafImagePath = leafData!.imagePath;
      }

      if (fruitData!.imagePath!.startsWith('assets/')) {
        fruitImagePath = fruitData!.imagePath;
      }


      mangroveImg = mangroveResultData!.imageBlob;

      nameController.text = mangroveResultData!.name;
      localNameController.text = mangroveResultData!.local_name;
      scientificNameController.text = mangroveResultData!.scientific_name;
      descriptionController.text = mangroveResultData!.description;

      rootNameInput.text = '';
      rootDescInput.text = rootResultData!.description;

      flowerNameInput.text = '';
      flowerDescInput.text = flowerResultData!.description!;
      inflorescenceInput.text = flowerResultData.inflorescence ?? '';
      petalsInput.text = flowerResultData.petals ?? '';
      sepalsInput.text = flowerResultData.sepals ?? '';
      stamenInput.text = flowerResultData.stamen ?? '';
      sizeFlowerInput.text = flowerResultData.size ?? '';

      leafNameInput.text = '';
      leafDescInput.text = leafResultData!.description!;
      arrangementInput.text = leafResultData.arrangement ?? '';
      bladeShapeInput.text = leafResultData.bladeShape ?? '';
      marginInput.text = leafResultData.margin ?? '';
      apexInput.text = leafResultData.apex ?? '';
      baseInput.text = leafResultData.base ?? '';
      upperSurfaceInput.text = leafResultData.upperSurface ?? '';
      underSurfaceInput.text = leafResultData.underSurface ?? '';
      sizeleafInput.text = leafResultData.size ?? '';

      fruitNameInput.text = '';
      fruitDescInput.text = fruitResultData!.description!;
      shapeInput.text = fruitResultData.shape ?? '';
      colorInput.text = fruitResultData.color ?? '';
      textureInput.text = fruitResultData.texture ?? '';
      sizefruitInput.text = fruitResultData.size ?? '';

    });
  }

  Future<File> uint8ListToFile(Uint8List uint8list, String fileName) async {
    print('============fileName============ ${fileName}');
    print('============uint8list============ ${uint8list}');
    final tempDir = await getTemporaryDirectory();
    print('============tempDir============ ${tempDir}');
    final file = File('${tempDir.path}/$fileName');
    print('============file============ ${file}');
    
    await file.writeAsBytes(uint8list);
    print('============filewriteAsBytes============ ${file}');
    
    return file;
  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _insertMangrooveData() async {
    final Uint8List mangroveImageBytes = await fileToUint8List(mangroveImage!);
    final Uint8List rootImageBytes = await fileToUint8List(rootImage!);
    final Uint8List flowerImageBytes = await fileToUint8List(flowerImage!);
    final Uint8List leafImageBytes = await fileToUint8List(leafImage!);
    final Uint8List fruitImageBytes = await fileToUint8List(fruitImage!);

    final newMangroove = MangrooveModel(
      id: mangroveData?.id,
      imageBlob: mangroveImageBytes, 
      name: nameController.text,
      local_name: localNameController.text,
      scientific_name: scientificNameController.text,
      description: descriptionController.text
    );

    final insertedMangrove = await dbHelper.insertDBMangroveData(newMangroove);

      print('========insertedMangrove.id========');
      print(mangroveData?.id);
      final newRoot = RootModel(
        id: rootData?.id,
        mangroveId: mangroveData?.id ?? 0,
        imageBlob: rootImageBytes, 
        name: rootNameInput.text,
        description: rootDescInput.text,
      );

      final newFlower = FlowerModel(
        id: flowerData?.id,
        mangroveId: insertedMangrove ?? 0,
        imageBlob: flowerImageBytes, 
        name: flowerNameInput.text,
        description: flowerDescInput.text
      );

      final newLeaf = LeafModel(
        id: leafData?.id,
        mangroveId: insertedMangrove ?? 0,
        imageBlob: leafImageBytes, 
        name: leafNameInput.text,
        description: leafDescInput.text,
      );

      final newFruit = FruitModel(
        id: fruitData?.id,
        mangroveId: insertedMangrove ?? 0,
        imageBlob: fruitImageBytes, 
        name: fruitNameInput.text,
        description: fruitDescInput.text,
      );

      final root_id = dbHelper.insertDBRootData(newRoot);
      final flower_id = dbHelper.insertDBFlowerData(newFlower);
      final leaf_id = dbHelper.insertDBLeafData(newLeaf);
      final fruit_id = dbHelper.insertDBFruitData(newFruit);

    // setState(() {

    // });
  }

  Future<void> _updateMangrove() async {
    print('======== mangroveImage ========');
    print(mangroveImage);

    print('======== mangroveImagePath ========');
    print(mangroveImagePath);


    final newMangroove = MangrooveModel(
      id: mangroveData?.id,
      imagePath: mangroveImagePath,
      name: nameController.text,
      local_name: localNameController.text,
      scientific_name: scientificNameController.text,
      description: descriptionController.text
    );

    final insertedMangrove = await dbHelper?.updateMangroveData(newMangroove);

    final newRoot = RootModel(
      id: rootData?.id,
      imagePath: rootImagePath,
      mangroveId: mangroveData?.id ?? 1,
      name: '',
      description: rootDescInput.text,
    );

    final newFlower = FlowerModel(
      id: flowerData?.id,
      imagePath: flowerImagePath,
      mangroveId: mangroveData?.id ?? 1,
      name: '',
      inflorescence: inflorescenceInput.text,
      petals: petalsInput.text,
      sepals: sepalsInput.text,
      stamen: stamenInput.text,
      size: sizeFlowerInput.text,
      description: flowerDescInput.text
    );

    final newLeaf = LeafModel(
      id: leafData?.id,
      imagePath: leafImagePath,
      mangroveId: mangroveData?.id ?? 1,
      name: '',
      arrangement: arrangementInput.text,
      bladeShape: bladeShapeInput.text,
      margin: marginInput.text,
      apex: apexInput.text,
      base: baseInput.text,
      upperSurface: upperSurfaceInput.text,
      underSurface: underSurfaceInput.text,
      size: sizeleafInput.text,
      description: leafDescInput.text
    );

    final newFruit = FruitModel(
      id: fruitData?.id,
      imagePath: fruitImagePath,
      mangroveId: mangroveData?.id ?? 1,
      name: '',
      shape: shapeInput.text,
      color: colorInput.text,
      texture: textureInput.text,
      size: sizefruitInput.text,
      description: fruitDescInput.text
    );

    final root_id = dbHelper?.updateRootData(newRoot);
    final flower_id = dbHelper?.updateFlowerData(newFlower);
    final leaf_id = dbHelper?.updateLeafData(newLeaf);
    final fruit_id = dbHelper?.updateFruitData(newFruit);
  }


  Future<void> _fetchInsertedData() async {
    final data = await dbHelper.getMangroveDataList();
    setState(() {
      mangroveDataList = data.cast<MangrooveModel>();
    });
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
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;
            mangroveData?.imagePath =  mangroveImagePath;

            tempMangroveFileImageArray.add(mangroveImage!);
            

            final fav = MangroveImagesModel(
              mangroveId: mangroveImgs?[0].mangroveId ?? 1,
              imagePath: mangroveImagePath!
            );
            break;
          case "root":
            rootImage = File(pickedFileFromGallery.path);
            rootImagePath = pickedFileFromGallery.path;
            rootData?.imagePath =  rootImagePath;
            break;
          case "flower":
            flowerImage = File(pickedFileFromGallery.path);
            flowerImagePath = pickedFileFromGallery.path;
            flowerData?.imagePath = flowerImagePath;
            break;
          case "leaf":
            leafImage = File(pickedFileFromGallery.path);
            leafImagePath = pickedFileFromGallery.path;
            leafData?.imagePath = leafImagePath;
            break;
          case "fruit":
            fruitImage = File(pickedFileFromGallery.path);
            fruitImagePath = pickedFileFromGallery.path;
            fruitData?.imagePath = fruitImagePath;
            break;
          default:
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;
            mangroveData?.imagePath =  mangroveImagePath;
        }
        
      });
    }
  }

  Future<void> removeImageInArray(int index)  async {

    print(mangroveImgs?[index]);

    int tracerImgID = mangroveImgs?[index].id ?? 1;
    await dbHelper?.deleteOneImageFromMangrove(tracerImgID);

    setState(() {
      tempMangroveFileImageArray.removeAt(index);

      print('tempTracerFileImageArray');
      print(tempMangroveFileImageArray);

    });
  }

  @override
  Widget build(BuildContext context) {

    print('========mangroveData====================');
    print(mangroveData);
    
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
            title: const Text('Update Tree'), // Add your app title here
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
                      height: 250.0,
                      child: tempMangroveFileImageArray.length > 0 ? 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tempMangroveFileImageArray.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Stack(
                                children: [

                                  FutureBuilder<Widget>(
                                    future: loadImageFromFile(tempMangroveFileImageArray[index].path),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return snapshot.data ?? CircularProgressIndicator();
                                      } else {
                                        return CircularProgressIndicator(); // Or another loading indicator
                                      }
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        removeImageInArray(index);
                                      },
                                      child: Icon(
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

                      : mangroveData?.imagePath != null ? FutureBuilder<Widget>(
                        future: loadImageFromFile(mangroveData?.imagePath ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return snapshot.data ?? const CircularProgressIndicator();;
                          } else {
                            return const CircularProgressIndicator(); // Or another loading indicator
                          }
                        },
                      ) : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    ),

                    // FutureBuilder<Widget>(
                    //   future: loadImageFromFile(mangroveData?.imagePath ?? ''),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return snapshot.data ?? const CircularProgressIndicator();;
                    //     } else {
                    //       return const CircularProgressIndicator(); // Or another loading indicator
                    //     }
                    //   },
                    // ),
                    const SizedBox(height: 10),
                    Container(
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
                        decoration: const InputDecoration(labelText: 'Name'),
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
                    FutureBuilder<Widget>(
                      future: loadImageFromFile(rootData?.imagePath ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? const CircularProgressIndicator();;
                        } else {
                          return const CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                        decoration: const InputDecoration(labelText: 'Others'),
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
                    FutureBuilder<Widget>(
                      future: loadImageFromFile(flowerData?.imagePath ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? const CircularProgressIndicator();;
                        } else {
                          return const CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                    FutureBuilder<Widget>(
                      future: loadImageFromFile(leafData?.imagePath ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? const CircularProgressIndicator();;
                        } else {
                          return const CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                    FutureBuilder<Widget>(
                      future: loadImageFromFile(fruitData?.imagePath ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? const CircularProgressIndicator();;
                        } else {
                          return const CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _updateMangrove();
                            _gotoSearchList();
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
