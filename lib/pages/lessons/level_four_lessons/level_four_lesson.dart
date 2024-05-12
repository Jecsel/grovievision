import 'package:flutter/material.dart';
import 'package:grovie/pages/games.dart';
import 'package:grovie/pages/level.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../local_data.dart';
import 'view/lesson_one.dart';
import 'view/lesson_three.dart';
import 'view/lesson_two.dart';

class LevelFourLessons extends StatefulWidget {
  const LevelFourLessons({super.key});

  @override
  State<LevelFourLessons> createState() => _LevelFourLessonsState();
}

class _LevelFourLessonsState extends State<LevelFourLessons> {

  int stars = 0, lvl1Quiz = 0, lvl1Rumble = 0, lvl1Guess = 0, 
    lvl2Quiz = 0, lvl2Rumble = 0, lvl2Guess = 0,
    lvl3Quiz = 0, lvl3Rumble = 0, lvl3Guess = 0,
    lvl1Points = 0, lvl2Points = 0, lvl3Points = 0, lvl4Points = 0,
    lvlAllPoints = 0;
    bool _instructionsDialogShown = false;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instructionsDialogShown = prefs.getBool('instructionsDialogShown') ?? false; 
      
      
      if (!_instructionsDialogShown) {
        showInstruction();
        _instructionsDialogShown = true;
        await prefs.setBool('instructionsDialogShown', true);
      }
    });

    getSaveData();
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

  showInstruction() async {
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
                    'Tap One Family to view Mangroves Information and Also read about them in order to have answer in the game \n'
                    ' \n'
                    'Tap Play Game To Display Games \n'
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
                        Text("Family Myrsinaceae",
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
                        Text("Family Rubiaceae",
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
                        Text("Family Sterculiaceae",
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
                  onPressed: () => gotoGames(4),
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
