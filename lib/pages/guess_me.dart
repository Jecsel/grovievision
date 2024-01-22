import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../local_data.dart';
import 'games.dart';
import 'score.dart';

class GuessMe extends StatefulWidget {
  final List<dynamic> qstns;
  final String instrctn;
  final int lvlNum;

  const GuessMe({super.key, required this.qstns, required this.instrctn, required this.lvlNum});

  @override
  State<GuessMe> createState() => _GuessMeState();
}

class _GuessMeState extends State<GuessMe> {

  int score = 0;
  int currentQuestionIndex = 0;
  String answer = '';
  List<String> chosenLetters = [];
  AudioPlayer player = AudioPlayer();
  AudioPlayer playerSE = AudioPlayer();
  late List<dynamic> questions;
  TextEditingController answerController = TextEditingController();


  @override
  void initState() {
    super.initState();

    questions = widget.qstns;
    questions.shuffle();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('guess_me.mp3'));
      }
      _showDialog(context);
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Center(
                child: Text(widget.instrctn)
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

  backTo(){
    player.stop();
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Games(levelNum: widget.lvlNum,)));
  }



  void checkAnswer(String userAnswer) {
    String correctAnswer = questions[currentQuestionIndex]['answer'];

    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      // Correct Answer
      playerSE.play(AssetSource('correct.mp3'));
      showNextQuestion();
      score++;
    } else {
      // Incorrect Answer
      playerSE.play(AssetSource('wrong.mp3'));
      showIncorrectDialog(correctAnswer);
    }
  }

  void showIncorrectDialog(String correctAnswer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect'),
          content: Text('The correct answer is: $correctAnswer'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showNextQuestion();
              },
              child: const Text('Next Question'),
            ),
          ],
        );
      },
    );
  }

  void saveGameScore(int scr) {
    switch (widget.lvlNum) {
      case 1:
        saveData('lvl1Guess', scr.toString());
        break;
      case 2:
        saveData('lvl2Guess', scr.toString());
        break;
      case 3:
        saveData('lvl2Guess', scr.toString());
        break;
      default:
    }
    
  }

  void showNextQuestion() {
    setState(() {
      answerController.clear();
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              content: const Text('You have completed all questions.'),
              actions: [
                TextButton(
                  onPressed: () {
                    player.stop();
                    saveGameScore(score);
                    player.play(AssetSource('correct.mp3'), volume: 0.0);
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
                  'assets/images/guess_me.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    questions[currentQuestionIndex]['image']
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color
                      borderRadius: BorderRadius.circular(10.0), // Optional: Add rounded corners
                    ),
                    child: TextField(
                      controller: answerController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your guess',
                        border: InputBorder.none, // Remove the default border
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    checkAnswer(answerController.text);
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}