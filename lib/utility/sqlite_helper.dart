import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ungmenufood/models/order_sqlite_model.dart';

class SQLiteHelper {
  final String nameDatabase = 'ungMenuFood.db';
  final String nameTable = 'orderTable';
  final String columnid = 'id';
  final String columndesk = 'desk';
  final String columnidFood = 'idFood';
  final String columnnameFood = 'nameFood';
  final String columnprice = 'price';
  final String columnamount = 'amount';
  final String columnsum = 'sum';
  int varsion = 1;

  SQLiteHelper() {
    initialDatabase();
  }

  Future<Null> initialDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $nameTable ($columnid INTEGER PRIMARY KEY, $columndesk TEXT, $columnidFood TEXT, $columnnameFood TEXT, $columnprice TEXT, $columnamount TEXT, $columnsum TEXT)'),
        version: varsion);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(OrderSQLModel model) async {
    Database database = await connectedDatabase();
    try {
      await database
          .insert(
            nameTable,
            model.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
          .then((value) => print('##### Insert SQLite Success #####'));
    } catch (e) {
      print('e insertSQLite ==>> ${e.toString()}');
    }
  }

  Future<List<OrderSQLModel>> readDataFromSQLite() async {
    Database database = await connectedDatabase();
    List<OrderSQLModel> models = List();
    List<Map<String, dynamic>> maps = await database.query(nameTable);
    for (var map in maps) {
      OrderSQLModel model = OrderSQLModel.fromJson(map);
      models.add(model);
    }
    return models;
  }
}
