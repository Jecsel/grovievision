import 'package:flutter/material.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/ui/login.dart';

class UserChoice extends StatefulWidget {
  
  static String routeName = "/splash";

  const UserChoice({super.key});

  @override
  State<UserChoice> createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {

  @override
  void initState() {
    super.initState();
  }

  _navigateToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }

  _navigateToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(228, 0, 200, 83), Color.fromARGB(236, 0, 214, 50)], // Gradient colors
            ),
          ),
          child: Stack(
            children: <Widget>[
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
                            _navigateToHome();
                          },
                           style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size(double.infinity, 60)
                          ),
                          child: Text('Regular User'),
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
                            _navigateToLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size(double.infinity, 60)
                          ),
                          child: Text('Admin'),
                        ),
                      ),
                    ),
                  ],
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
