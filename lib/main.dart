import 'package:flutter/material.dart';
import 'package:news_c10_str/layout/home.dart';
import 'package:news_c10_str/screens/news_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        NewsDetails.routName: (context) => NewsDetails(),
      },
    );
  }
}
