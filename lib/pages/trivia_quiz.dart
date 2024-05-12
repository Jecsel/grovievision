import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:grovie/local_data.dart';
import 'package:grovie/pages/games.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import 'score.dart';

class TriviaQuiz extends StatefulWidget {
  final String instrctn;
  final List<Question> qstns;
  final int lvlNum;

  const TriviaQuiz(
      {super.key,
      required this.instrctn,
      required this.qstns,
      required this.lvlNum});

  @override
  State<TriviaQuiz> createState() => _TriviaQuizState();
}

class _TriviaQuizState extends State<TriviaQuiz> {
  var score = 0;
  int currentQuestionIndex = 0;
  late List<Question> questions;
  late List<int?> selectedAnswers;
  bool showExplanation = false;
  bool isWrongAnswer = false;

  int questionIndexSelected = 0;
  int choiceIndexSelected = 0;
  bool userSelectAnAnswer = false;
  String instruction = '';
  AudioPlayer player = AudioPlayer();
  AudioPlayer playerSE = AudioPlayer();
  bool _instructionsDialogShown = false;

  @override
  void initState() {
    super.initState();
    questions = widget.qstns;
    instruction = widget.instrctn;

    questions.shuffle();

    selectedAnswers = List.filled(questions.length, null);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        player.play(AssetSource('quiz.mp3'));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instructionsDialogShown = prefs.getBool('instructionsDialogShown') ?? false; 
      
      if (!_instructionsDialogShown) {
        _showDialog(context);
        _instructionsDialogShown = true;
        await prefs.setBool('instructionsDialogShown', true);
      }
    });
  }

  void stopAudio() {
    player.stop();
    player.dispose();
  }

  void saveGameScore(int scr) {
    switch (widget.lvlNum) {
      case 1:
        saveData('lvl1Quiz', scr.toString());
        break;
      case 2:
        saveData('lvl2Quiz', scr.toString());
        break;
      case 3:
        saveData('lvl3Quiz', scr.toString());
        break;
      default:
    }
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
                  image: AssetImage('assets/images/instruction.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Center(child: Text(
                  instruction,
                  textAlign: TextAlign.center,
                )),
              )),
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

  showCheck() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Correct'),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/check.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: const Text('')
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

    void showIncorrectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect'),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/wrong.png',
                  width: 180,
                  height: 1800,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Next Question'),
            ),
          ],
        );
      },
    );
  }


  void onAnswerSelected(int questionIndex, int choiceIndex) {
    setState(() {
      selectedAnswers[questionIndex] = choiceIndex;
      questionIndexSelected = questionIndex;
      choiceIndexSelected = choiceIndex;

      if (selectedAnswers[questionIndex] ==
          questions[questionIndex].correctAnswerIndex) {
        showExplanation = true;
        isWrongAnswer = false;
        playerSE.play(AssetSource('correct.wav'));
        showCheck();
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          int finalScore = calculateScore();

          saveGameScore(finalScore);
          stopAudio;
          player.play(AssetSource('correct.wav',),volume: 0.0);
          showCheck();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Score(
                        score: finalScore.toString(),
                        lvlNum: widget.lvlNum,
                      )));
        }
      } else {
        playerSE.play(AssetSource('wrong.wav'));
        showIncorrectDialog();
        questions[questionIndex].choices.asMap().forEach((index, choice) {
          if (index == choiceIndex) {
            isWrongAnswer = true;
            showExplanation = false;
            if (currentQuestionIndex < questions.length - 1) {
              currentQuestionIndex++;
            } else {
              int finalScore = calculateScore();

              // saveData('lvl1Quiz', finalScore.toString());
              saveGameScore(finalScore);
              stopAudio;
              player.play(AssetSource('correct.wav'), volume: 0.0);
              showCheck();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Score(
                            score: finalScore.toString(),
                            lvlNum: widget.lvlNum,
                          )));
            }
          }
        });
      }
    });
  }

  nextQuestion() {
    setState(() {
      isWrongAnswer = true;
      showExplanation = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        int finalScore = calculateScore();
        // saveData('lvl1Quiz', finalScore.toString());
        saveGameScore(finalScore);
        stopAudio;
        player.play(AssetSource('correct.wav'));
        showCheck();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Score(
                      score: finalScore.toString(),
                      lvlNum: widget.lvlNum,
                    )));
      }
    });
  }

  backTo() {
    player.stop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Games(
                  levelNum: widget.lvlNum,
                )));
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  void dispose() {
    playerSE.dispose(); // Dispose of the background music player
    player.dispose(); // Dispose of the sound effects player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const CircularProgressIndicator();
    }

    String currentNumber = (currentQuestionIndex + 1).toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Trivia'),
          leading: IconButton(
            icon: Image.asset(
              'assets/images/back_btn.png',
              fit: BoxFit.fill,
            ),
            onPressed: backTo,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 24, 122, 0),
                  Color.fromARGB(255, 82, 209, 90)
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/grovie_quiz.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 100.0, bottom: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: questions.isNotEmpty ? '$currentNumber . ${questions[currentQuestionIndex].question}' : ''
                                )
                              ]
                            )
                          ),
                  
                  ),
                  const SizedBox(height: 15.0),
                  ...questions[currentQuestionIndex].choices.map((choice) {
                    int index =
                        questions[currentQuestionIndex].choices.indexOf(choice);
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () {
                            onAnswerSelected(currentQuestionIndex, index);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Text(
                              choice,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                ],
              ),
            ),
          ),
        ));
  }
}
