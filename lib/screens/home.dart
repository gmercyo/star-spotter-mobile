import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<http.Response> submitImage(String base64Image) {
  return http.post(
    Uri.parse(
        'https://9xmtbfe4qi.execute-api.eu-west-2.amazonaws.com/staging/recognize'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'image': base64Image,
    }),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  bool _isUploading = false;
  String? _celebName;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // logo, horizontally centered, 60% width
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),

            // centered text in a bos of 0.75 width
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'Take a photo of any actor and find out who they are and what they\'ve been in!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            // button with elevation 0 and border radius and text "Take a photo"
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Take a photo'),
            ),

            // if (_imageFile != null) ...[

            // ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: _pickImage,
      ),
    );
  }
}
