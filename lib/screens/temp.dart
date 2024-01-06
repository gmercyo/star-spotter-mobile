// Image.file(_imageFile!),
//               if (_celebName != null) Text(_celebName!),
//               ElevatedButton.icon(
//                 icon: _isUploading
//                     ? Container(
//                         width: 24,
//                         height: 24,
//                         padding: const EdgeInsets.all(2.0),
//                         child: const CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 3,
//                         ),
//                       )
//                     : Icon(Icons.cloud_upload),
//                 label: const Text('Submit'),
//                 onPressed: () async {
//                   final bytes = await _imageFile!.readAsBytes();
//                   final base64Image = base64Encode(bytes);
//                   // start loading
//                   setState(() {
//                     _isUploading = true;
//                   });
//                   final response = await submitImage(base64Image);
//                   // stop loading
//                   setState(() {
//                     _isUploading = false;
//                   });
//                   if (response.statusCode == 200) {
//                     // If the server returns a 200 OK response, parse the JSON.
//                     print('Response data: ${response.body}');
//                     // update state with celeb name from response.body
//                     Map<String, dynamic> responseData =
//                         jsonDecode(response.body);
//                     // get the responseData.body?.CelebrityFaces?.[0].Name and set it to _celebName
//                     String body = responseData['body'];
//                     Map<String, dynamic> bodyData = jsonDecode(body);

//                     if (bodyData.containsKey('CelebrityFaces') &&
//                         bodyData['CelebrityFaces'].length > 0) {
//                       setState(() {
//                         _celebName = bodyData['CelebrityFaces'][0]['Name'];
//                       });
//                     }
//                   } else {
//                     // If the server did not return a 200 OK response,
//                     // then throw an exception.
//                     throw Exception('Failed to submit image');
//                   }
//                 },
//               ),