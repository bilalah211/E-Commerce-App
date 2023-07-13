import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapllication/widgets/my_text_formfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/buttons.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // const ProfileScreen({Key? key}) : super(key: key);
  String? profilePic;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController houseC = TextEditingController();
  TextEditingController streetC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? downloadUrl;
  bool selection = false;
  bool loading = false;

  // String? buttonText;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please complete profile firstly')));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          nameC.text = snapshot['name'];
          phoneC.text = snapshot['phone'];
          houseC.text = snapshot['house'];
          cityC.text = snapshot['city'];
          streetC.text = snapshot['street'];
          addressC.text = snapshot['address'];
          profilePic = snapshot['profilePic'];
        });
      }
    });
    super.initState();
  }

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "PROFILE",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                        );
                        if (pickImage != null) {
                          setState(() {
                            profilePic = pickImage.path;
                            selection = true;
                          });
                        }
                      },
                      child: Container(
                        child: profilePic == null
                            ? CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.deepPurple,
                                child: Image.asset(
                                  'assets/c_images/add_pic.png',
                                  height: 80,
                                  width: 80,
                                ),
                              )
                            : profilePic!.contains('http')
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundImage: NetworkImage(profilePic!),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                        FileImage(File(profilePic!)),
                                  ),
                      ),
                    ),
                  ),
                  EcoTextFields(
                    labelText: "Enter Complete Name",
                    controller: nameC,
                  ),
                  EcoTextFields(
                    labelText: "Enter Phone Number",
                    controller: phoneC,
                  ),
                  EcoTextFields(
                    labelText: "Enter House No",
                    controller: houseC,
                  ),
                  EcoTextFields(
                    labelText: "Enter Street ",
                    controller: streetC,
                  ),
                  EcoTextFields(
                    labelText: "Enter City",
                    controller: cityC,
                  ),
                  EcoTextFields(
                    labelText: "Enter Complete Address",
                    controller: addressC,
                  ),
                  Buttons(
                    title: nameC.text.isEmpty ? 'SAVE' : 'Update',
                    loading: loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        SystemChannels.textInput.invokeMapMethod(
                            'TextInput.hide'); // hides keyboard
                        profilePic == null
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Select Profile Image')))
                            : nameC.text.isEmpty
                                ? saveInfo()
                                : update();
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.green.shade700, width: 3)),
                    child: TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(File filepath, String? reference) async {
    try {
      final finalName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';
      final Reference fbStorage =
          FirebaseStorage.instance.ref(reference).child(finalName);
      final UploadTask uploadTask = fbStorage.putFile(filepath);
      await uploadTask.whenComplete(() async {
        downloadUrl = await fbStorage.getDownloadURL();
      });

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  update() {
    setState(() {
      isSaving = true;
    });
    if (selection == true) {
      uploadImage(File(profilePic!), 'profile').whenComplete(() {
        Map<String, dynamic> data = {
          'name': nameC.text,
          'phone': phoneC.text,
          'house': houseC.text,
          'street': streetC.text,
          'city': cityC.text,
          'address': addressC.text,
          'profilePic': downloadUrl,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data)
            .whenComplete(() {
          FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
          setState(() {
            isSaving = false;
          });
        });
      });
    } else {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'phone': phoneC.text,
        'house': houseC.text,
        'street': streetC.text,
        'city': cityC.text,
        'address': addressC.text,
        'profilePic': profilePic,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    }
  }

  saveInfo() {
    setState(() {
      isSaving = true;
    });
    uploadImage(File(profilePic!), 'profile').whenComplete(() {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'phone': phoneC.text,
        'house': houseC.text,
        'street': streetC.text,
        'city': cityC.text,
        'address': addressC.text,
        'profilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    });
  }
}
