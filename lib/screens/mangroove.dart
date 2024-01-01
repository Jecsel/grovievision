
import 'package:flutter/material.dart';
import 'package:grovievision/components/show_mangroove.dart';
import 'package:grovievision/screens/about_us.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/view_species.dart';

class Mangroove extends StatefulWidget {
  const Mangroove({super.key});

  @override
  State<StatefulWidget> createState() => _MangroovePageState();

}

class DropdownItem {
  final String label;
  final String imagePath;
  final String description;

  DropdownItem({
    required this.label,
    required this.imagePath,
    required this.description,
  });
}

class _MangroovePageState extends State<Mangroove> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDropdownDemo(),
    );
  }
}

class MyDropdownDemo extends StatefulWidget {
  @override
  _MyDropdownDemoState createState() => _MyDropdownDemoState();
}

class _MyDropdownDemoState extends State<MyDropdownDemo> {
  DropdownItem? selectedDropdownItem;

    int _selectedIndex = 0;

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget _buildDrawerItem({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: onTap,
    );
  }
  
  List<DropdownItem> dropdownItems = [
    DropdownItem(
      label: 'Item 1',
      imagePath: "assets/images/narra.jpeg",
      description: 'Description for Item 1',
    ),
    DropdownItem(
      label: 'Item 2',
      imagePath: "assets/images/narra.jpeg",
      description: 'Description for Item 2',
    ),
    // Add more items as needed
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangrooves'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Column(
        children: <Widget>[
          // Place the DropdownButton at the top and make it fit the width
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Tree'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  // selectedDropdownItem = newValue;
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies()));
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Root'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Flower'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Trunk'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Leaf'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Fruit'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedDropdownItem != null)
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset(
                  selectedDropdownItem!.imagePath,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(selectedDropdownItem!.description),
              ],
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 2,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}