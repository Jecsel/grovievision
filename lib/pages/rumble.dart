import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_data.dart';
import 'games.dart';
import 'score.dart';

class Rumble extends StatefulWidget {
  final String instrctn;
  final List<dynamic> qstns;
  final int lvlNum;
 

  const Rumble({Key? key, required this.instrctn, required this.qstns, required this.lvlNum}) : super(key: key);

  @override
  State<Rumble> createState() => _RumbleState();
}

class _RumbleState extends State<Rumble> with WidgetsBindingObserver {

  int score = 0;
  int currentQuestionIndex = 0;
  String answer = '';
  List<String> chosenLetters = [];
  AudioPlayer player = AudioPlayer();
  AudioPlayer playerSE = AudioPlayer();
  late List<dynamic> questions;
  bool _instructionsDialogShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    questions = widget.qstns;
    questions.shuffle();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('rumble.m4a'));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instructionsDialogShown = prefs.getBool('instructionsDialogShown') ?? false; 
      
      // if (!_instructionsDialogShown) {
      //   _showDialog(context);
      //   _instructionsDialogShown = true;
      //   await prefs.setBool('instructionsDialogShown', true);
      // }

      _showDialog(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

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

  void saveGameScore(int scr) {
    switch (widget.lvlNum) {
      case 1:
        saveData('lvl1Rumble', scr.toString());
        break;
      case 2:
        saveData('lvl2Rumble', scr.toString());
        break;
      case 3:
        saveData('lvl3Rumble', scr.toString());
        break;
      default:
    }
    
  }

  void showCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have completed all questions.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // saveData('lvl1Rumble', score.toString());
                player.stop();
                player.play(AssetSource('correct.wav'), volume: 0.0);
                saveGameScore(score);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Score(score: score.toString(), lvlNum: widget.lvlNum,)));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        score++;
        currentQuestionIndex++;
        chosenLetters.clear(); // Clear selected letters for the new question
      });
    } else {
      // All questions have been answered, you can show a final screen or handle it as needed
      setState(() {
        score++;
      });
      showCompleteDialog();
    }
  }

  void clearSelectedLetters() {
    setState(() {
      chosenLetters.clear();
    });
  }

  void removeLastSelectedLetter() {
    if (chosenLetters.isNotEmpty) {
      setState(() {
        chosenLetters.removeLast();
      });
    }
  }

  void backTo(){
    player.stop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Games(levelNum: widget.lvlNum,)));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('INSTRUCTION'),
          content: Container(
            width: double.infinity,
            height: 200.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/instruction.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Center(
                child: Text(
                  widget.instrctn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9.0
                  ),
                )
              ),
            )
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
          onPressed: backTo,
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
                  'assets/images/grovie_mix.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  questions[currentQuestionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    questions[currentQuestionIndex]['answer'].length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: chosenLetters.length > index
                              ? Text(chosenLetters[index])
                              : const Text(''),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                            onPressed: () {
                              player.play(AssetSource('click.mp3'));
                              setState(() {
                                chosenLetters.add(
                                  questions[currentQuestionIndex]['choices'][index]);
                              });
                            },
                            child: Text(questions[currentQuestionIndex]
                                ['choices'][index]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                            onPressed: () {
                              player.play(AssetSource('click.mp3'));
                              setState(() {
                                chosenLetters.add(questions[currentQuestionIndex]['choices'][index + 5]);
                              });
                            },
                            child: Text(questions[currentQuestionIndex]['choices'][index + 5]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: clearSelectedLetters,
                      child: const Text('Clear All'),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: removeLastSelectedLetter,
                      child: const Text('Remove Last'),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 93, 0, 255),
                    ),
                    onPressed: () {
                      // Check if selected letters match the correct answer
                      if (chosenLetters.join() == questions[currentQuestionIndex]['answer']) {
                        playerSE.play(AssetSource('correct.wav'));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Correct!'),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: Column(
                                  children: [
                                    const Text('Very Good, you got it right!'),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Image.asset(
                                        'assets/images/check.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    moveToNextQuestion(); // Move to the next question
                                  },
                                  child: const Text('Next Question'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        playerSE.play(AssetSource('wrong.wav'));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String ans = questions[currentQuestionIndex]['answer'];
                            return AlertDialog(
                              title: const Text('Incorrect'),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: Column(
                                  children: [
                                    Text('The correct answer is: $ans'),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Image.asset(
                                        'assets/images/wrong.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    clearSelectedLetters();
                  
                                    if (currentQuestionIndex <
                                        questions.length - 1) {
                                      setState(() {
                                        currentQuestionIndex++;
                                      });
                                    } else {
                                      showCompleteDialog();
                                    }
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
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
