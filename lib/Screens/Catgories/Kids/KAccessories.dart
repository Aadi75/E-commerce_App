// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:shopping_app/Utils/Constant.dart';

class Accessories extends StatefulWidget {
  const Accessories({Key key}) : super(key: key);

  @override
  State<Accessories> createState() => _AccessoriesState();
}

class _AccessoriesState extends State<Accessories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Kids Accessories",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                constraints: BoxConstraints.expand(height: 200),
                child: imageSlider(context)),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                scrollDirection: Axis.vertical,
                itemCount: menAccessories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.network(menAccessories[index]['images'],
                          height: 100, width: 100),
                      Text(menAccessories[index]['price'],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {},
                          child: Text("Add To Cart",
                              style: TextStyle(color: Colors.white, fontSize: 15)))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

Swiper imageSlider(context) {
  return Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index) {
      return Image.asset(
          'assets/Images/discount.jpg');
    },
    itemCount: 5,
    viewportFraction: 0.7,
    scale: 0.8,
  );
}