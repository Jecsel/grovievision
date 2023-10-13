import 'package:flutter/material.dart';
import 'package:grovievision/screens/add_species.dart';
import 'package:grovievision/screens/admin_list.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/user_choice.dart';

class AdminScreen extends StatefulWidget {
  
  static String routeName = "/admin";

  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  _gotoAdminList() async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminList()));
  }

  _gotoAddSpecies() async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddSpecies()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar( 
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserChoice()));
            },
          ),
          title: Text('Admin'), // Add your app title here
        ),
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
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/images/admin_background.png',
                    // Add your image properties here
                  ),
                ),
              ),
              Positioned(
                bottom: 150,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: ElevatedButton(
                            onPressed: () {
                             _gotoAdminList();
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Mangrove Species List'),
                                Icon(Icons.list)
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
                              _gotoAddSpecies();
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Add Species'),
                                Icon(Icons.add)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
