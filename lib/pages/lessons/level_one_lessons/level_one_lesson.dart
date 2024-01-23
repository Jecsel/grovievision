import 'package:flutter/material.dart';
import 'package:grovie/pages/games.dart';
import 'package:grovie/pages/lessons/level_one_lessons/view/lesson_four.dart';
import 'package:grovie/pages/lessons/level_one_lessons/view/lesson_three.dart';
import 'package:grovie/pages/lessons/level_one_lessons/view/lesson_two.dart';
import 'package:grovie/pages/level.dart';

import '../../../local_data.dart';
import 'view/lesson_one.dart';

class LevelOneLessons extends StatefulWidget {
  const LevelOneLessons({super.key});

  @override
  State<LevelOneLessons> createState() => _LevelOneLessonsState();
}

class _LevelOneLessonsState extends State<LevelOneLessons> {
  int stars = 0, lvl1Quiz = 0, lvl1Rumble = 0, lvl1Guess = 0;

  @override
  void initState(){
    super.initState();
    getStar();
  
  }


  getStar() async {
    await loadData('lvl1Quiz').then((value) {
      setState(() {
        lvl1Quiz = value != null ? int.tryParse(value) ?? 0 : 0;
        stars = lvl1Guess + lvl1Quiz + lvl1Rumble;
      });
    });

    await loadData('lvl1Rumble').then((value) {
      setState(() {
        lvl1Rumble = value != null ? int.tryParse(value) ?? 0 : 0;
        stars = lvl1Guess + lvl1Quiz + lvl1Rumble;
      });
      
    });

    await loadData('lvl1Guess').then((value) {
      setState(() {
         lvl1Guess = value != null ? int.tryParse(value) ?? 0 : 0;
         stars = lvl1Guess + lvl1Quiz + lvl1Rumble;
      });
     
    });
  }

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

  gotoLessonFour(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LessonFour()));
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
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
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
              const SizedBox(height: 50.0,),
              const Text(
                'Mangroves Family',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 50.0,),
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
                      Text("Family Rhizophoraceae",
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
                      Text("Family Acanthaceae",
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
                      Text("Family Avicenniaceae",
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
                onPressed: gotoLessonFour,
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
                      Text("Family Combretaceae",
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
                onPressed: () => gotoGames(1),
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
    );
  }
}
