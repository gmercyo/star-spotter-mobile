import 'dart:async';
import 'dart:convert';
// import 'dart:io' show File, Platform;

// import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:star_spotter/screens/actor_info_modal.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../widgets/buttons.dart';

String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

Future<http.Response> uploadFile(List<int> fileBytes) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/rekognise'),
  );

  request.files
      .add(http.MultipartFile.fromBytes('image', fileBytes, filename: 'image'));

  var streamedResponse = await request.send();
  return await http.Response.fromStream(streamedResponse);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isUploading = false;

  Future<void> pickImage() async {
    Uint8List? fileBytes;

    if (!kIsWeb) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Photo Gallery'),
              onPressed: () async {
                // close the options modal
                Navigator.of(context).pop();
                // get image from gallery
                fileBytes = await getImageBytesFromGallery();
                submitFile(fileBytes);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () async {
                // close the options modal
                Navigator.of(context).pop();
                // get image from camera
                fileBytes = await getImageBytesFromCamera();
                submitFile(fileBytes);
              },
            ),
          ],
        ),
      );
    } else {
      fileBytes = await getImageWithFilePicker();
      submitFile(fileBytes);
    }
  }

  Future<void> submitFile(Uint8List? fileBytes) async {
    Image? image;
    http.Response? response;

    if (fileBytes != null) {
      setState(() {
        _isUploading = true;
      });

      image = Image.memory(fileBytes);

      try {
        response = await uploadFile(fileBytes!);
      } catch (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(
          msg: "Sorry, an error occured.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }

    if (response != null && image != null) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg:
              "Sorry, an error occured: ${responseData['error'] ?? response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.red,
          fontSize: 16.0,
        );
        return;
      }

      String name = responseData['name'];

      if (context.mounted) {
        showActorInfoModal(context, image, name);
      }
    }
  }

  Future<Uint8List?> getImageBytesFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }

    return null;
  }

  Future<Uint8List?> getImageBytesFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }

    return null;
  }

  Future<Uint8List?> getImageWithFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    print(result);

    if (result != null) {
      PlatformFile file = result.files.first;
      return file.bytes;
    }

    return null;
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
              onPressed: pickImage,
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
