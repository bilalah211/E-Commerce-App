import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String? title;
  const HomeCard({
    super.key, this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Colors.greenAccent.withOpacity(0.8),
                Colors.pinkAccent.withOpacity(0.8)
              ])),
          child: Center(
            child: Text("$title",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}
