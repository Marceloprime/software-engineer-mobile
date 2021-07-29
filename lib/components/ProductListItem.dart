import 'package:flutter/material.dart';
import 'package:confere/models/Product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  ProductListItem(this.product);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(children: <Widget>[
          product.imagem == 'none'
              ? Container(
                  width: 170,
                  height: 170,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text('Sem Imagem'),
                  ),
                )
              : Image(
                  image: NetworkImage(product.imagem), width: 170, height: 170),
        ]),
        Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 35),
                child: Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
            product.discountPercentage > 0.00
                ? Text('De R\$ ' + product.price.toString())
                : Text('R\$ ' + product.price.toString()),
            product.discountPercentage > 0.00
                ? Text('Por R\$ ' + product.promotionPrice.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
                : Container(),
            product.discountPercentage > 0.00
                ? Text(
                    'Desconto de ' +
                        product.discountPercentage.toString() +
                        '%',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            product.available == "true"
                ? Container(
                    child: Text(
                    'Produto disponível',
                    style: TextStyle(color: Colors.blue),
                  ))
                : Container(
                    child: Text('Produto indisponivel'),
                  )
          ],
        )
      ],
    );
  }
}
