import 'package:flutter/material.dart';

class DeleteProduct extends StatefulWidget {
  static const String id = "deleteProduct";

  const DeleteProduct({super.key});

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('Delete Product')),
    );
  }
}
