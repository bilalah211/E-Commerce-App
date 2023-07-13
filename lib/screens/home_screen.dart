import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapllication/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../models/category_model.dart';
import '../models/products_model.dart';
import '../widgets/carousel.dart';
import '../widgets/category_home_boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List images = [
    "https://cdn.pixabay.com/photo/2015/09/21/14/24/supermarket-949913_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/24/21/01/thermometer-1539191_960_720.jpg",
    "https://cdn.pixabay.com/photo/2015/09/21/14/24/supermarket-949913_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/24/21/01/thermometer-1539191_960_720.jpg",
  ];

  List<Products> allProducts = [];

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs.forEach((e) {
        if (e.exists) {
          setState(() {
            allProducts.add(
              Products(
                brand: e["brand"],
                category: e["category"],
                id: e['id'],
                productName: e["productName"],
                detail: e["detail"],
                price: e["price"],
                discountPrice: e["discountPrice"],
                serialCode: e["serialCode"],
                imageUrls: e["imageUrls"],
                isSale: e["isOnSale"],
                isPopular: e["isPopular"],
                isFavourite: e["isFavourite"],
              ),
            );
          });
        }
      });
    });
    print(allProducts[0].discountPrice);
  }

  @override
  void initState() {
    getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: RichText(
                        text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "E-Commerce ",
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Shop",
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ))),
              ),
              CategoryHomeBoxes(categories: categories),
              SizedBox(
                height: 3.h,
              ),
              Carousel(images: images),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              const Text(
                "Popular Items",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              allProducts.length == 0
                  ? CircularProgressIndicator(color: Colors.green.shade900)
                  : PopularItems(allProducts: allProducts),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.greenAccent),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "HOT \n SALES",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "NEW \n ARRIVALS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "TOP BRANDS",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Brands(allProducts: allProducts),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularItems extends StatelessWidget {
  const PopularItems({
    Key? key,
    required this.allProducts,
  }) : super(key: key);

  final List<Products> allProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .where((element) => element.isPopular == true)
            .map((e) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                          id: e.id,
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                e.imageUrls![0],
                                height: 80,
                                width: 80,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Text(e.productName!)),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class Brands extends StatelessWidget {
  const Brands({
    Key? key,
    required this.allProducts,
  }) : super(key: key);

  final List<Products> allProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      constraints: BoxConstraints(
        minWidth: 50,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .map((e) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 90,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.primaries[Random().nextInt(15)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              e.brand!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
