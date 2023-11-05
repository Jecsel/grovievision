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
  late MangroveDatabaseHelper dbHelper;
  List<Map<String, dynamic>> similarImages = [];

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
    return MaterialApp(
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
          Center(
            child: Text(
              "Scanner",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600
              ),
              ),
          ),
          SizedBox(height: 20),
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
                            getImageFromCamera();
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
                            getFromGallery();
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
  
  Future compareTwoImages() async {  /// Compare two images
    final perceptual = await compareImages(
        src1: localImage, src2: takenImage, algorithm: PerceptualHash());

    setState(() {
      perceptualResult = 100 - (perceptual * 100);
    });
    print('Difference: ${perceptualResult}%');
  }

    Future getFromGallery() async {
      final pickedFileFromGallery = await ImagePicker().getImage(     /// Get from gallery
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      print('pickFile');
      print(pickedFileFromGallery?.path);

      localImage = File(pickedFileFromGallery!.path);

      for (Map mangroveImage in mangroveImages!) {
        String imagePath = mangroveImage['imagePath'];

        print('mANGROVE IMAGES');
        print(imagePath);

        final tempDir = await getTemporaryDirectory();
        final tempPath = tempDir.path;
        final file = File('$tempPath/temp_image.jpg');
        await file.writeAsBytes(mangroveImage['imageBlob']);

        double similarityScore = await compareImages(src1: localImage, src2: imagePath, algorithm: PerceptualHash());

        if (imagePath.startsWith('assets/')) {
          similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
        }

        if (similarityScore <= 0.5) {
          print("Gallery image is similar to $similarityScore.");

          similarityScore = 100 - (similarityScore * 100);
          Map<String, dynamic> imageInfo = {
            "score": similarityScore,
            "image": mangroveImage, // Add the image or any other relevant information here
          };
          similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
          similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
        }else{
          print("Gallery image is BELOW similar to $similarityScore.");
        }
      }

      setState(() {
        localImage = File(pickedFileFromGallery.path);  
        similarImages = similarImages;

        if(similarImages.length > 0) {
          Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
        } else {
          final snackBar = SnackBar(
            content: Text('No Results Found!'),
          );
          ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
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

    Future getImageFromCamera() async {    /// Get Image from Camera
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      print('pickFile');
      print(pickedFile);

      for (Map mangroveImage in mangroveImages!) {
        String imagePath = mangroveImage['imagePath'];

        print('mANGROVE IMAGES');
        print(imagePath);

        double similarityScore = await compareImages(src1: File(pickedFile!.path), src2: imagePath, algorithm: PerceptualHash());

        final tempDir = await getTemporaryDirectory();
        final tempPath = tempDir.path;
        final file = File('$tempPath/temp_image.jpg');
        await file.writeAsBytes(mangroveImage['imageBlob']);

        if (imagePath.startsWith('assets/')) {
          similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
        }

        if (similarityScore <= 0.5) {
          print("Gallery image is similar to $similarityScore.");
          similarityScore = 100 - (similarityScore * 100);
          Map<String, dynamic> imageInfo = {
            "score": similarityScore,
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
          takenImage = File(pickedFile.path);// Compare the images here and show the result
          if(similarImages.length > 0) {
            Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'FLOWER')));
          } else {
            final snackBar = SnackBar(
              content: Text('No Results Found!'),
            );
            ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
          }
        });
      }
    }
  }

