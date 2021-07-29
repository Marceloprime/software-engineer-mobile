import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'dart:math';
import '../database/db.dart';
import '../models/Product.dart';

class BlocsDatabase {
  final DB database;
  BlocsDatabase(this.database);

  List<Product> _currentList = [];
  List<Product> get currentList => _currentList;
  final _blocController = StreamController<List<Product>>();
  Stream<List<Product>> get productStream => _blocController.stream;

  retrive() async {
    List<Product> products = await this.database.products();
    products.sort((a, b) => a.name.compareTo(b.name));
    _currentList = products;
    _blocController.sink.add(_currentList);
  }

  insert(nameInput, priceInput, promotionPriceInput, discountPercentageInput,
      availableInput) async {
    Random random = new Random();
    var number = random.nextInt(100000000).toString();
    var bytes = utf8.encode(number);
    var hash = sha1.convert(bytes).toString();
    Product product = new Product(
        id: hash,
        name: nameInput,
        imagem: 'none',
        price: double.parse(priceInput),
        promotionPrice: double.parse(promotionPriceInput),
        discountPercentage: double.parse(discountPercentageInput),
        available: availableInput.toString());
    await this.database.insert(product);
    retrive();
  }

  update(Product product) async {
    await this.database.update(product);
  }

  delete(id) async {
    await this.database.delete(id);
    retrive();
  }

  closeStream() {
    _blocController.close();
  }
}
