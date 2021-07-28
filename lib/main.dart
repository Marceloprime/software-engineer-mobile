import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:product_manager/models/Product.dart';
import 'package:sqflite/sqflite.dart';
import './database/db.dart';
import 'ui/list.dart';

class Confere extends StatelessWidget {
  final List<Product> listProduct;

  Confere(this.listProduct);

  @override
  Widget build(BuildContext context) {
    try {
      for (Product item in this.listProduct) {
        print('///////////');
        print(item);
      }
    } catch (e) {
      print(e);
    }
    print(this.listProduct[1].name);
    return MaterialApp(
        title: 'Confere',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Confere'),
              centerTitle: true,
              backgroundColor: Colors.lightBlue,
            ),
            body: ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: this.listProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 5),
                    color: Colors.blueAccent,
                    child: Center(
                        child: Text(
                      this.listProduct[index].name,
                    )),
                  );
                })));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DB database = new DB();
  await database.init();
  await database.products();
  Product p = new Product(
      id: 2,
      name: 'Notebook',
      imagem: 'imagem',
      price: 2000.00,
      promotionPrice: 1899.99,
      discountPercentage: 0.2,
      available: "true");
  await database.insert(p);
  await database.products();
  var prods = await database.products();
  var fun = database.insert;
  runApp(Confere(prods));
}
