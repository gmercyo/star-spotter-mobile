import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifalens/utils/colors.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0x6A2C70FF),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: HexColor('#6A2C70'),
          primary: HexColor('#6A2C70'),
          secondary: HexColor('#322154'),
          tertiary: HexColor('#FAF4FB'),
          background: HexColor('#FAF4FB'),
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
