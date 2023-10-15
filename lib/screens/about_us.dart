import 'package:flutter/material.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/mangroove.dart';

class AboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(199, 99, 177, 9),
          child: Center(
            child: Column(
              children: <Widget>[
                // Image.asset(
                //   'assets/images/banner.jpg',
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                  child: Text(
                      "The  application will be very helpful to those who struggle to identify Mangrovestree. This application uses Artificial intelligence (AI) to identify benefits of trees. The application willinclude a camera that takes a picture of a tree thenprocesses it to produce text that describes the tress’s name, leaves, flowers, and fruits.",
                      style: TextStyle(color: Colors.white)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Developers",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(199, 99, 177, 9)),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/lovely.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Lovely Gadon")
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/angelica.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Angelica Meniano")
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/john.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("John Reymundo Fabella")
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/aiza.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Aiza Padua")
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/mika.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Mika Ella Leizel Francisco")
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                _drawerItemTapped(0);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Admin',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AdminScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 2,
              onTap: () {
                _drawerItemTapped(2);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 3,
              onTap: () {
                _drawerItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
