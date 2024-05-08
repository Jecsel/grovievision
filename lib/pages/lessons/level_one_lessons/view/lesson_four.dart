import 'package:flutter/material.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

class LessonFour extends StatefulWidget {
  const LessonFour({super.key});

  @override
  State<LessonFour> createState() => _LessonFourState();
}

class _LessonFourState extends State<LessonFour> {
  final List<String> imageUrls = [
    'assets/images/level1/lesson4/1.png',
    'assets/images/level1/lesson4/2.png',
    'assets/images/level1/lesson4/3.png',
    'assets/images/level1/lesson4/4.png'
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
              ],
            );
          },
        ),
      ),
    );
  }
}