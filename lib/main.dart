import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interior Organizer'),
      ),
      body: (_image == null) ?
             Center( 
             child: Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No image selected.'),
                  ),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  primary: Colors.indigo
                ),
                onPressed: getImage,
                label : Text('Pick Image'),
                icon: Icon(Icons.add_a_photo),
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
                         Image.file(_image, height: 150, width: 150,), 
                         Padding(
                           padding: const EdgeInsets.fromLTRB(0, 8, 0,0),
                           child: Text('Untitled List'),
                         ),
                       ],
                     ),
                   ],
                 ),
            
    );
  }
}