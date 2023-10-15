import 'package:flutter/material.dart';
import 'package:grovievision/components/show_mangroove.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/user_choice.dart';
import 'package:grovievision/screens/view_species.dart';

class AdminList extends StatefulWidget {
  static String routeName = "/admin";

  const AdminList({super.key});

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  final List<String> speciesList = [
    'Acanthus ebracteatus',
    'Acanthus ilicifolius',
    'Acanthus volubilis',
    'Aegiceras corniculatum',
    'Aegiceras floridum',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserChoice()));
            },
          ),
          title: Text('Admin'), // Add your app title here
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  // search(value);
                },
                decoration: InputDecoration(
                  labelText: "Search Tree",
                  prefixIcon: Icon(Icons.image_search_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: speciesList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(1)));
                      final imageData = speciesList[index];
                      final snackBar = SnackBar(
                        content: Text('Tapped on ${imageData}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(
                    title: Text(speciesList[index]),
                    trailing: Icon(Icons.arrow_forward_ios), // Right icon
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
