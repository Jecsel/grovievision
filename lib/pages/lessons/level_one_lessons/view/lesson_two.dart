import 'package:flutter/material.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

class LessonTwo extends StatefulWidget {
  const LessonTwo({super.key});

  @override
  State<LessonTwo> createState() => _LessonTwoState();
}

class _LessonTwoState extends State<LessonTwo> {
  final List<String> imageUrls = [
    'assets/images/level1/lesson2/1.png',
    'assets/images/level1/lesson2/2.png',
    'assets/images/level1/lesson2/3.png',
    'assets/images/level1/lesson2/4.png'
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