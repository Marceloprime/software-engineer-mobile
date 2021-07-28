import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import '../models/Product.dart';

class DB {
  var _database;

  Future<dynamic> init() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    // Open the database and store the reference.
    _database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, imagem TEXT,price DOUBLE,promotionPrice DOUBLE,discountPercentage DOUBLE ,available BOOLEAN )',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insert(Product product) async {
    // Get a reference to the database.
    final db = await _database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Product>> products() async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('products');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      print(maps[i]);
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imagem: maps[i]['imagem'],
        price: maps[i]['price'],
        promotionPrice: maps[i]['promotionPrice'],
        discountPercentage: maps[i]['discountPercentage'],
        available: maps[i]['available'],
      );
    });
  }

  Future<void> update(Product product) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given Dog.
    await db.update(
      'products',
      product.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [product.id],
    );
  }

  Future<void> delete(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Dog from the database.
    await db.delete(
      'products',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
