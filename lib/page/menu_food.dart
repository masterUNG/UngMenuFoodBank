import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungmenufood/models/food_model.dart';
import 'package:ungmenufood/models/order_sqlite_model.dart';
import 'package:ungmenufood/page/order.dart';
import 'package:ungmenufood/utility/my_constant.dart';
import 'package:ungmenufood/utility/my_style.dart';
import 'package:ungmenufood/utility/normal_dialog.dart';
import 'package:ungmenufood/utility/sqlite_helper.dart';

class MemuFood extends StatefulWidget {
  final String category;
  MemuFood({Key key, this.category}) : super(key: key);
  @override
  _MemuFoodState createState() => _MemuFoodState();
}

class _MemuFoodState extends State<MemuFood> {
  String category, chooseDesk;
  List<String> desks = MyConstant().nameDesks;
  List<FoodModel> foodModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.category;
    readData();
  }

  Future<Null> readData() async {
    String urlAPI =
        '${MyConstant().domain}/letrang2/getFoodWhereCatigoryUng.php?isAdd=true&Category=$category';
    // print('urlAPI = $urlAPI');
    var response = await Dio().get(urlAPI);
    // print('res = $response');
    var result = json.decode(response.data);
    // print('result = $result');
    for (var json in result) {
      FoodModel model = FoodModel.fromJson(json);
      setState(() {
        foodModels.add(model);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              routeToOrder();
            },
          )
        ],
      ),
      body: Column(
        children: [
          buildDropdownButton(),
          buildExpanded(),
        ],
      ),
    );
  }

  Expanded buildExpanded() => Expanded(
        child: foodModels.length == 0
            ? MyStyle().showProgress()
            : ListView.builder(
                itemCount: foodModels.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (chooseDesk == null) {
                            print('Dont Choose Desk');
                            normalDialog(context, 'กรุณาเลือกโต้ะ ก่อนคะ');
                          } else {
                            print('You Click ${foodModels[index].nameFood}');
                            confirmFoodDialog(foodModels[index]);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().titleStyleH1(),
                            ),
                            Text(
                              foodModels[index].price,
                              style: MyStyle().titleStyleH2(),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
      );

  Row buildDropdownButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            items: desks
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                chooseDesk = value;
              });
            },
            value: chooseDesk,
            hint: Text('โปรดเลือกโต้ะ'),
          ),
        ],
      );

  Future<Null> confirmFoodDialog(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) {
        int amount = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(foodModel.nameFood),
                  Text(foodModel.price),
                ],
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          amount++;
                          print('amout = $amount');
                        });
                      },
                    ),
                    Text('$amount'),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (amount == 1) {
                          amount = 1;
                        } else {
                          setState(() {
                            amount--;
                            print('amout = $amount');
                          });
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        insertOrderToSQLite(foodModel, amount);
                      },
                      child: Text('OK'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('NO'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Null> insertOrderToSQLite(FoodModel foodModel, int amount) async {
    int priceInt = int.parse(foodModel.price);
    int sumInt = priceInt * amount;

    OrderSQLModel model = OrderSQLModel(
        desk: chooseDesk,
        idFood: foodModel.id,
        nameFood: foodModel.nameFood,
        price: foodModel.price,
        amount: amount.toString(),
        sum: sumInt.toString());

    SQLiteHelper().insertDataToSQLite(model);
  }

  Future<Null> routeToOrder() async {
    try {
      List<OrderSQLModel> models = List();
      models = await SQLiteHelper().readDataFromSQLite();
      print('models.length ==>> ${models.length}');

      if (models.length > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Order(models: models,),
            ));
      } else {
        normalDialog(context, 'Emty Cart');
      }
    } catch (e) {}
  }
}
