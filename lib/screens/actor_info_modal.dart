import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:star_spotter/utils/actor_info.dart';

String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

String getProxyImageUrl(String imageUrl) {
  return '$baseUrl/img_proxy?url=$imageUrl';
}

void showActorInfoModal(BuildContext context, Image image, String actorName) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Set this true to make modal take up full screen
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (BuildContext bc) {
      return FractionallySizedBox(
        heightFactor: 0.9, // 80% of screen height
        child: Container(
          child: Center(
              child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: ActorInfoScreen(
              actorName: actorName,
              image: image,
            ),
          )),
        ),
      );
    },
  );
}

Future<ActorInfo?> findActorByName(String actorName) async {
  final uri = Uri.parse("$baseUrl/search")
      .replace(queryParameters: {'name': actorName});

  http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    Map<String, dynamic> responseData = jsonDecode(response.body);

    ActorInfo actorInfo = ActorInfo.fromJson(responseData);
    return actorInfo;
  } else {
    // If the server did not return a 200 OK response, show an error notification.
    Fluttertoast.showToast(
      msg: "Sorry, an error occured.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      fontSize: 16.0,
    );

    return null;
  }
}

class ActorInfoScreen extends StatefulWidget {
  final String actorName;
  final Image image;

  const ActorInfoScreen({
    super.key,
    required this.actorName,
    required this.image,
  });

  @override
  State<ActorInfoScreen> createState() => _ActorInfoScreenState();
}

class _ActorInfoScreenState extends State<ActorInfoScreen> {
  ActorInfo? _actorInfo;
  bool isLoading = false;

  void _findActorByName(String actorName) async {
    setState(() {
      isLoading = true;
    });

    ActorInfo? actorInfo = await findActorByName(actorName);

    setState(() {
      _actorInfo = actorInfo;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _findActorByName(widget.actorName!);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   color: Theme.of(context).colorScheme.secondary,
        // ),
        child: Stack(
          children: [
            // Image
            Container(
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _actorInfo?.headShotImage?.url != null
                      ? Image.network(
                              getProxyImageUrl(_actorInfo!.headShotImage!.url!))
                          .image
                      : widget.image.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    secondaryColor.withOpacity(0.2),
                    secondaryColor.withOpacity(0.7),
                    secondaryColor,
                  ],
                  stops: const [
                    0.0,
                    0.3,
                    0.4
                  ], // Adjust these stops for a smooth transition
                ),
              ),
            ),
            Container(
              height: screenHeight,
              child: SingleChildScrollView(
                child: Container(
                  // height of the modal
                  constraints: BoxConstraints(minHeight: screenHeight),
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       secondaryColor.withOpacity(0.2),
                  //       secondaryColor.withOpacity(0.7),
                  //       secondaryColor,
                  //     ],
                  //     stops: const [
                  //       0.0,
                  //       0.3,
                  //       0.4
                  //     ], // Adjust these stops for a smooth transition
                  //   ),
                  // ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.4,
                        ),
                        Text(
                          _actorInfo?.name ?? widget.actorName ?? 'Actor Info',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_actorInfo == null)
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(
                                  child: Text("No info found"),
                                )
                        else ...[
                          SizedBox(height: 20),
                          Text(
                            "Filmography",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Perhaps you've seen them in some of these movies:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                          SizedBox(height: 16),
                          ...(_actorInfo?.filmography?.map(
                                (movie) => Container(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          image: DecorationImage(
                                            image: movie.posterImage?.url !=
                                                    null
                                                ? Image.network(
                                                        getProxyImageUrl(movie
                                                            .posterImage!.url!))
                                                    .image
                                                : const AssetImage(
                                                    'assets/images/placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8),
                                            Text(
                                              movie.name ?? 'Movie name',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Release date: ${movie.releaseDate ?? 'N/A'}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.white70,
                                                  ),
                                            ),
                                            SizedBox(height: 16),
                                            if (movie.tomatoRating != null)
                                              Row(
                                                children: [
                                                  Image.network(
                                                    getProxyImageUrl(movie
                                                            .tomatoRating!
                                                            .iconImage
                                                            ?.url ??
                                                        ''),
                                                    width: 20.0,
                                                    height: 20.0,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "${movie.tomatoRating?.tomatometer ?? 'N/A'} / 100",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Colors.white70,
                                                        ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ) ??
                              [
                                Center(
                                  child: Text(
                                    "No filmography found!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white70,
                                        ),
                                  ),
                                )
                              ])
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // isLoading != null && isLoading!
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : Center(
        //         child: Text(actorName ?? 'Actor Info'),
        //       ),
      ),
    );
  }
}
