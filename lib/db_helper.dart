import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'employee.dart';

class DBHelper {
  static Database _db;
  static const String ID = "id";
  static const String code = "code";

  static const String destination = "destination";
  static const String fraix = "fraix";
  static const String status = "status";
  static const String type = "type";

  static const String TABLE = "rasayel";
  static const String DB_NAME = "rasayel.db";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,code TEXT, destination TEXT,fraix TEXT,status TEXT,type TEXT,createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)");
  }

  Future<Employee> save(Employee employee) async {
    var dbClient = await db;
    var b = await dbClient.insert(TABLE, employee.toMap());
    employee.id = b;
    // print(employee.toMap());
    return employee;

    // await dbClient.transaction((txn) async{
    //   var query = "INSERT INTO $TABLE ($NAME) VALUES ('"+ employee.name +"')";
    //   return await txn.rawInsert(query);
    // });
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, code, destination, fraix, status, type]);
    var b = await dbClient.query(TABLE, columns: ["createdAt"]);
    print(b);
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Employee> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Employee.fromMap(maps[i]));
      }
    }

    return employees;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: "$ID = ?", whereArgs: [id]);
  }

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(),
        where: "$ID = ?", whereArgs: [employee.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
