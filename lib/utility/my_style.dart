import 'package:flutter/material.dart';

class MyStyle {
  Widget showProgress() => Center(child: CircularProgressIndicator());

  TextStyle titleStyleH1() => TextStyle(
        fontSize: 20,
        color: Colors.blue.shade700,
        fontWeight: FontWeight.bold,
      );

  TextStyle titleStyleH2() => TextStyle(
        fontSize: 16,
        color: Colors.purple.shade700,
        fontWeight: FontWeight.w500,
      );

  MyStyle();
}
