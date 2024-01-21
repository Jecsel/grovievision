import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../local_data.dart';
import 'home.dart';
import 'lessons/level_four_lessons/level_four_lesson.dart';
import 'lessons/level_one_lessons/level_one_lesson.dart';
import 'lessons/level_three_lessons/level_three_lesson.dart';
import 'lessons/level_two_lessons/level_two_lesson.dart';
import 'level.dart';
import 'score.dart';

class Rumble extends StatefulWidget {
  final String instrctn;
  final List<dynamic> qstns;
  final int lvlNum;
 

  const Rumble({Key? key, required this.instrctn, required this.qstns, required this.lvlNum}) : super(key: key);

  @override
  State<Rumble> createState() => _RumbleState();
}

class _RumbleState extends State<Rumble> {
  // List<dynamic> questions = [
  //   {
  //     'question': 'Shape of fruits of Excoecaria agallocha.',
  //     'answer': 'ROUND',
  //     'choices': ['A', 'R', 'B', 'O', 'C', 'U', 'D', 'N', 'E', 'D']
  //   },
  //   {
  //     'question': 'Inflorescence of flowers in Excoecaria agallocha.',
  //     'answer': 'CATKIN',
  //     'choices': ['Q', 'R', 'T', 'K', 'C', 'U', 'A', 'N', 'E', 'I']
  //   },
  //   {
  //     'question': 'The blade shape of leaves in Xylocarpus granatum.',
  //     'answer': 'OBOVATE',
  //     'choices': ['Q', 'O', 'T', 'A', 'V', 'U', 'O', 'N', 'E', 'B']
  //   },
  //   {
  //     'question': 'Color of fruits in Xylocarpus moluccensis.',
  //     'answer': 'GREEN',
  //     'choices': ['R', 'E', 'G', 'A', 'V', 'N', 'O', 'N', 'E', 'B']
  //   },
  //   {
  //     'question': 'Petals of flowers in Osbornia octodonta.',
  //     'answer': 'APETALOUS',
  //     'choices': ['R', 'S', 'U', 'O', 'L', 'A', 'T', 'E', 'P', 'A']
  //   },
  // ];


  int score = 0;
  int currentQuestionIndex = 0;
  String answer = '';
  List<String> chosenLetters = [];
  final player = AudioPlayer();
  late List<dynamic> questions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    questions = widget.qstns;
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
                saveData('lvl1Rumble', score.toString());
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Level()));
    }
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
                        player.play(AssetSource('correct.mp3'));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Correct!'),
                              content: const Text('Very Good, you got it right!'),
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
                        player.play(AssetSource('wrong.mp3'));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String ans = questions[currentQuestionIndex]['answer'];
                            return AlertDialog(
                              title: const Text('Incorrect'),
                              content: Text("The correct answer is: $ans"),
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
