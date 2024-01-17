import 'package:flutter/material.dart';
import 'package:grovie/pages/level.dart';
import 'package:grovie/pages/trivia_quiz.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {

  gotoTrivia(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const TriviaQuiz()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Level()));
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
                  'assets/images/splash.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 100.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.yellow.shade300),
                  onPressed: gotoTrivia,
                  child: const Padding(
                    padding: EdgeInsets.only(top:15.0, bottom: 15.0, left: 20.0, right: 20.0),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
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
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
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
                        Text("Guess Me",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                          )
                        ),
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
