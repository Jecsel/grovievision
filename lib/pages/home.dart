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
  AudioPlayer player = AudioPlayer();

  @override
  void initState(){
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('home.mp3'));
      }
    });
  }

  gotoLevel() async {
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Level()));
  }

  gotoAbout(){
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const About()));
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
              title: const Text(
                'Grovie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.green.shade700,
            ),
            backgroundColor: Colors.green.shade50,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/lesson_bg.png'), // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: gotoLevel,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/button.png'),
                            fit: BoxFit.fill
                          )
                        ),
                        child: const Text(
                          "Let's Grovie",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ),
      
                    const SizedBox( height: 15.0),
                    GestureDetector(
                      onTap: gotoAbout,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/button.png'),
                            fit: BoxFit.fill
                          )
                        ),
                        child: const Text(
                          "About Us",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox( height: 15.0),
                    GestureDetector(
                      onTap: () => _onBackPressed(context),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/button.png'),
                            fit: BoxFit.fill
                          )
                        ),
                        child: const Text(
                          "Exit",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
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
      
      ),
    );
  
  }

  _onBackPressed(BuildContext context) async {
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


