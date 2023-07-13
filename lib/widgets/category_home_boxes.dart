import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../screens/product_screen.dart';

class CategoryHomeBoxes extends StatelessWidget {
  const CategoryHomeBoxes({
    super.key,
    required this.categories,
  });

  final List categories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
              categories.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductScreen();
                              }));
                            },
                            child: Container(
                              height: 12.h,
                              width: 17.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "${categories[index].image}")),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       spreadRadius: 3,
                                  //       blurRadius: 3,
                                  //       color:
                                  //       Colors.black.withOpacity(0.8))
                                  // ]
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            categories[index].title!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
