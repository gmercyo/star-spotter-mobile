import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifalens/screens/actor_info_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../widgets/buttons.dart';

Future<http.Response> submitImage(String path) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.103:3000/rekognise'),
  );

  final image = await http.MultipartFile.fromPath('image', path);

  request.files.add(image);

  var streamedResponse = await request.send();

  // Get the response from the stream
  return await http.Response.fromStream(streamedResponse);
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
              margin: const EdgeInsets.only(bottom: 64.0, top: 64.0),
              child: const Text(
                'Take a photo of any actor in a movie scene and find out who they are and what they\'ve been in!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            // button with elevation 0 and border radius and text "Take a photo"
            StyledBlockButton(
              child: _isUploading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text('Take photo'),
              onPressed: () async {
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );

                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });

                  setState(() {
                    _isUploading = true;
                  });

                  http.Response response = await submitImage(pickedFile.path);

                  setState(() {
                    _isUploading = false;
                  });

                  if (response.statusCode != 200) {
                    print(response.body);
                    Fluttertoast.showToast(
                      msg: "Sorry, an error occured: ${response.statusCode}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  // to json
                  Map<String, dynamic> responseData = jsonDecode(response.body);
                  // name is the name key in responseData
                  String name = responseData['name'];

                  if (context.mounted) {
                    // TODO: no need for storing the image in state, just pass it to this function which will then send it to the API
                    // upload the file to the APIto get their name, and upload name to separate endpoint to get bio
                    showActorInfoModal(context, Image.file(_imageFile!), name);
                  }
                }
              },
              // color: Theme.of(context).colorScheme.primary,
            ),

            // if (_imageFile != null) ...[

            // ]
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera),
      //   onPressed: _pickImage,
      // ),
    );
  }
}
