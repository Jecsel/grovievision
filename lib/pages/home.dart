import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/about.dart';
import 'package:grovie/pages/level.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AudioPlayer player;

  @override
  void initState(){
    super.initState();
    
    // player = AudioPlayer();
    // player.stop();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (player.state != PlayerState.playing) {
    //     player.play(AssetSource('home.mp3'));
    //   }
    // });
  }

  gotoLevel() {
  //   player.dispose();
  //   player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Level()));
  }

  gotoAbout(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const About()));
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Grovie',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white
              ),
            ),
            backgroundColor: Colors.green.shade700,
          ),
          backgroundColor: Colors.green.shade50,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_menu.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.transparent),
                    onPressed: gotoLevel,
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Let's Grovie",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                    ),
                  ),
                  const SizedBox( height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.transparent),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("About Us",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                    ),
                  ),
                  const SizedBox( height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.transparent),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Exit",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    title: 'Home',
                    index: 0,
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Let\'s Grovie',
                    index: 1,
                    onTap: () {
                      gotoLevel();
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Abouts Us',
                    index: 2,
                    onTap: () {
                      gotoAbout();
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Exit',
                    index: 5,
                    onTap: () {
                      // Navigator.pop(context);
                      _onBackPressed(context);
                    },
                  ),
                ],
              ),
            ),
      ),
    
    );
  
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit the app?'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false; // Return false if the dialog is dismissed
  }

  Widget _buildDrawerItem({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}


