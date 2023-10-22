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
import 'package:path_provider/path_provider.dart';

class UpdateSpecies extends StatefulWidget {
  final int mangroveId; // Define the data type you want to pass

  UpdateSpecies({required this.mangroveId}); // Constructor that accepts data

  @override
  _UpdateSpeciesState createState() => _UpdateSpeciesState();
}

class _UpdateSpeciesState extends State<UpdateSpecies> {
  final picker = ImagePicker();

  Uint8List? mangroveImg;
  Uint8List? fruitImg;
  Uint8List? leafImg;
  Uint8List? flowerImg;
  Uint8List? rootImg;
  Uint8List? takenImg;

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
  TextEditingController localNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  //For Root
  TextEditingController rootNameInput = TextEditingController();
  TextEditingController rootDescInput = TextEditingController();
  //For Flower
  TextEditingController flowerNameInput = TextEditingController();
  TextEditingController flowerDescInput = TextEditingController(); 
  //For Leaf
  TextEditingController leafNameInput = TextEditingController();
  TextEditingController leafDescInput = TextEditingController();
  //For fruit
  TextEditingController fruitNameInput = TextEditingController();
  TextEditingController fruitDescInput = TextEditingController();

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

    // print('============mangroveImg============');

    // var mangroveImg = await uint8ListToFile(mangroveResultData!.imageBlob, 'mangroove.png');
    // var fruitImg = await uint8ListToFile(fruitResultData!.imageBlob, 'fruit');
    // var leafImg = await uint8ListToFile(leafResultData!.imageBlob, 'leaf');
    // var flowerImg = await uint8ListToFile(flowerResultData!.imageBlob, 'flowwer');
    // var rootImg = await uint8ListToFile(rootResultData!.imageBlob, 'root');

    // print('============mangroveImg============');
    // print(mangroveImg);

    setState(() {
      mangroveData = mangroveResultData;
      rootData = rootResultData;
      flowerData = flowerResultData;
      leafData = leafResultData;
      fruitData = fruitResultData;

      mangroveImg = mangroveResultData!.imageBlob;

      print('============mangroveResultData============');
      print(mangroveResultData?.imageBlob);

      // mangroveImage = mangroveImg;
      // fruitImage = fruitImg;
      // leafImage = leafImg;
      // flowerImage = flowerImg;
      // rootImage = rootImg;

      localNameController.text = mangroveResultData!.local_name;
      scientificNameController.text = mangroveResultData!.scientific_name;
      descriptionController.text = mangroveResultData!.description;
      summaryController.text = mangroveResultData!.summary;

      rootNameInput.text = rootResultData!.name;
      rootDescInput.text = rootResultData!.description;

      flowerNameInput.text = flowerResultData!.name;
      flowerDescInput.text = flowerResultData!.description;

      leafNameInput.text = leafResultData!.name;
      leafDescInput.text = leafResultData!.description;

      fruitNameInput.text = fruitResultData!.name;
      fruitDescInput.text = fruitResultData!.description;
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
      imageBlob: mangroveImageBytes, 
      local_name: localNameController.text,
      scientific_name: scientificNameController.text,
      description: descriptionController.text,
      summary: summaryController.text
    );

    final insertedMangrove = await dbHelper.insertDBMangroveData(newMangroove);

      print('========insertedMangrove.id========');
      print(insertedMangrove);
      final newRoot = RootModel(
        mangroveId: insertedMangrove ?? 0,
        imageBlob: rootImageBytes, 
        name: rootNameInput.text,
        description: rootDescInput.text,
      );

      final newFlower = FlowerModel(
        mangroveId: insertedMangrove ?? 0,
        imageBlob: flowerImageBytes, 
        name: flowerNameInput.text,
        description: flowerDescInput.text
      );

      final newLeaf = LeafModel(
        mangroveId: insertedMangrove ?? 0,
        imageBlob: leafImageBytes, 
        name: leafNameInput.text,
        description: leafDescInput.text,
      );

      final newFruit = FruitModel(
        mangroveId: insertedMangrove ?? 0,
        imageBlob: fruitImageBytes, 
        name: fruitNameInput.text,
        description: fruitDescInput.text,
      );

      final root_id = dbHelper.insertDBRootData(newRoot);
      final flower_id = dbHelper.insertDBFlowerData(newFlower);
      final leaf_id = dbHelper.insertDBLeafData(newLeaf);
      final fruit_id = dbHelper.insertDBFruitData(newFruit);

    setState(() {

    });
  }

  Future<void> _fetchInsertedData() async {
    final data = await dbHelper.getMangroveDataList();
    setState(() {
      mangroveDataList = data.cast<MangrooveModel>();
    });
  }

  _gotoSearchList() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE')));
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
            break;
          case "root":
            rootImage = File(pickedFileFromGallery.path);
            break;
          case "flower":
            flowerImage = File(pickedFileFromGallery.path);
            break;
          case "leaf":
            leafImage = File(pickedFileFromGallery.path);
            break;
          case "fruit":
            fruitImage = File(pickedFileFromGallery.path);
            break;
          default:
            mangroveImage = File(pickedFileFromGallery.path);
        }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    print('========mangroveData====================');
    print(mangroveData);
    
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    _insertMangrooveData();
                    _gotoSearchList();
                    final snackBar = SnackBar(
                              content: Text('Mangrove Saved!'),
                      );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Mangrove Tree",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    mangroveImage != null
                      ? Image.file(
                        mangroveImage!,
                        height: 150,
                      )
                      : mangroveData?.imageBlob != null
                      ? Image.memory(
                        mangroveData?.imageBlob ?? Uint8List(0),
                        width: 150,
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
                            _getFromGallery('mangrove');
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
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: summaryController,
                        decoration: InputDecoration(labelText: 'Summary'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    Text(
                      "Root",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
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
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('root');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Root Image'),
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
                        controller: rootNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: rootDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Flower",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
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
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('flower');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Flower Image'),
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
                        controller: flowerNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: flowerDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Leaf",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
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
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('leaf');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Leaf Image'),
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
                        controller: leafNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: leafDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Fruit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
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
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('fruit');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Fruit Image'),
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
                        controller: fruitNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: fruitDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _insertMangrooveData();
                            _gotoSearchList();
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              backgroundColor:  Color.fromARGB(255, 2, 191, 5),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SUBMIT'),
                              Icon(Icons.upload)
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _insertMangrooveData();
                    //     _gotoSearchList();
                    //   },
                    //   child: Text("Upload Mangroove"),
                    // ),
                  ],
                ),
              ),
            )));
  }
  }
