import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import '../models/Product.dart';

class DB {
  var _database;

  Future<dynamic> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        return await db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, imagem TEXT,price DOUBLE,promotionPrice DOUBLE,discountPercentage DOUBLE ,available BOOLEAN )',
        );
      },
      version: 1,
    );
  }

  Future<void> insert(Product product) async {
    final db = await _database;

    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> products() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
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
    final db = await _database;

    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database;

    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
