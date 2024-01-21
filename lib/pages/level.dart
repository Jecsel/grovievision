import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grovie/local_data.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

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
  late AudioPlayer player;
  int lvl1Quiz = 0, lvl1Rumble = 0, lvl1Guess = 0, 
    lvl2Quiz = 0, lvl2Rumble = 0, lvl2Guess = 0,
    lvl3Quiz = 0, lvl3Rumble = 0, lvl3Guess = 0,
    lvl1_points = 0, lvl2_points = 0, lvl3_points = 0, lvl4_points = 0;

  @override
  void initState(){
    super.initState();
    
    player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    });

    getSaveData();
  }

  showUnlockToast() {
    Fluttertoast.showToast(
      msg: "Unlock the previous level first.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  gotoLevelOneLessons(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelOneLessons()));
  }

  gotoLevelTwoLessons(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelTwoLessons()));
  }

  gotoLevelThreeLessons(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelThreeLessons()));
  }

  gotoLevelFourLessons(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelFourLessons()));
  }

  getSaveData() {
    loadData('lvl1Quiz').then((value) {
      print('=====lvl1Quiz====== $value ==========');
      setState(() {
        lvl1Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl2Quiz').then((value) {
      setState(() {
         lvl2Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
      });
     
    });
    loadData('lvl3Quiz').then((value) {
      setState(() {
        lvl3Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl1Rumble').then((value) {
      setState(() {
        lvl1Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl2Rumble').then((value) {
      setState(() {
        lvl2Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl3Rumble').then((value) {
      setState(() {
        lvl3Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl1Guess').then((value) {
      setState(() {
        lvl1Guess = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl2Guess').then((value) {
      setState(() {
        lvl2Guess = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });
    loadData('lvl3Guess').then((value) {
      setState(() {
        lvl3Guess = value != null ? int.tryParse(value) ?? 0 : 0;
      });
      
    });

    setState(() {
      lvl1_points = lvl1Guess + lvl1Quiz + lvl1Rumble;
      lvl2_points = lvl2Guess + lvl2Quiz + lvl2Rumble;
      lvl3_points = lvl3Guess + lvl3Quiz + lvl3Rumble;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back_btn.png',
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                const SizedBox(height: 140.0,),
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
                    backgroundColor: Colors.green),
                  onPressed: lvl1Quiz > 0 ? gotoLevelTwoLessons : () => showUnlockToast(),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Level 2",
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
                    backgroundColor: Colors.green),
                  onPressed: lvl2Quiz > 0 ? gotoLevelThreeLessons : () => showUnlockToast(),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Level 3",
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
                    backgroundColor: Colors.green),
                  onPressed: lvl3Quiz > 0 ? gotoLevelFourLessons : () => showUnlockToast(),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Level 4",
                      style: TextStyle(
                        color: Colors.white,
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
      ),
    );
  }
}
