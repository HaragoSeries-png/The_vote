import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName ='Thevote_db';
  static final _databaseVersion=1;

  static final cardtable = 'cardtable';
  static final carddatatable = 'carddatatable';
  
  static final columnID ='id';
  static final columndata = 'columndata';
  static final columnCardname='columnCardname';

  static final parentid = 'parentid';
  static final columnCarddata='columnCarddata';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instace = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async{
    print('database get');
    if(_database != null){
      return _database;
    };
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
    print('create');
    await db.execute('''
      create table $cardtable(
        $columnID integer primary key autoincrement,
        $columnCardname text not null
      )
    ''');
    await db.execute('''
      create table $carddatatable(
        $columnID integer primary key autoincrement,
        $parentid integer,
        $columnCarddata text not null
      )
    ''');
  }

  Future<int> insertdata(Map<String,dynamic> row)async{
    print(row.toString());
    Database db = await instace.database;
    return await db.insert('carddatatable', row);
  }

  Future<int> createcard(Map<String,dynamic> row)async{
    Database db = await instace.database;
    print(row);
    
    return await db.insert('cardtable', row);;
  }

  Future<int> queryRowCount() async{
    Database db = await instace.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('select count(*) from @$cardtable')
    );
  }
  Future<List<Map<String, dynamic>>> queryAll() async{
    Database db = await instace.database;
    
    List<Map<String,dynamic>> myQueryList = await db.rawQuery('select * from carddatatable');
    print(myQueryList.toString());
    return myQueryList;
  }
  Future<List<Map<String,dynamic>>> getcarddata(int cardid) async{
    Database db = await instace.database;
    print('parent id :'+cardid.toString());
    List<Map<String,dynamic>> myQueryList = await db.rawQuery('select columnCarddata from carddatatable where parentid = $cardid');
    print('qre '+ myQueryList.toString());
    return myQueryList;
  }
  Future<List<Map<String, dynamic>>> getcardlist() async{
    print('getlist');
    Database db = await instace.database;
    List<Map<String,dynamic>> myQueryList = await db.rawQuery('select * from cardtable ');
    print(myQueryList.toString());
    return myQueryList;
  }
  Future<int> delete(int row)async{
    Database db = await instace.database;   
    return await db.delete(cardtable,where:'$columnID = ?',whereArgs: [row]);
  }
  Future<int> deletecarddata(int row)async{
    Database db = await instace.database;   
    return await db.delete(carddatatable,where:'$parentid = ?',whereArgs: [row]);
  }

}