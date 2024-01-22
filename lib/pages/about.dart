import 'package:flutter/material.dart';
import 'home.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final List<String> imageUrls = [
    'assets/images/about/about1.png',
    'assets/images/about/about2.png',
    'assets/images/about/about3.png'
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade400,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Column(
            children: [
              const Text(
                'ABOUT APP',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50.0),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'GROVIE',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                    children: <TextSpan>[
                        TextSpan( text: 'Grovie is a game-based mobile application focused on mangrove species found on Tablas Island. It helps students learn about these species and identify the family to which a mangrove belongs, providing an enjoyable learning experience')
              ])),
              const SizedBox(height: 20.0),
              Image.asset('assets/icon.png'),
              const SizedBox(height: 20.0),
               RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                    children: <TextSpan>[
                        TextSpan( text: 'The application has three categories: Grovie Quest, Grovie Mix-up, and Guess Me. In Grovie Quest, choose the correct answer based on the question asked. In Grovie Mix-up, arrange the jumbled letters with descriptions of mangrove species based on the scientific name and characteristics of each mangrove species. In Guess Me, identify the displayed picture. If a player correctly guesses 5 answers in a game, they can earn 5 stars. However, if they don\'t answer correctly, they can earn only a few stars, depending on how many correct answers they provide. You have to collect 12 stars or more in level 1 to unlock level 2. To unlock level 3, the player needs to earn 24 stars, and for level 4, the player needs to earn 48 stars. Each level displays details, names, and images of mangrove species. If the player guesses the correct or incorrect answer, there will be a corresponding sound effect. This interactive learning experience combines information, quizzes, and games to ensure a comprehensive understanding of mangroves. Enjoy the lessons and activities, enhancing your knowledge ')
              ])),
          
              const SizedBox(height: 50.0),
              const Text(
                'DEVELOPERS',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/john.jpg')
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'JHON REYMOND FABELLA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/aiza.jpg')
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'AIZA PADUA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/angelica.jpg')
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'ANGELICA MENIANO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/lovely.jpg')
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'LOVELY GABALDON',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/mika.jpg')
                  ),
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'MIKA ELLA LIEZEL FRANCISCO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              // Expanded(
              //   child: PageView.builder(
              //     itemCount: imageUrls.length,
              //     itemBuilder: (context, index) {
              //       currentIndex = index + 1;
              //       return Column(
              //         children: [
              //           Image.asset(
              //             imageUrls[index],
              //             height: MediaQuery.of(context).size.height,
              //             fit: BoxFit.fill,
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
