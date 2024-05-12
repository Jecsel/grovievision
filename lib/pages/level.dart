import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grovie/local_data.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'lessons/level_four_lessons/level_four_lesson.dart';
import 'lessons/level_three_lessons/level_three_lesson.dart';
import 'lessons/level_two_lessons/level_two_lesson.dart';

class Level extends StatefulWidget {
  const Level({super.key});

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {
  AudioPlayer player = AudioPlayer();
   bool _instructionsDialogShown = false;
  int lvl1Quiz = 0, lvl1Rumble = 0, lvl1Guess = 0, 
    lvl2Quiz = 0, lvl2Rumble = 0, lvl2Guess = 0,
    lvl3Quiz = 0, lvl3Rumble = 0, lvl3Guess = 0,
    lvl1Points = 0, lvl2Points = 0, lvl3Points = 0, lvl4Points = 0,
    lvlAllPoints = 0;

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('home.mp3'));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instructionsDialogShown = prefs.getBool('instructionsDialogShown') ?? false; 
      
      
      if (!_instructionsDialogShown) {
        showInstructionOne();
        _instructionsDialogShown = true;
        await prefs.setBool('instructionsDialogShown', true);
      }
    });

    getSaveData();
  }

showInstructionOne() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('INSTRUCTION'),
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
                'Tap Level 1 To Display Family of Mangroves and Play Game \n',
                style: TextStyle(fontSize: 16.0),
              ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  showInstructionTwo() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('INSTRUCTION'),
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
                    'Level 2 Unlock the previous level first with at least 12 star\n'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  showInstructionThree() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('INSTRUCTION'),
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
                    'Level 3 Unlock the previous level first with at least 24 star \n'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  showInstructionFour() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('INSTRUCTION'),
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
                  child:  const Text(
                    'Level 4 Unlock the previous level first with at least 48 star\n'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  showUnlockToast() {
    Fluttertoast.showToast(
      msg: "Unlock the previous level first.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  gotoLevelOneLessons(){
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelOneLessons()));
  }

  gotoLevelTwoLessons(){
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelTwoLessons()));
  }

  gotoLevelThreeLessons(){
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelThreeLessons()));
  }

  gotoLevelFourLessons(){
    player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelFourLessons()));
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

  setAllPoints(){
    setState(() {
      lvl1Points = lvl1Guess + lvl1Quiz + lvl1Rumble;
      lvl2Points = lvl2Guess + lvl2Quiz + lvl2Rumble;
      lvl3Points = lvl3Guess + lvl3Quiz + lvl3Rumble;
      lvlAllPoints = lvl1Points + lvl2Points + lvl3Points;
    });
  }


  @override
  Widget build(BuildContext context) {
    // showInstruction();
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back_btn.png',
            fit: BoxFit.fill,
          ),
          onPressed: () {
            player.stop();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
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
        title: const Text(
          'Select Level',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/level_select.png'), // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 200.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  backgroundColor: Colors.green),
                onPressed: gotoLevelOneLessons,
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Level 1",
                    style: TextStyle(
                      color: Colors.white,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  backgroundColor: const Color.fromRGBO(76, 175, 80, 1)),
                onPressed: lvlAllPoints >= 12 ? gotoLevelTwoLessons : () => showInstructionTwo(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      lvlAllPoints < 12 ? const Icon(Icons.lock) : const Icon(Icons.lock_open, color: Color.fromRGBO(76, 175, 80, 1),),
                      const SizedBox(width: 75.0),
                      const Text(
                        "Level 2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                      const Text(""),
                    ],
                  ),
                ),
              ),
              const SizedBox( height: 15.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  backgroundColor: Colors.green),
                onPressed: lvlAllPoints >= 24 ? gotoLevelThreeLessons : () => showInstructionThree(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      lvlAllPoints < 24 ? const Icon(Icons.lock) : const Icon(Icons.lock_open, color: Color.fromRGBO(76, 175, 80, 1),),
                      const SizedBox(width: 75.0),
                      const Text("Level 3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox( height: 15.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  backgroundColor: Colors.green),
                onPressed: lvlAllPoints >= 36 ? gotoLevelFourLessons : () => showInstructionFour(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      lvlAllPoints < 36 ? const Icon(Icons.lock) : const Icon(Icons.lock_open, color: Color.fromRGBO(76, 175, 80, 1),),
                      const SizedBox(width: 75.0),
                      const Text("Level 4",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0
                        )
                      ),
                    ],
                  ),
                ),
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}
