import 'package:flutter/material.dart';
import 'package:s7_peliculas/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App Flutter',
      initialRoute: "/",
      routes: {"/": (BuildContext context) => HomePage()},
    );
  }
}
