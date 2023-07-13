import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  static const String id = "dashboard";

  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Dashboard')),
    );
  }
}
