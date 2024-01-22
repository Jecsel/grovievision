import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/guess_me.dart';
import 'package:grovie/pages/level.dart';
import 'package:grovie/pages/rumble.dart';
import 'package:grovie/pages/trivia_quiz.dart';

import '../models/question.dart';
import 'lessons/level_four_lessons/level_four_lesson.dart';
import 'lessons/level_one_lessons/level_one_lesson.dart';
import 'lessons/level_three_lessons/level_three_lesson.dart';
import 'lessons/level_two_lessons/level_two_lesson.dart';

class Games extends StatefulWidget {
  final int levelNum;

  const Games({super.key, required this.levelNum});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  AudioPlayer player = AudioPlayer();

  List<Question> lvl1TriviaQuestions = [
    Question(
        question:
            'What mangrove species have medium-sized trees that reach a height of 12 meters, tolerate high salinity, and colonize the soft, muddy banks of rivers and tidal flats?',
        image: 'assets/images/alakaakpula1.jpeg',
        choices: [
          'A. Avicennia alba',
          'B. Avicennia marina',
          'C.Avicennia officinali',
          'D.Avicennia rumphiana'
        ],
        correctAnswerIndex: 0,
        explanation: ''),
    Question(
        question:
            'What mangrove species, formerly referred to as Avicennia lanata, forms medium to large trees?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Avicennia marina',
          'B.Avicennia rumphiana',
          'C.Avicennia alba',
          'D.Avicennia officinalis'
        ],
        correctAnswerIndex: 1,
        explanation: ''),
    Question(
        question:
            'What mangrove species have medium to large trees, reaching up to 20 meters, on firm mud in the upper intertidal zones of estuarine areas?',
        image: 'assets/images/agoho1.jpg',
        choices: [
          'A .Avicennia rumphiana',
          'B. Avicennia marina',
          'C. Avicennia alba',
          'D. Avicennia officinalis'
        ],
        correctAnswerIndex: 3,
        explanation: ''),
    Question(
        question:
            'What mangrove species are pioneering species of small trees, reaching up to 6 meters in height? They are often found in the muddy back mangrove, where they form thick stands, and on sandy beaches near the high water line.',
        image: 'assets/images/apitong3.jpeg',
        choices: [
          'A. Avicennia rumphiana',
          'B. Avicennia marina',
          'C. Lumnitzera racemosa',
          'D.None of the above'
        ],
        correctAnswerIndex: 2,
        explanation: ''),
    Question(
        question:
            'What mangrove species have medium to tall trees reaching 12 meters in height, forming stands along tidal creeks and growing on muddy to sandy- muddy substrates of back mangroves?',
        image: 'assets/images/malasantol1.jpeg',
        choices: [
          'A. Lumnitzera littorea',
          'B. Avicennia marina',
          'C. Avicennia alba',
          'D.Lumnitzera racemosa'
        ],
        correctAnswerIndex: 0,
        explanation: ''),
  ];

  List<Question> lvl2TriviaQuestions = [
    Question(
        question:
            '1. What mangrove species have small to medium trees with surface roots on sandy-muddy substrate along tidal creeks or on hard mud in the inner mangroves and along dikes of ponds? The leaves are highly variable in size, shape, and color.',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Xylocarpus granatum',
          'B. Excoecaria agallocha',
          'C. Xylocarpus moluccensis',
          'D. Osbornia octodonta'
        ],
        correctAnswerIndex: 1,
        explanation: ''),
    Question(
        question:
            'What mangrove species are shrubs to small trees reaching 6 meters tall, with surface roots, often having multiple irregular stems.',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Osbornia octodonta',
          'B. Excoecaria agallocha',
          'C. Xylocarpus granatum ',
          'D. Xylocarpus moluccensis'
        ],
        correctAnswerIndex: 0,
        explanation: ''),
    Question(
        question:
            'What mangrove species are medium trees, reaching up to 17 meters tall, found along estuarine rivers and tidal creeks, whose low buttresses extend as distinctive, snakelike plank roots?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Excoecaria agallocha ',
          'B. Xylocarpus moluccensis ',
          'C. Xylocarpus granatum',
          'D. Osbornia octodonta '
        ],
        correctAnswerIndex: 2,
        explanation: ''),
    Question(
        question:
            'What mangrove species are smaller trees on the firm substrate of back mangroves, rarely appearing along the edges of rivers or creeks; they are also identified as X. mekongensis?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Osbornia octodonta ',
          'B. Excoecaria agallocha',
          'C. Xylocarpus granatum',
          'D. Xylocarpus moluccensis '
        ],
        correctAnswerIndex: 3,
        explanation: ''),
    Question(
        question:
            '5. Which term best describes the apex of Osbornia octodonta leaves?',
        image: 'assets/images/bakan1.jpeg',
        choices: ['A Acuminate', 'B. Emarginate', 'C. Obtuse', 'D. smooth'],
        correctAnswerIndex: 1,
        explanation: ''),
  ];

  List<Question> lvl3TriviaQuestions = [
    Question(
        question:
            'What mangrove species are Shrubs 3-5 m tall, along the high tide line of coralline-rocky and sandy foreshores, often in association with O. octodonta and A. floridum.?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Pemphis acidula',
          'B. Sonneratia alba',
          'C. Sonneratia caseolaris',
          'D. Sonneratia ovata'
        ],
        correctAnswerIndex: 0,
        explanation: ''),
    Question(
        question:
            'What mangrove species are pioneering species of medium to large trees that co-occur with A. marina in fringing mangroves but are dominant in more coralline-sandy substrates?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Sonneratia caseolaris',
          'B. Sonneratia ovata',
          'C. Sonneratia alba ',
          'D. Pemphis acidula '
        ],
        correctAnswerIndex: 2,
        explanation: ''),
    Question(
        question:
            'What mangrove species are prominent trees on the muddy substrate of low salinity upstream riverbanks, closely associated with N. fruticans?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A.Sonneratia alba',
          'B. Sonneratia ovate',
          'C. Sonneratia caseolaris',
          'D. Pemphis acidula'
        ],
        correctAnswerIndex: 2,
        explanation: ''),
    Question(
        question:
            'What mangrove species are shorter trees that grow on firm mud in almost freshwater habitats located considerable distances from the shore, closely associated with N. fruticans? Areas may have access to seawater through seepage during months of higher tide.',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Sonneratia alba',
          'B. Sonneratia ovata',
          'C. Sonneratia caseolaris',
          'D. Pemphis acidula'
        ],
        correctAnswerIndex: 1,
        explanation: ''),
    Question(
        question:
            'What type of mangrove species has creeping stems called rhizomes from which tall (up to 8 m high) compound leaves arise?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Sonneratia alba ',
          'B. Sonneratia ovata',
          'C. Sonneratia caseolaris',
          'D. Nypa fruticans '
        ],
        correctAnswerIndex: 3,
        explanation: ''),
  ];

  List<Question> lvl4TriviaQuestions = [
    Question(
        question:
            'What mangrove species are shrubs with multiple stems to trees up to 10 m tall, on firm mud near tidal creeks or sandy mud near river mouths; they tolerate high salinity.',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Scyphiphora hydrophyllacea',
          'B. Aegiceras corniculatum',
          'C. Aegiceras floridum',
          'D. None of the above'
        ],
        correctAnswerIndex: 0,
        explanation: ''),
    Question(
        question:
            'What mangrove species are shrubs to small trees, typically 2-3 m tall but may reach 5 m?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Scyphiphora hydrophyllacea',
          'B. Aegiceras corniculatum',
          'C. Aegiceras floridum ',
          'D. None of the above'
        ],
        correctAnswerIndex: 1,
        explanation: ''),
    Question(
        question:
            'What mangrove species are medium-sized trees up to 20 m high found in back mangroves, often on dry land along forest margins?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Scyphiphora hydrophyllacea',
          'B. Aegiceras corniculatum',
          'C. Aegiceras floridum',
          'D. Heritiera littoralis'
        ],
        correctAnswerIndex: 3,
        explanation: ''),
    Question(
        question:
            'What mangrove species are small trees (4 m tall) on sandy or rocky substrate that tolerate higher salinities?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Scyphiphora hydrophyllacea ',
          'B. Aegiceras corniculatum',
          'C. Aegiceras floridum',
          'D. Heritiera littoralis'
        ],
        correctAnswerIndex: 2,
        explanation: ''),
    Question(
        question:
            'What is the arrangement of the leaves of Heritiera littoralis?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A. Simple',
          'B. Opposite',
          'C. Decussate',
          'D. None of the Above'
        ],
        correctAnswerIndex: 3,
        explanation: ''),
  ];

  List<dynamic> lvl1RumbleQuestions = [
    {
      'question': 'Apex of Leaves in Acanthus Ebracteatus',
      'answer': 'ACUTE',
      'choices': ['A', 'R', 'B', 'O', 'C', 'U', 'D', 'N', 'E', 'T']
    },
    {
      'question': 'The texture of fruits in Acanthus Ebracteatus',
      'answer': 'SMOOTH',
      'choices': ['S', 'R', 'H', 'O', 'C', 'M', 'D', 'N', '0', 'T']
    },
    {
      'question': 'Color of the fruits of Acanthus ilicifolius',
      'answer': 'GREEN',
      'choices': ['N', 'R', 'B', 'O', 'E', 'U', 'D', 'G', 'E', 'T']
    },
    {
      'question': 'Undersurface of leaves of Acanthus volubilis',
      'answer': 'DARK GREEN',
      'choices': ['A', 'D', 'R', 'G', 'K', 'R', 'E', 'N', 'E', ' ']
    },
    {
      'question': 'Apex of Leaves in Acanthus Ebracteatus',
      'answer': 'SPIKE',
      'choices': ['S', 'R', 'B', 'I', 'K', 'U', 'D', 'N', 'E', 'P']
    },
  ];

  List<dynamic> lvl2RumbleQuestions = [
    {
      'question': 'Shape of fruits of Excoecaria agallocha.',
      'answer': 'ROUND',
      'choices': ['A', 'R', 'B', 'O', 'C', 'U', 'D', 'N', 'E', 'D']
    },
    {
      'question': 'Inflorescence of flowers in Excoecaria agallocha.',
      'answer': 'CATKIN',
      'choices': ['Q', 'R', 'T', 'K', 'C', 'U', 'A', 'N', 'E', 'I']
    },
    {
      'question': 'The blade shape of leaves in Xylocarpus granatum.',
      'answer': 'OBOVATE',
      'choices': ['Q', 'O', 'T', 'A', 'V', 'U', 'O', 'N', 'E', 'B']
    },
    {
      'question': 'Color of fruits in Xylocarpus moluccensis.',
      'answer': 'GREEN',
      'choices': ['R', 'E', 'G', 'A', 'V', 'N', 'O', 'N', 'E', 'B']
    },
    {
      'question': 'Petals of flowers in Osbornia octodonta.',
      'answer': 'APETALOUS',
      'choices': ['R', 'S', 'U', 'O', 'L', 'A', 'T', 'E', 'P', 'A']
    },
  ];


  List<dynamic> lvl3RumbleQuestions = [
    {
      'question': ' It has irregularly shaped branches, small leaves, and small white flowers.',
      'answer': 'PEMPIS',
      'choices': ['P', 'S', 'M', 'O', 'I', 'A', 'T', 'E', 'P', 'A']
    },
    {
      'question': 'Color of fruits in Sonneratia alba',
      'answer': 'DARK GREEN',
      'choices': ['R', 'D', 'G', 'K', 'R', 'A', ' ', 'E', 'N', 'E']
    },
    {
      'question': 'The blade shape of leaves in Sonneratia caseolaris.',
      'answer': 'ELLIPTIC',
      'choices': ['R', 'P', 'I', 'L', 'L', 'A', 'C', 'E', 'I', 'T']
    },
    {
      'question': 'Shape of fruits in Sonneratia ovata.',
      'answer': 'ROUNDED',
      'choices': ['R', 'S', 'U', 'O', 'L', 'A', 'D', 'E', 'D', 'N']
    },
    {
      'question': 'It has creeping stems called rhizomes from which tall (up to 8 m high) compound leaves arise',
      'answer': 'NYPA',
      'choices': ['Y', 'S', 'U', 'O', 'P', 'A', 'T', 'E', 'N', 'A']
    },
  ];

  List<dynamic> lvl4RumbleQuestions = [
    {
      'question': 'The blade shape of leaves in Scyphiphora hydrophyllace',
      'answer': 'OBOVATE',
      'choices': ['O', 'T', 'V', 'O', 'P', 'A', 'B', 'E', 'A', 'A']
    },
    {
      'question': 'Inflorescence of flowers in Scyphiphora hydrophyllacea',
      'answer': 'CYME',
      'choices': ['Y', 'S', 'C', 'O', 'P', 'A', 'T', 'E', 'N', 'M']
    },
    {
      'question': 'The base of leaves in Aegiceras floridum',
      'answer': 'ACUTE',
      'choices': ['C', 'A', 'U', 'O', 'P', 'U', 'T', 'E', 'N', 'A']
    },
    {
      'question': 'The shape of fruits in Aegiceras corniculatum',
      'answer': 'CYLINDRICAL',
      'choices': ['Y', 'C', 'L', 'I', 'N', 'I', 'R', 'D', 'C', 'A', 'L']
    },
    {
      'question': 'Medium-sized trees up to 20 m high found in back mangroves, often on dry land along forest margins',
      'answer': 'HERITIERA',
      'choices': ['Y', 'A', 'R', 'E', 'I', 'T', 'I', 'R', 'E', 'H']
    },
  ];

  List<dynamic> lvl1GuessQuestions = [
    {
      'answer': 'Bruguiera cylindrical',
      'image': 'assets/images/level1/guess_me1/0.jpg'
    },
    {
      'answer': 'Ceriops tagal',
      'image': 'assets/images/level1/guess_me1/1.jpg'
    },
    {
      'answer': 'Schizophrenia apiculata',
      'image': 'assets/images/level1/guess_me1/2.jpg'
    },
    {
      'answer': 'Rhizophora mucronat',
      'image': 'assets/images/level1/guess_me1/3.jpg'
    },
    {
      'answer': 'Rhizophora stylos',
      'image': 'assets/images/level1/guess_me1/4.jpg'
    }
  ];

  List<dynamic> lvl2GuessQuestions = [
    {
      'question': 'Xylocarpus granatum',
      'answer': 'assets/images/level2/guess_me2/0.jpg'
    },
    {
      'question': 'Excoecaria agallocha',
      'answer': 'assets/images/level2/guess_me2/1.jpg'
    },
    {
      'question': 'Osbornia octodonta',
      'answer': 'assets/images/level2/guess_me2/2.jpg'
    },
    {
      'question': 'Xylocarpus moluccensis',
      'answer': 'assets/images/level2/guess_me2/3.jpg'
    },
    {
      'question': 'Granatum fruit',
      'answer': 'assets/images/level2/guess_me2/4.jpg'
    }
  ];

  List<dynamic> lvl3GuessQuestions = [
    {
      'question': 'Sonneratia alba',
      'answer': 'assets/images/level3/guess_me3/0.jpg'
    },
    {
      'question': 'Sonneratia caseolaris',
      'answer': 'assets/images/level3/guess_me3/1.jpg'
    },
    {
      'question': 'Sonneratia ovata',
      'answer': 'assets/images/level3/guess_me3/2.jpg'
    },
    {
      'question': 'Pemphis acidula',
      'answer': 'assets/images/level3/guess_me3/3.jpg'
    },
    {
      'question': 'Nypa fruticans',
      'answer': 'assets/images/level3/guess_me3/4.jpg'
    }
  ];

  List<dynamic> lvl4GuessQuestions = [
    {
      'question': 'Aegiceras corniculatum',
      'answer': 'assets/images/level4/guess_me4/0.jpg'
    },
    {
      'question': 'Aegiceras floridum',
      'answer': 'assets/images/level4/guess_me4/1.jpg'
    },
    {
      'question': 'Scyphiphora Hydrophyllacea',
      'answer': 'assets/images/level4/guess_me4/2.jpg'
    },
    {
      'question': 'Floridum leave',
      'answer': 'assets/images/level4/guess_me4/3.jpg'
    },
    {
      'question': 'Heritiera littoralis',
      'answer': 'assets/images/level4/guess_me4/4.jpg'
    }
  ];

  String triviaInstructions =
      'Choose the correct answer being as base on a question.';
  String rumbleInstructions =
      'Arrange the jumbled letters with description of Mangrove Species base on Scientific name and characteristic of Mangrove Species.';
  String guessInstructions = 'Identify the picture given.';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      player.stop();
      if (player.state != PlayerState.playing) {
        await player.play(AssetSource('home.mp3'));
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    player.stop();
    super.dispose();
  }

  gotoTrivia() {
    // player.stop();
    switch (widget.levelNum) {
      case 1:
        player.dispose();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                      qstns: lvl1TriviaQuestions,
                      instrctn: triviaInstructions,
                      lvlNum: 1,
                    )));
        break;
      case 2:
        player.dispose();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                      qstns: lvl2TriviaQuestions,
                      instrctn: triviaInstructions,
                      lvlNum: 2,
                    )));
        break;
      case 3:
        player.dispose();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                      qstns: lvl3TriviaQuestions,
                      instrctn: triviaInstructions,
                      lvlNum: 3,
                    )));
        break;
      case 4:
        player.dispose();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                      qstns: lvl4TriviaQuestions,
                      instrctn: triviaInstructions,
                      lvlNum: 4,
                    )));
        break;

      default:
    }
  }

  gotoRumble() {
    // player.stop();
    switch (widget.levelNum) {
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Rumble(
                      lvlNum: 1,
                      instrctn: rumbleInstructions,
                      qstns: lvl1RumbleQuestions,
                    )));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Rumble(
                      lvlNum: 2,
                      instrctn: rumbleInstructions,
                      qstns: lvl2RumbleQuestions,
                    )));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Rumble(
                      lvlNum: 3,
                      instrctn: rumbleInstructions,
                      qstns: lvl3RumbleQuestions,
                    )));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Rumble(
                      lvlNum: 4,
                      instrctn: rumbleInstructions,
                      qstns: lvl4RumbleQuestions,
                    )));
        break;
      default:
    }
  }

  gotoGuess() {
    // player.stop();
    switch (widget.levelNum) {
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GuessMe(
                      lvlNum: 1,
                      instrctn: guessInstructions,
                      qstns: lvl1GuessQuestions,
                    )));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GuessMe(
                      lvlNum: 2,
                      instrctn: guessInstructions,
                      qstns: lvl2GuessQuestions,
                    )));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GuessMe(
                      lvlNum: 3,
                      instrctn: guessInstructions,
                      qstns: lvl3GuessQuestions,
                    )));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GuessMe(
                      lvlNum: 4,
                      instrctn: guessInstructions,
                      qstns: lvl4GuessQuestions,
                    )));
        break;
      default:
    }
  }

  void _goBackTo() {
    // player.stop();
    switch (widget.levelNum) {
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LevelOneLessons()));
        break;

      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LevelTwoLessons()));
        break;

      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LevelThreeLessons()));
        break;

      case 4:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LevelFourLessons()));
        break;
      default:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Level()));
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
          onPressed: _goBackTo,
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
                  'assets/images/lesson_bg.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.yellow.shade300),
                  onPressed: gotoTrivia,
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.gamepad_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Text("Grovie Quest",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25.0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.orange.shade300),
                  onPressed: gotoRumble,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.gamepad_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Text("Grovie Mix-up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25.0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.red.shade300),
                  onPressed: gotoGuess,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.gamepad_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Text("Guess Me     ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25.0)),
                      ],
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