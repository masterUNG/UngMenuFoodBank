import 'package:flutter/material.dart';

class MemuFood extends StatefulWidget {
  final String category;
  MemuFood({Key key, this.category}) : super(key: key);
  @override
  _MemuFoodState createState() => _MemuFoodState();
}

class _MemuFoodState extends State<MemuFood> {
  String category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Column(
        children: [buildDropdownButton()],
      ),
    );
  }

  DropdownButton buildDropdownButton() => DropdownButton(items: null, onChanged: null);
}
