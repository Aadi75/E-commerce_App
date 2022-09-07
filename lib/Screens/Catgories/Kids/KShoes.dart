// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:shopping_app/Utils/Constant.dart';

class KShoes extends StatefulWidget {
  const KShoes({Key key}) : super(key: key);

  @override
  State<KShoes> createState() => _KShoesState();
}

class _KShoesState extends State<KShoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Kids Shoes", style: TextStyle(color:Colors.black,fontSize: 25,
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
                itemCount: KidsShoes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.network(KidsShoes[index]['images'],
                          height: 100, width: 100),
                      Text(KidsShoes[index]['price'],
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