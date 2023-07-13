import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static Future<DocumentSnapshot> adminSignIn(id) async {
    var result = FirebaseFirestore.instance.collection("admin").doc(id).get();
    return result;
  }
}
