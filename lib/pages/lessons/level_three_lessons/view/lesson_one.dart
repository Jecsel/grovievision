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
    'assets/images/level1/lesson1/4.png'
  ];

  int currentIndex = 0;
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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                currentIndex = index + 1;
                return Column(
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
        ],
      ),
    );
  }
}