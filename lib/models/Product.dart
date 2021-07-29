import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Product {
  final String id;
  final String name;
  final String imagem;
  final double price;
  final double promotionPrice;
  final double discountPercentage;
  final String available;

  Product(
      {required this.id,
      required this.name,
      required this.imagem,
      required this.price,
      required this.promotionPrice,
      required this.discountPercentage,
      required this.available});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagem': imagem,
      'price': price,
      'promotionPrice': promotionPrice,
      'discountPercentage': discountPercentage,
      'available': available
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Product{id: $id, name: $name, imagem: $imagem, price: $price, promotionPrice: $promotionPrice, discountPercentage: $discountPercentage, available: $available}';
  }
}
