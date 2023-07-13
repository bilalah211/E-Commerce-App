import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
    required this.images,
  });

  final List images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: images
            .map((e) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          e,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.greenAccent.withOpacity(0.1),
                                Colors.pinkAccent.withOpacity(0.1)
                              ]))),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 22,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Products',
                            style: TextStyle(),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
            .toList(),
        options: CarouselOptions(height: 200, autoPlay: true));
  }
}
