import 'package:flutter/material.dart';
import 'package:ungmenufood/page/category_food.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryFood(),
    );
  }
}
