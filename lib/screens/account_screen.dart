import 'package:film_ku/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sedang di garap... Tunggu di part ke 2', style: kTitleStyle),
            Text('By: Block 7 Code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: HexColor('#FFFFFF').withOpacity(0.87),
                )),
          ],
        ),
      ),
    );
  }
}
