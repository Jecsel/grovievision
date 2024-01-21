import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grovie/pages/games.dart';
import 'package:grovie/pages/level.dart';

// ignore: must_be_immutable
class Score extends StatefulWidget {
  final int lvlNum;
  String score;

  Score({super.key, required this.score, required this.lvlNum});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  final player = AudioPlayer();
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      player.play(AssetSource('congrats.mp3'));
    });
  }

  _goTo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Games(levelNum: widget.lvlNum,)));
  }

  Widget buildStars(int count) {
    List<Widget> stars = List.generate(
      count,
      (index) => Image.asset('assets/images/star.gif', height: 70.0, width: 70.0,),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    int scoreCount = int.parse(widget.score);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Trivia'),
          leading: IconButton(
            icon: Image.asset(
            'assets/images/back_btn.png',
            fit: BoxFit.fill,
          ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Level()));
            },
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
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 80.0),
              Text(
                'You\'ve got $scoreCount star',
                style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50.0),
              buildStars(scoreCount),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 200.0,
                  height: 60.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: _goTo,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(
                        'PLAY AGAIN',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
