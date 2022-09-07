// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Cart",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Lottie.asset("assets/Images/404.json")],
        ),
      ),
    );
  }
}
