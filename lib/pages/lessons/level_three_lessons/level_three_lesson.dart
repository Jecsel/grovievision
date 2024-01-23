import 'package:flutter/material.dart';
import 'package:grovie/pages/games.dart';
import 'package:grovie/pages/level.dart';

import 'view/lesson_one.dart';
import 'view/lesson_three.dart';
import 'view/lesson_two.dart';

class LevelThreeLessons extends StatefulWidget {
  const LevelThreeLessons({super.key});

  @override
  State<LevelThreeLessons> createState() => _LevelThreeLessonsState();
}

class _LevelThreeLessonsState extends State<LevelThreeLessons> {

  gotoGames(int levelNum){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Games(levelNum: levelNum)));
  }

  gotoLessonOne(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LessonOne()));
  }

  gotoLessonTwo(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LessonTwo()));
  }

  gotoLessonThree(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LessonThree()));
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Level()));
          },
        ),
        title: const Text(
          'Mangroves Family',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/lesson_bg.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 100.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    backgroundColor: Colors.green),
                  onPressed: gotoLessonOne,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Spacer(),
                        Text("Family Lythraceae",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
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
                  onPressed: gotoLessonTwo,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Spacer(),
                        Text("Family Sonneratiaceae",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
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
                  onPressed: gotoLessonThree,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Spacer(),
                        Text("Family Palmae",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 93, 0, 255)),
                  onPressed: () => gotoGames(3),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("PLAY GAME",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 100.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
