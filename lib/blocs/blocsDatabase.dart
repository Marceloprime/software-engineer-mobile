import 'dart:async';

import '../database/db.dart';
import '../models/Product.dart';

class BlocsDatabase {
  DB _database = new DB();
  DB get db => _database;
  final controller = new StreamController();
  Stream get dataStream => controller.stream;

  Future<dynamic> init() async {
    db.init();
  }

  Future<void> create() async {
    Product p = new Product(
        id: 3,
        name: 'A Notebook',
        imagem: 'imagem',
        price: 2000.00,
        promotionPrice: 1899.99,
        discountPercentage: 0.2,
        available: "true");
    try {
      await db.insert(p);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Product>> retrive() async {
    List<Product> products = await _database.products();
    print(products);
    return products;
  }

  update() {}

  delete() {}

  closeStream() {
    controller.close();
  }
}
