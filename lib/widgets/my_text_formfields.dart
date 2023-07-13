import 'package:flutter/material.dart';

class EcoTextFields extends StatelessWidget {
  final title;
  final labelText;
  final prefixIcon;
  final Widget? Icon;
  final TextEditingController? controller;
  final bool isPassword;
  final focusNode;
  final validator;

  const EcoTextFields({
    super.key,
    this.isPassword = false,
    this.controller,
    this.title,
    this.labelText,
    this.Icon,
    this.prefixIcon,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        obscureText: isPassword,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            hintText: title,
            prefixIcon: prefixIcon,
            suffixIcon: Icon,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
            labelText: labelText,
            labelStyle:TextStyle(color: Colors.black.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
        fillColor: Colors.grey.withOpacity(0.3)),
      ),
    );
  }
}
