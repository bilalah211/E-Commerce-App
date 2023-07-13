import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const Buttons({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.green.shade800,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2))),
      ),
    );
  }
}
