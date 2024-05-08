import 'package:flutter/material.dart';
import 'package:grovie/pages/lessons/level_one_lessons/level_one_lesson.dart';

class LessonTwo extends StatefulWidget {
  const LessonTwo({super.key});

  @override
  State<LessonTwo> createState() => _LessonTwoState();
}

class _LessonTwoState extends State<LessonTwo> {
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
                    Stack(
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