// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:io';
import 'package:user_list/Models/user_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'myDatabase.db';
  static const _dbVersion = 1;
  static const _tableName = 'myTable';

  static const columId = 'id';
  static const columnfirstName = 'first_name';
  static const columnlastName = 'last_name';
  static const columnemail = 'email';
  static const columnbio = 'bio';
  static const columnIsFavourite = "isFavourite";

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();

    return _database!;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) => db.execute('''
      CREATE TABLE $_tableName (
        $columId TEXT PRIMARY KEY,
        $columnfirstName TEXT NOT NULL,
        $columnlastName TEXT NOT NULL,
        $columnemail TEXT NOT NULL,
        $columnbio TEXT NULL,
        $columnIsFavourite INTEGER NULL)
        ''');
  Future<void> insert(List<UserElement> userElementList) async {
    Database db = await database;
    for (var i = 0; i < userElementList.length; i++) {
      db.insert(_tableName, {
        columId: i,
        columnfirstName: userElementList[i].firstName,
        columnlastName: userElementList[i].lastName,
        columnemail: userElementList[i].email,
        columnbio: userElementList[i].bio,
        columnIsFavourite: userElementList[i].isFavourite,
      });
      print("UserElement ${userElementList[i].toJson()}");
      print("UserElement ${userElementList[i].firstName}");
    }
    List<UserElement> userList = await getAllUserElement();
    print("inserted List $userList");
  }

  Future<List<UserElement>> deleteAllUserElement() async {
    final db = await database;
    final result = await db.delete(_tableName);
    final userList = getAllUserElement();
    return userList;
  }

  Future<int> update(UserElement user) async {
    Database db = await database;
    return await db.update(_tableName, user.toMap(),
        where: '$columId = ?', whereArgs: [user.id]);
  }

  Future<List<UserElement>> search(String? value) async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE $columnfirstName LIKE '%$value%'OR $columnlastName LIKE '%$value%'");
    List<UserElement> list = result.isNotEmpty
        ? result.map((x) => UserElement.fromJson(x)).toList()
        : [];

    return list;
  }

  Future<List<UserElement>> getAllUserElement() async {
    final db = await database;
    final result = await db.query(_tableName);
    List<UserElement> list = result.isNotEmpty
        ? result.map((x) => UserElement.fromJson(x)).toList()
        : [];
    return list;
  }

  Future<List<UserElement>> favourite() async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE $columnIsFavourite LIKE '%1%'");
    List<UserElement> list = result.isNotEmpty
        ? result.map((x) => UserElement.fromJson(x)).toList()
        : [];

    return list;
  }
}
