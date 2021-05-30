import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'utilities/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.indigo),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  Uint8List bytes;

  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        ImageSharedPrefs.saveImageToPrefs(
            ImageSharedPrefs.base64String(_image.readAsBytesSync()));
        // need to correct this I think there is an issue with the PickedFile return from the ImagePicker ..
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        bytes = _image.readAsBytesSync();
        ImageSharedPrefs.saveImageToPrefs(ImageSharedPrefs.base64String(bytes));
      } else {
        print('No image selected.');
      }
    });
  }

  loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        _image = ImageSharedPrefs.imageFrom64BaseString(imageString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: Text('Interior Organizer'),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Edit Lists', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            )
          ],
        ),
        body: (_image == null)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No image selected.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          style:
                              OutlinedButton.styleFrom(primary: Colors.indigo),
                          onPressed: getImageFromGallery,
                          label: Text(''),
                          icon: Icon(Icons.add_a_photo),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.indigo,
                          ),
                          onPressed: getImageFromCamera,
                          label: Text(''), //fix this because it is not working
                          icon: Icon(Icons.add_a_photo),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  Column(
                    children: [
                      Image.file(
                        _image,
                        height: 150,
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text('Untitled List'),
                      ),
                    ],
                  ),
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            )
          ]),
        ));
  }
}
