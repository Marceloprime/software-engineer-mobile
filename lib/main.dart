import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path/path.dart';
import 'package:confere/database/db.dart';
import 'package:confere/models/Product.dart';
import 'package:sqflite/sqflite.dart';
import './blocs/blocsDatabase.dart';

DB database = new DB();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  await database.products();
  Product p = new Product(
      id: '3',
      name: 'A Notebook',
      imagem:
          'https://images-shoptime.b2w.io/produtos/01/00/img/3081358/8/3081358804_1GG.jpg',
      price: 2000.00,
      promotionPrice: 1899.99,
      discountPercentage: 0.2,
      available: "true");
  await database.insert(p);
  await database.products();
  var prods = await database.products();
  print(database.products());
  runApp(ConfereApp(prods));
}

class ConfereApp extends StatelessWidget {
  final List<Product> listProduct;
  ConfereApp(this.listProduct);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confere',
      debugShowCheckedModeBanner: false,
      home: HomePage(listProduct),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Product> listProduct;
  HomePage(this.listProduct);
  @override
  _HomePageState createState() => _HomePageState(this.listProduct);
}

class _HomePageState extends State<HomePage> {
  BlocsDatabase bloc = BlocsDatabase(database);
  final List<Product> listProduct;
  _HomePageState(this.listProduct);

  @override
  Widget build(BuildContext context) {
    String nameProduct = '';
    String price = '';
    String promotionPrice = '';
    String discountPercentage = '';
    bool available = false;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image(
              width: 200,
              height: 200,
              image: NetworkImage(
                  'https://www.conferecartoes.com.br/hubfs/logo-209.png'),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: StreamBuilder<List<Product>>(
            stream: bloc.productStream,
            initialData: [],
            builder: (context, snapshot) {
              bloc.retrive();
              if (snapshot.hasError) {
                return Text('Há um erro na Stream');
              } else {
                //print(snapshot.data);
                return snapshot.data!.length > 0
                    ? ListView.builder(
                        padding: const EdgeInsets.all(4),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          //print(snapshot.data!.length);
                          //print(snapshot.data!.length);
                          return Slidable(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.green),
                                )),
                                height: 180,
                                margin: const EdgeInsets.only(bottom: 5),
                                color: Colors.lightBlueAccent[40],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(children: <Widget>[
                                      snapshot.data![index].imagem == 'none'
                                          ? Container(
                                              width: 170,
                                              height: 170,
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Text('Sem Imagem'),
                                              ),
                                            )
                                          : Image(
                                              image: NetworkImage(
                                                  snapshot.data![index].imagem),
                                              width: 170,
                                              height: 170),
                                    ]),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 35),
                                            child: Text(
                                              snapshot.data![index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )),
                                        snapshot.data![index]
                                                    .discountPercentage >
                                                0.00
                                            ? Text('De R\$ ' +
                                                snapshot.data![index].price
                                                    .toString())
                                            : Text('R\$ ' +
                                                snapshot.data![index].price
                                                    .toString()),
                                        snapshot.data![index]
                                                    .discountPercentage >
                                                0.00
                                            ? Text(
                                                'Por R\$ ' +
                                                    snapshot.data![index]
                                                        .promotionPrice
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red))
                                            : Container(),
                                        snapshot.data![index]
                                                    .discountPercentage >
                                                0.00
                                            ? Text(
                                                'Desconto de ' +
                                                    snapshot.data![index]
                                                        .discountPercentage
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            : Container(),
                                        snapshot.data![index].available ==
                                                "true"
                                            ? Container(
                                                child: Text(
                                                'Produto disponível',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ))
                                            : Container(
                                                child: Text(
                                                    'Produto indisponivel'),
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.50,
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Apagar produto',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    bloc.delete(snapshot.data![index].id);
                                    final message = SnackBar(
                                        content: Container(
                                      color: Colors.green,
                                      child: Text('Deletado com sucesso'),
                                    ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(message);
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Atualizar',
                                  color: Colors.blue,
                                  icon: Icons.update,
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: Colors.greenAccent,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Nome do produto',
                                                    ),
                                                    onChanged: (Text) {
                                                      setState(() {
                                                        nameProduct = Text;
                                                      });
                                                    },
                                                  ),
                                                  TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Preço',
                                                    ),
                                                    onChanged: (Text) {
                                                      setState(() {
                                                        price = Text;
                                                      });
                                                    },
                                                  ),
                                                  TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Preço promocional',
                                                    ),
                                                    onChanged: (Text) {
                                                      setState(() {
                                                        promotionPrice = Text;
                                                      });
                                                    },
                                                  ),
                                                  TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Percentual de desconto (Sem o %)',
                                                    ),
                                                    onChanged: (Text) {
                                                      setState(() {
                                                        discountPercentage =
                                                            Text;
                                                      });
                                                    },
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text('Disponivel'),
                                                      Checkbox(
                                                          value: available,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (value ==
                                                                      false ||
                                                                  value ==
                                                                      null) {
                                                                available =
                                                                    false;
                                                              } else {
                                                                available =
                                                                    true;
                                                              }
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    child:
                                                        const Text('Atualizar'),
                                                    onPressed: () async {
                                                      Product product = new Product(
                                                          id: snapshot
                                                              .data![index].id,
                                                          name: nameProduct == ''
                                                              ? snapshot
                                                                  .data![index]
                                                                  .name
                                                              : nameProduct,
                                                          imagem: snapshot
                                                              .data![index]
                                                              .imagem,
                                                          price: price == ''
                                                              ? snapshot
                                                                  .data![index]
                                                                  .price
                                                              : double.parse(price
                                                                  .replaceAll(
                                                                      ',', '.')),
                                                          promotionPrice: promotionPrice == ''
                                                              ? snapshot
                                                                  .data![index]
                                                                  .promotionPrice
                                                              : double.parse(
                                                                  promotionPrice.replaceAll(
                                                                      ',', '.')),
                                                          discountPercentage:
                                                              discountPercentage == ''
                                                                  ? snapshot
                                                                      .data![index]
                                                                      .discountPercentage
                                                                  : double.parse(discountPercentage.replaceAll(',', '.')),
                                                          available: available.toString() == '' ? snapshot.data![index].available : available.toString());
                                                      try {
                                                        await bloc
                                                            .update(product);
                                                        await bloc.retrive();
                                                        final message =
                                                            SnackBar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                content:
                                                                    Container(
                                                                  child: Text(
                                                                      'Atualizado com Sucesso'),
                                                                ));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                message);

                                                        Navigator.pop(context);
                                                      } catch (e) {
                                                        final message =
                                                            SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content:
                                                                    Container(
                                                                  child: Text(
                                                                      'Campos inválidos'),
                                                                ));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                message);
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ]);
                        })
                    : const Center(
                        child: Text('Não há produtos'),
                      );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  color: Colors.greenAccent,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nome do produto',
                          ),
                          onChanged: (Text) {
                            setState(() {
                              nameProduct = Text;
                            });
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Preço',
                          ),
                          onChanged: (Text) {
                            setState(() {
                              price = Text;
                            });
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Preço promocional',
                          ),
                          onChanged: (Text) {
                            setState(() {
                              promotionPrice = Text;
                            });
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Percentual de desconto (Sem o %)',
                          ),
                          onChanged: (Text) {
                            setState(() {
                              discountPercentage = Text;
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text('Disponivel'),
                            Checkbox(
                                value: available,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == false || value == null) {
                                      available = false;
                                    } else {
                                      available = true;
                                    }
                                  });
                                })
                          ],
                        ),
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: () async {
                            try {
                              await bloc.insert(
                                  nameProduct,
                                  price.replaceAll(',', '.'),
                                  promotionPrice.replaceAll(',', '.'),
                                  discountPercentage.replaceAll(',', '.'),
                                  available);
                              await bloc.retrive();
                              final message = SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Container(
                                    child: Text('Produto criado com sucesso'),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(message);
                            } catch (e) {
                              final message = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Container(
                                    child: Text('Campos inválidos'),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(message);
                            }
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    bloc.closeStream();
    super.dispose();
  }
}
