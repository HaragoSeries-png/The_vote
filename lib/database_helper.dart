import 'dart:io';
import 'dart:js';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName ='';
  static final _databaseVersion=1;

  static final table = 'my_db';
  static final columnID ='id';
  static final columndata = 'text';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instace = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null)return _database;
    _database = await _initDatabase();
    return _database;
  }
  _initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,_databaseName);
    return await openDatabase(
      path,
      version:_databaseVersion,
      onCreate:_onCreate
    );
    
  }
  Future _onCreate(Database db,int version)async{
    await db.execute('''
      create table $table(
        $columnID integer primary key autoincrement,
        $columndata text not null
      )
    ''');
  }

  Future<int> insertdata(Map<String,dynamic> row)async{
    Database db = await instace.database;
    return await db.insert(table, row);
  }

  Future<int> queryRowCount() async{
    Database db = await instace.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('select count(*) from @$table')
    );
  }
  Future<List<Map<String, dynamic>>> queryAll() async{
    Database db = await instace.database;
    List<Map<String,dynamic>> myQueryList = await db.rawQuery('select * from $table');
    return myQueryList;
  }

  Future<int> delete(int row)async{
    Database db = await instace.database;
    return await db.delete(table,where:'$columnID = ?',whereArgs: [row]);
  }

}