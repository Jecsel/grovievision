import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grovievision/components/treeImageListState.dart';
import 'package:grovievision/models/image_data.dart';
import 'package:grovievision/screens/about_us.dart';
import 'package:grovievision/screens/mangroove.dart';
import 'package:grovievision/screens/result.dart';
import 'package:grovievision/screens/search.dart';
import 'package:grovievision/screens/view_species.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:grovievision/ui/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_compare/image_compare.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {

  // Run your app within the runApp function
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Database database; // Declare a variable to hold the database instance
  String searchQuery = '';
  int _selectedIndex = 0;
  int _selectedIdx = 0;
  static const IconData qr_code_scanner_rounded =
  IconData(0xf00cc, fontFamily: 'MaterialIcons');
  final picker = ImagePicker();
  File? localImage;
  File? takenImage;
  List<Map>? mangroveImages;
  List<Map>? fruitImages;
  List<Map>? rootImages;
  List<Map>? leafImages;
  List<Map>? flowerImages;
  late MangroveDatabaseHelper dbHelper;
  List<Map<String, dynamic>> similarImages = [];
  bool isErrorShow = false;
  bool isLoading = false;

  double perceptualResult = 0.0;
  final CarouselController _carouselController = CarouselController();

  List<Map<String, dynamic>> carouselItems = [
  {'name': 'TREE', 'image': 'assets/images/tree.png'},
  {'name': 'FLOWER', 'image': 'assets/images/flower.png'},
  {'name': 'LEAF', 'image': 'assets/images/leaf.png'},
  {'name': 'ROOT', 'image': 'assets/images/root.png'},
  {'name': 'FRUIT', 'image': 'assets/images/fruit.png'},
];

  void _gotoResultPage(List<Map> results){
    Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE', pageType: 'User')));
  }

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
      dbHelper = MangroveDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    mangroveImages = await dbHelper.getImagesFromMangrove();
    fruitImages = await dbHelper.getImagesFromFruit();
    rootImages = await dbHelper.getImagesFromRoot();
    leafImages = await dbHelper.getImagesFromLeaf();
    flowerImages = await dbHelper.getImagesFromFlower();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  void _goToPreviousSlide() {
    _carouselController.previousPage();
  }

  void _goToNextSlide() {
    _carouselController.nextPage();
  }

  void _onItemTappedCat(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
        onWillPop: () async {
        return _onBackPressed(context);
        },
        child: MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Grovievision'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the margin as needed
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE', pageType: 'User'))),
            ),
          ),
          SizedBox(height: 40),
          // Half of the screen with a green gradient
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
              enlargeCenterPage: true,
              autoPlay: true, // Set to true if you want the carousel to auto-play
              autoPlayInterval: Duration(seconds: 3), // Auto-play interval
              autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
              autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
              scrollDirection: Axis.horizontal, // Set to Axis.horizontal for a horizontal carousel
            ),
            items: carouselItems.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: item['name'], pageType: 'User')));
                },
                child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color.fromARGB(255, 129, 176, 199), Color.fromARGB(255, 56, 76, 142)],
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Container( // Background
                        width: double.infinity,
                        child: Image.asset(
                          item['image'],
                          width: double.infinity,
                        ),
                      ),
                      Align( // Centered content
                        alignment: Alignment.center,
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Colors.white38

                          ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            );
              
            }).toList(),
          ),
          SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // getImageFromCamera();
                            _showModal('getImageFromCamera');
                          },
                           style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size(double.infinity, 60)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                Icons.camera_alt,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text('Take Photo'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Add spacing between buttons
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _showModal('getFromGallery');
                            // getFromGallery();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size(double.infinity, 60)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                Icons.drive_folder_upload,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text('Insert Photo'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Visibility(
                      visible: isLoading,
                      child: CircularProgressIndicator()),
                    SizedBox(height: 20),
                    Visibility(
                      visible: !isLoading && isErrorShow,
                      child: Text(
                        "No Results Found!",
                        style: TextStyle(color: Colors.red),
                    ))
                  ],
                ),
              ),
      ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                _drawerItemTapped(0);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Admin',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 2,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 3,
              onTap: () {
                _drawerItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
    routes: {
        '/mangrooves': (context) => Mangroove(),
        '/about_us': (context) => Mangroove(),
      },
    )
  
  );
}

  Future<bool> _onBackPressed(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit the app?'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false; // Return false if the dialog is dismissed
  }

  Future<dynamic> setTableToCompare(String scanType, String treePart) async {
    if(scanType == 'getImageFromCamera'){
      getImageFromCamera(treePart);
    } else {
      getFromGallery(treePart);
    }
  }

  _showModal(String scanType) {
    BuildContext context = this.context;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select which part',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: () { 
                  setTableToCompare(scanType, 'tree'); 
                  Navigator.pop(context);
                },
                child: Text('Tree'),
              ),
              SizedBox(height: 5),
               ElevatedButton(
                onPressed: () { 
                  setTableToCompare(scanType, 'fruit'); 
                  Navigator.pop(context);
                },
                child: Text('Fruit'),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () { 
                  setTableToCompare(scanType, 'flower'); 
                  Navigator.pop(context);
                },
                child: Text('Flower'),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () { 
                  setTableToCompare(scanType, 'leaf'); 
                  Navigator.pop(context);
                },
                child: Text('Leaf'),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () { 
                  setTableToCompare(scanType, 'root'); 
                  Navigator.pop(context);
                },
                child: Text('Root'),
              ),
              // Visibility(
              //   visible: isErrorShow,
              //   child: Text(
              //     "No Results Found!",
              //     style: TextStyle(color: Colors.red),
              //   ))
            ],
          ),
        ),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
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


  Future getFromGallery(String treePart) async {
    isLoading = true;
    final pickedFileFromGallery = await ImagePicker().getImage(     /// Get from gallery
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      print('pickFile');
      print(pickedFileFromGallery?.path);

      switch (treePart) {
        case 'flower':
          mangroveImages = flowerImages;
          break;
        case 'fruit':
          mangroveImages = fruitImages;
          break;
        case 'root':
          mangroveImages = rootImages;
          break;
        case 'leaf':
          mangroveImages = leafImages;
          break;
        default:
          mangroveImages = mangroveImages;
      }

      localImage = File(pickedFileFromGallery!.path);

      for (Map mangroveImage in mangroveImages!) {
        String imagePath = mangroveImage['imagePath'];

        print('mANGROVE IMAGES');
        print(imagePath);

        final tempDir = await getTemporaryDirectory();
        final tempPath = tempDir.path;
        final file = File('$tempPath/temp_image.jpg');

        print('mangroveImage[imageBlob]');
        print(mangroveImage['imageBlob']);
        if(mangroveImage['imageBlob'] != null) {
          await file.writeAsBytes(mangroveImage['imageBlob']);
        }
        double similarityScore = 1.0;

        if (imagePath.startsWith('assets/')) {
          similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
        } else {
          similarityScore = await compareImages(src1: localImage, src2: File(imagePath), algorithm: PerceptualHash());
        }

        if (similarityScore <= 0.3) {

          similarityScore = 100 - (similarityScore * 100);
          int roundedSimilarityScore = similarityScore.round();

          Map<String, dynamic> imageInfo = {
            "score": roundedSimilarityScore,
            "image": mangroveImage, // Add the image or any other relevant information here
          };
          similarImages.add(imageInfo); //adding those results higher 50 percentage differences;

          print("======= $similarityScore% =============");
          similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
        }else{
          similarityScore = 100 - (similarityScore * 100);
          print("======= $similarityScore% =============");
        }
      }

      setState(() {
        localImage = File(pickedFileFromGallery.path);  
        similarImages = similarImages;
        isErrorShow = false;
        isLoading = false;
        if(similarImages.length > 0) {
          Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, treePart: treePart)));
        } else {
          print("=========== show Error Message ==========");
          isErrorShow = true;
        }
      });
    }

    Future<File> getImageFileFromAsset(String assetPath) async {
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();
      final String tempFileName = assetPath.split('/').last;

      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$tempFileName');
      
      await tempFile.writeAsBytes(bytes, flush: true);
      return tempFile;
    }

    checkImagePath(filePath) {
      if (!filePath.startsWith('assets/')) {
        return File(filePath);
      }

      return filePath;
    }

    Future getImageFromCamera(String treePart) async {    /// Get Image from Camera
      isLoading = true;
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      print('pickFile');
      print(pickedFile);

      switch (treePart) {
        case 'flower':
          mangroveImages = flowerImages;
          break;
        case 'fruit':
          mangroveImages = fruitImages;
          break;
        case 'root':
          mangroveImages = rootImages;
          break;
        case 'leaf':
          mangroveImages = leafImages;
          break;
        default:
          mangroveImages = mangroveImages;
      }

      for (Map mangroveImage in mangroveImages!) {
        String imagePath = mangroveImage['imagePath'];

        print('mANGROVE IMAGES');
        print(imagePath);

        // double similarityScore = await compareImages(src1: File(pickedFile!.path), src2: imagePath, algorithm: PerceptualHash());

        final tempDir = await getTemporaryDirectory();
        final tempPath = tempDir.path;
        final file = File('$tempPath/temp_image.jpg');
        if(mangroveImage['imageBlob'] != null) {
          await file.writeAsBytes(mangroveImage['imageBlob']);
        }
        
        print('======== mANGROVE IMAGES ========');
        // if (imagePath.startsWith('assets/')) {
        //   similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
        // }
        double similarityScore = 1.0;

        if (imagePath.startsWith('assets/')) {
          print('======== mANGROVE UNA ========');
          similarityScore = await compareImages(src1: File(pickedFile!.path), src2: file, algorithm: PerceptualHash());
        } else {
          print('======== mANGROVE Pangalawa ========');
          similarityScore = await compareImages(src1: File(pickedFile!.path), src2: File(imagePath), algorithm: PerceptualHash());
        }

        if (similarityScore <= 0.5) {
          print("Gallery image is similar to $similarityScore.");
          similarityScore = 100 - (similarityScore * 100);
          int roundedSimilarityScore = similarityScore.round();
          Map<String, dynamic> imageInfo = {
            "score": roundedSimilarityScore,
            "image": mangroveImage, // Add the image or any other relevant information here
          };
          similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
          similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
        }else{
          print("Gallery image is BELOW similar to $similarityScore.");
        }
      }

      if (pickedFile != null) {
        setState(() {
          isErrorShow = false;
          isLoading = false;
          takenImage = File(pickedFile.path);// Compare the images here and show the result
          if(similarImages.length > 0) {
            Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, treePart: treePart)));
          } else {
            print("=========== show Error Message ==========");
            isErrorShow = true;
          }
        });
      }
    }
  }

