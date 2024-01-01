import 'package:flutter/material.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/user_choice.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';

class SplashScreen extends StatefulWidget {
  
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.initiateUserData(dbHelper);
    print("============initiateUserData====done=====");
    dbHelper.initiateMangrooveData(dbHelper);
    print("============initiateMangrooveData====done=====");
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(const Duration(milliseconds: 3000), (){});
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search Tree'),
          backgroundColor: Colors.green, // Set the background color here
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(228, 0, 200, 83), Color.fromARGB(236, 0, 214, 50)], // Gradient colors
            ),
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/splash_img.png',
                  // Add your image properties here
                ),
              ), 
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/load.gif',
                  width: 80,
                  height: 80,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/splash_bottom.png', // Replace with your second image
                  // Add your second image properties here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
