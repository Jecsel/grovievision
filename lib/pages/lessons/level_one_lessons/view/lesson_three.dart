import 'package:flutter/material.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

class LessonThree extends StatefulWidget {
  const LessonThree({super.key});

  @override
  State<LessonThree> createState() => _LessonThreeState();
}

class _LessonThreeState extends State<LessonThree> {
  final List<String> imageUrls = [
    'assets/images/level1/lesson3/1.png',
    'assets/images/level1/lesson3/2.png',
    'assets/images/level1/lesson3/3.png',
    'assets/images/level1/lesson3/4.png',
    'assets/images/level1/lesson3/5.png',
    'assets/images/level1/lesson3/6.png',
    'assets/images/level1/lesson3/7.png',
    'assets/images/level1/lesson3/8.png',
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
            return Image.asset(
              imageUrls[index],
              fit: BoxFit.fill,
            );
          },
        ),
      ),
    );
  }
}