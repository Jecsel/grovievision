import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:grovie/local_data.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';
import 'package:grovie/pages/level.dart';

import '../models/question.dart';
import 'lessons/level_four_lessons/level_four_lesson.dart';
import 'lessons/level_three_lessons/level_three_lesson.dart';
import 'lessons/level_two_lessons/level_two_lesson.dart';
import 'score.dart';

class TriviaQuiz extends StatefulWidget {
  final String instrctn;
  final List<Question> qstns;
  final int lvlNum;

  const TriviaQuiz({super.key, required this.instrctn, required this.qstns, required this.lvlNum});

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
  final player = AudioPlayer();

  int questionIndexSelected = 0;
  int choiceIndexSelected = 0;
  bool userSelectAnAnswer = false;
  String instruction = '';

  @override
  void initState() {
    super.initState();
    questions = widget.qstns;
    instruction = widget.instrctn;

    questions.shuffle();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog(context);
    });

    selectedAnswers = List.filled(questions.length, null);
  }

  void stopAudio() {
    player.stop();
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
                child: Text(instruction)
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

  void onAnswerSelected(int questionIndex, int choiceIndex) {
    setState(() {
      selectedAnswers[questionIndex] = choiceIndex;
      questionIndexSelected = questionIndex;
      choiceIndexSelected = choiceIndex;

      if (selectedAnswers[questionIndex] ==
          questions[questionIndex].correctAnswerIndex) {
        showExplanation = true;
        isWrongAnswer = false;
        player.play(AssetSource('correct.mp3'));
      } else {
        player.play(AssetSource('wrong.mp3'));
        questions[questionIndex].choices.asMap().forEach((index, choice) {
          if (index == choiceIndex) {
            isWrongAnswer = true;
            showExplanation = false;
            if (currentQuestionIndex < questions.length - 1) {
              currentQuestionIndex++;
            } else {
              int finalScore = calculateScore();

              saveData('lvl1Quiz', finalScore.toString());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Score(score: finalScore.toString(), lvlNum: widget.lvlNum,)));
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
        saveData('lvl1Quiz', finalScore.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Score(score: finalScore.toString(), lvlNum: widget.lvlNum,)));
      }
    });
  }

  backTo(){
    switch (widget.lvlNum) {
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelOneLessons()));
        break;

      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelTwoLessons()));
        break;

      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelThreeLessons()));
        break;

      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelFourLessons()));
        break;
      default:
        Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Level()));
    }
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
                  // Image.asset(
                  //   questions[currentQuestionIndex].image,
                  //   width: double.infinity,
                  //   height: 300.0,
                  // ),
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                        questions.isNotEmpty
                            ? '$currentNumber . ${questions[currentQuestionIndex].question}'
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
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
                  showExplanation
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            questions.isNotEmpty
                                ? questions[currentQuestionIndex].explanation
                                : '',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15.0),
                          ),
                        )
                      : const Text(''),
                  showExplanation
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            onPressed: nextQuestion,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Text(
                                'NEXT',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
        ));
  }
}
