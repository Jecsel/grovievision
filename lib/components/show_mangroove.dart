
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grovievision/screens/about_us.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/mangroove.dart';

class ShowMangroove extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ShowMangrooveState();

}

class _ShowMangrooveState  extends State<ShowMangroove> {
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
        title: const Text('Mangroove Info'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children:<Widget>[
              Image.asset(
                'assets/images/aegiceras.png',
              ),
              SizedBox(height: 10),
              Text(
                "Aegiceras corniculatum",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Local Names: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "saging-saging, tayokan, kawilan(Visayan), tinduk-tindukan(Tagalog)"
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Shrubs to small trees typically 2-3 m tall but may reach 5 m. The species grows in isolated clumps never forming extensive stands along tidal creeks and river mouths. Widely distributed in Panay but has never been found together with its sister species A. floridum (see following). Substrate is sandy to compact mud. The leaves are often notched and have a prominent midrib on the undersurface which merges with the pinkish petiole. The strongly curved fruits hang in clusters like small bananas (hence the local names referring to banana varieties) and are pale green to pinkish-red. In Panay, the species is used for firewood and the bark for tanning and fish poison. Elsewhere in the Philippines, the wood is made into knife handles."),
              SizedBox(height: 10),
              Row(children: [
                Expanded(child: 
                  Column(
                    children: [
                      Text(
                        "Leaves",
                        style: TextStyle(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Row(children: [
                        Text("Arrangement"),
                        Expanded(child: 
                        Text("simple, alternate")
                        )
                      ],)
                    ],
                  )
                ),
                Image.asset(
                'assets/images/aegiceras.png',
                width: 110,
                height: 110,
              ),
              ],),
              
            ],
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

