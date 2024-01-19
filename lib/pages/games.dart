import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/level.dart';
import 'package:grovie/pages/trivia_quiz.dart';

import '../models/question.dart';

class Games extends StatefulWidget {
  final int levelId;

  const Games({super.key, required this.levelId});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  late AudioPlayer player;

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
        question: 'What mangrove species are shrubs to small trees reaching 6 meters tall, with surface roots, often having multiple irregular stems.',
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
        question: 'What mangrove species are medium trees, reaching up to 17 meters tall, found along estuarine rivers and tidal creeks, whose low buttresses extend as distinctive, snakelike plank roots?',
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
        question: 'What mangrove species are smaller trees on the firm substrate of back mangroves, rarely appearing along the edges of rivers or creeks; they are also identified as X. mekongensis?',
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
        question: '5. Which term best describes the apex of Osbornia octodonta leaves?',
        image: 'assets/images/bakan1.jpeg',
        choices: [
          'A Acuminate',
          'B. Emarginate',
          'C. Obtuse',
          'D. smooth'
        ],
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
        question: 'What mangrove species are pioneering species of medium to large trees that co-occur with A. marina in fringing mangroves but are dominant in more coralline-sandy substrates?',
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
        question: 'What mangrove species are prominent trees on the muddy substrate of low salinity upstream riverbanks, closely associated with N. fruticans?',
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
        question: 'What mangrove species are shorter trees that grow on firm mud in almost freshwater habitats located considerable distances from the shore, closely associated with N. fruticans? Areas may have access to seawater through seepage during months of higher tide.',
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
        question: 'What type of mangrove species has creeping stems called rhizomes from which tall (up to 8 m high) compound leaves arise?',
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
        question: 'What mangrove species are shrubs to small trees, typically 2-3 m tall but may reach 5 m?',
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
        question: 'What mangrove species are medium-sized trees up to 20 m high found in back mangroves, often on dry land along forest margins?',
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
        question: 'What mangrove species are small trees (4 m tall) on sandy or rocky substrate that tolerate higher salinities?',
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
        question: 'What is the arrangement of the leaves of Heritiera littoralis?',
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

  String trivia_instructions = 'Choose the correct answer being as base on a question.';

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (player.state == PlayerState.playing) {
        player.stop();
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
    switch (widget.levelId) {
      case 0:
        player.dispose();
        player.stop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                    qstns: lvl1TriviaQuestions,
                    instrctn: trivia_instructions)));
        break;
      case 1:
        player.dispose();
        player.stop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                    qstns: lvl2TriviaQuestions,
                    instrctn: trivia_instructions)));
        break;
      case 2:
        player.dispose();
        player.stop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                    qstns: lvl3TriviaQuestions,
                    instrctn: trivia_instructions)));
        break;
      case 3:
        player.dispose();
        player.stop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TriviaQuiz(
                    qstns: lvl4TriviaQuestions,
                    instrctn: trivia_instructions)));
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Level()));
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
                  onPressed: () {},
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
                  onPressed: () {},
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
