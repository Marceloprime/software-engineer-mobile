import 'package:flutter/material.dart';

class TitleConfere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image(
          width: 200,
          height: 200,
          image: NetworkImage(
              'https://www.conferecartoes.com.br/hubfs/logo-209.png'),
        ),
      ],
    );
  }
}
