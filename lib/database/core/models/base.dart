import 'package:sqflite/sqflite.dart';

import'../../init.dart';

class DatabaseModel {

  String table;
  String pk = 'id';

  ConflictAlgorithm _conflictAlgorithm = ConflictAlgorithm.replace;
  String _where;
  String _order;
  List<dynamic> _whereArgs = [];
  List<String> _select = ['*'];


  constructModel() {
    return new DatabaseModel();
  }

  Map<String, dynamic> toMap() {
    throw new Exception('Not implemented');
  }

  loadFromMap(Map<String, dynamic> map){
    throw new Exception('Not implemented');
  }

  store() async {
    var database = await db.open();

    await database.insert(
        this.table,
        this.toMap(),
        conflictAlgorithm: this._conflictAlgorithm
    );
    print("Stored!");
  }

  delete() async {
    var database = await db.open();
    await database.delete(
        this.table,
        // Use a `where` clause to delete a specific dog.
        where: this._where,
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: this._whereArgs
    );
  }

  remove() async {
    var database = await db.open();
    await database.delete(
        this.table,
        // Use a `where` clause to delete a specific dog.
        where: this.pk +" = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [this.toMap()[this.pk]]
    );
  }

  where(String condition, List<dynamic> args) {
    this._where = condition;
    this._whereArgs = args;

    return this;
  }

  andWhere(String condition, List<dynamic> args) {
    this._where += " AND " + condition;
    for (var argument in args) {
      this._whereArgs.add(argument);
    }

    return this;
  }

  select(List<String> columns) {
    this._select = columns;

    return this;
  }

  find() async {
    var database = await db.open();
    var result = await database.query(
        this.table,
        columns:this._select,
        where: this._where,
        whereArgs: this._whereArgs,
        orderBy: this._order,
    );

    return List.generate(result.length, (i) {
      var model = this.constructModel();
      return model.loadFromMap(result[i]);
    });
  }

  all() async {
    var database = await db.open();
    var result = await database.query(
        this.table,
        columns:this._select,
        orderBy: this._order,
    );

    return List.generate(result.length, (i) {
      var model = this.constructModel();
      return model.loadFromMap(result[i]);
    });
  }

  order(String order) {
    this._order = order;
    return this;
  }
}