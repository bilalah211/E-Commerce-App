import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  String? title;
  Header({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title!,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
