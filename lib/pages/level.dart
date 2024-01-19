import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/games.dart';
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

  @override
  void initState(){
    super.initState();
    
    player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Add your arrow icon here
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
                  onPressed: gotoLevelTwoLessons,
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
                  onPressed: gotoLevelThreeLessons,
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
                  onPressed: gotoLevelFourLessons,
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
