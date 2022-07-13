import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseConnection{
  Future<Database>setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_crud');
    var database =
    await openDatabase(path, version: 2, onCreate: _createDatabase);
    return database;
  }
  Future<void>_createDatabase(Database database, int version) async {
    String sql=
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,fName TEXT,lName TEXT,"
        "contact Text,Email TEXT, dob TEXT,createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);";
    await database.execute(sql);
  }
}