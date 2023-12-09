import 'package:flutter/material.dart';
import 'package:grovievision/screens/home.dart';

class MyLoadingScreen extends StatefulWidget {
  @override
  _MyLoadingScreenState createState() => _MyLoadingScreenState();
}

class _MyLoadingScreenState extends State<MyLoadingScreen> {
  // Simulate a time-consuming operation (e.g., fetching data)
  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 10));
  }

  navigateToHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Simulating a future operation (e.g., fetching data)
        future: fetchData(),
        builder: (context, snapshot) {
          // Check if the future is still in progress
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 200),
                  Image.asset(
                    'assets/images/load.gif',
                    width: 100,
                    height: 100,
                  ),
                  Text('Please wait ...')
                ],
              ) 
            );
          }

          // Check if there's an error during the future execution
          if (snapshot.hasError) {
            // Display an error message
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // The future has completed successfully, display the main content
          return Center(
              child: Column(
                children: [
                  SizedBox(height: 200),
                  Image.asset(
                    'assets/images/load.gif',
                    width: 100,
                    height: 100,
                  ),
                  Text('Please wait ...')
                ],
              ) 
            );
        },
      ),
    );
  }
}