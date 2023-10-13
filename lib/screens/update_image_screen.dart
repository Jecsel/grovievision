import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grovievision/models/mangroove_data.dart';
import 'package:grovievision/service/databaseHelper.dart';

class UpdateImageScreen extends StatefulWidget {
  @override
  _UpdateImageScreenState createState() => _UpdateImageScreenState();
}

class _UpdateImageScreenState extends State<UpdateImageScreen> {
  late DatabaseHelper dbHelper;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  List<MangrooveData> insertedDataList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  Future<void> _insertImage() async {
    final ByteData assetData = await rootBundle.load('assets/images/splash_logo.png');
    final Uint8List imageBytes = assetData.buffer.asUint8List();

    final newMangrooveData = MangrooveData(
      imageBlob: imageBytes, // Replace with the actual image data as a Uint8List
      name: nameController.text,
      description: descriptionController.text, id: 1,
    );

    final id = await dbHelper.insertImageData(newMangrooveData);
    final mangrooveData = newMangrooveData.copy(id: 1);

    setState(() {
      // insertedDataList.add(mangrooveData);
    });
  }

  Future<void> _fetchInsertedData() async {
    final data = await dbHelper.getImageDataList();
    setState(() {
      insertedDataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _insertImage,
              child: Text("Insert"),
            ),
            ElevatedButton(
              onPressed: _fetchInsertedData,
              child: Text("Fetch Inserted Data"),
            ),
            insertedDataList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Inserted Image Data:"),
                      for (var mangrooveData in insertedDataList)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name: ${mangrooveData.name}"),
                            Text("Description: ${mangrooveData.description}"),
                             Image.memory(mangrooveData.imageBlob),
                          ],
                        ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
