import 'package:flutter/material.dart';
import 'db_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Directionality(
        // add this
        textDirection: TextDirection.rtl, // set this property
        child: DBTestPage(),
      ),
    );
  }
}
