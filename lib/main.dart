import 'package:cick_movie_app/ui/screens/main_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CickMovie',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        accentColor: accentColor,
        fontFamily: 'Quicksand',
      ),
      home: MainScreen(),
    );
  }
}
