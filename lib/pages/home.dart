import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/about.dart';
import 'package:grovie/pages/level.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local_data.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();
  bool _instructionsDialogShown = false;

  int stars = 0, lvl1Quiz = 0, lvl1Rumble = 0, lvl1Guess = 0, 
    lvl2Quiz = 0, lvl2Rumble = 0, lvl2Guess = 0,
    lvl3Quiz = 0, lvl3Rumble = 0, lvl3Guess = 0,
    lvl1Points = 0, lvl2Points = 0, lvl3Points = 0, lvl4Points = 0,
    lvlAllPoints = 0;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('home.mp3'));
      }
     
     
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _instructionsDialogShown = prefs.getBool('instructionsDialogShown') ?? false; 
    
     print('_instructionsDialogShown $_instructionsDialogShown');
      if (!_instructionsDialogShown) {
        _showInstructionsDialog(context);
        _instructionsDialogShown = true;
        await prefs.setBool('instructionsDialogShown', true);
      }
    });

    getSaveData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.paused) {
    //   player.stop();
    // }


    switch (state) {
      case AppLifecycleState.paused:
        player.pause();
        break;
      case AppLifecycleState.resumed:
        player.resume();
        break;
      default:
        player.stop();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  setAllPoints(){
    setState(() {
      lvl1Points = lvl1Guess + lvl1Quiz + lvl1Rumble;
      lvl2Points = lvl2Guess + lvl2Quiz + lvl2Rumble;
      lvl3Points = lvl3Guess + lvl3Quiz + lvl3Rumble;
      lvlAllPoints = lvl1Points + lvl2Points + lvl3Points;
    });
  }

  getSaveData() {
    loadData('lvl1Quiz').then((value) {
      print('=====lvl1Quiz====== $value ==========');
      setState(() {
        lvl1Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl2Quiz').then((value) {
      setState(() {
         lvl2Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
         setAllPoints();
      });
     
    });
    loadData('lvl3Quiz').then((value) {
      setState(() {
        lvl3Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
    });
      
    });
    loadData('lvl1Rumble').then((value) {
      setState(() {
        lvl1Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl2Rumble').then((value) {
      setState(() {
        lvl2Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl3Rumble').then((value) {
      setState(() {
        lvl3Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl1Guess').then((value) {
      setState(() {
        lvl1Guess = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl2Guess').then((value) {
      setState(() {
        lvl2Guess = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
    });
    loadData('lvl3Guess').then((value) {
      setState(() {
        lvl3Guess = value != null ? int.tryParse(value) ?? 0 : 0;
        setAllPoints();
      });
      
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

  _showInstructionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Instructions'),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/paper_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                'Welcome to Grovie!\n\n'
                'Instructions:\n'
                '- Tap Let’s Grovie To Display Level\n'
                '-  Tap About Us To Display About App\n'
                '- Tap "Exit" to exit the app.\n',
                style: TextStyle(fontSize: 16.0),
              ),
                ),
              ],
            ),
          ),
      );
    },
  );
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
              actions: [
                Row(
                  children: [
                    Image.asset('assets/images/star.gif'),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        lvlAllPoints.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ],
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


