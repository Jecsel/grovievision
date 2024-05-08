import 'package:flutter/material.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

class LessonOne extends StatefulWidget {
  const LessonOne({super.key});

  @override
  State<LessonOne> createState() => _LessonOneState();
}

class _LessonOneState extends State<LessonOne> {
  final List<String> imageUrls = [
    'assets/images/level1/lesson1/1.png',
    'assets/images/level1/lesson1/2.png',
    'assets/images/level1/lesson1/3.png',
    'assets/images/level1/lesson1/4.png',
    'assets/images/level1/lesson1/5.png',
    'assets/images/level1/lesson1/6.png',
    'assets/images/level1/lesson1/7.png',
    'assets/images/level1/lesson1/8.png',
    'assets/images/level1/lesson1/9.png',
    'assets/images/level1/lesson1/10.png',
    'assets/images/level1/lesson1/11.png',
    'assets/images/level1/lesson1/12.png',
    'assets/images/level1/lesson1/13.png',
    'assets/images/level1/lesson1/14.png',
    'assets/images/level1/lesson1/15.png',
    'assets/images/level1/lesson1/16.png',
    'assets/images/level1/lesson1/17.png',
    'assets/images/level1/lesson1/18.png',
    'assets/images/level1/lesson1/19.png',
    'assets/images/level1/lesson1/20.png',
  ];

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelOneLessons()));
          },
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: PageView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Image.asset(
                  imageUrls[index],
                  fit: BoxFit.fill,
                ),

                Positioned(
                  left: 0.0,
                  bottom: 50.0,
                  child: index + 1 == imageUrls.length ? const Text('') : Image.asset(
                    'assets/images/swipe.png',
                    width: 250.0,
                    height: 150.0,
                    fit: BoxFit.fill,
                  ),
                ),

                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: index + 1 == imageUrls.length ? Image.asset(
                    'assets/images/point_up.gif',
                    width: 80.0,
                    height: 80.0,
                  ) : const Text('')
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}