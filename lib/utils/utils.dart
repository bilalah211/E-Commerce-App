import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static myFocusNode(
      context,
      FocusNode current,
      FocusNode next,
      ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static showMyDialogue(String title) {
    Fluttertoast.showToast(msg: title);
  }
}
