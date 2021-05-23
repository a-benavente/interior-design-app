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
        title: Text('Image Picker Example'),
      ),
      body: (_image == null) ?
             Center( 
             child: Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Text('No image selected.'),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            // floatingActionButton:
            FloatingActionButton(
                onPressed: getImage,
                  tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
                shape: RoundedRectangleBorder(),
                backgroundColor: Theme.of(context).primaryColor,
              ),
          ],
        ),
     ) 
     
             :  GridView.count(
               primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
               children: [
                 Column(
                   children: [
                     Image.file(_image, height: 150, width: 150, ), 
                     Text('Untitled List'),
                   ],
                 ),
               ],
             ),
      
      
  //      GridView.count(
  //       primary: false,
  //   padding: const EdgeInsets.all(20),
  //   crossAxisSpacing: 10,
  //   mainAxisSpacing: 10,
  //   crossAxisCount: 2,
  // children: [
  //         Column(
  //           children: <Widget>[ 
  //              (_image == null) ?
  //              Text('No image selected.') 
  //              :
  //               Image.file(_image, height: 150, width: 150, ),
  //               Text('Untitled List'),

  //           // padding: EdgeInsets.all(20),
  //           ]
  //         ),
  //       ],
  //     ),
      
    );
  }
}