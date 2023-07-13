import 'dart:io';
import 'package:ecommerceapllication/utils/utils.dart';
import 'package:ecommerceapllication/widgets/buttons.dart';
import 'package:ecommerceapllication/widgets/my_text_formfields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../models/category_model.dart';
import '../../models/products_model.dart';

class AddProduct extends StatefulWidget {
  static const String id = "addProductScreen";

  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final categoryC = TextEditingController();
  final idC = TextEditingController();
  final productNameC = TextEditingController();
  final detailC = TextEditingController();
  final priceC = TextEditingController();
  final discountPriceC = TextEditingController();
  final serialCodeC = TextEditingController();
  final brandC = TextEditingController();

  String? selectedValue;
  final imagePicker = ImagePicker();
  bool loading = false;
  List<XFile> images = [];
  List<String> imageUrls = [];
  bool isSaving = false;
  bool isUploading = false;
  bool isOnSale = false;
  bool isPopular = false;
  bool isFavourite = false;
  var uuid = Uuid();

  // List categories = [
  //   'Grocery',
  //   'Electronics',
  //   'Pharmacy',
  //   'Garments',
  //   'Cosmetics'
  // ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            children: [
              const Text(
                'Add Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            hintText: 'Choose Category',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: InputBorder.none),
                        value: selectedValue,
                        items: categories
                            .map((e) => DropdownMenuItem<String>(
                                value: e.title, child: Text(e.title!)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Stack(
                children: [
                  Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.pinkAccent.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.network(
                                    File(images[index].path).path,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 58,
                                  left: 58,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.black.withOpacity(0.5),
                                      )))
                            ],
                          );
                        }),
                  ),
                  Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green)),
                        child: TextButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                    TextStyle(color: Color(0xFF000000))),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () {
                              pickImage();
                            },
                            child: Text('Pick Images')),
                      )),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              SwitchListTile(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  title: const Text("Is this Product on Sale?"),
                  value: isOnSale,
                  onChanged: (v) {
                    setState(() {
                      isOnSale = !isOnSale;
                    });
                  }),
              SwitchListTile(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  title: const Text("Is this Product Popular?"),
                  value: isPopular,
                  onChanged: (v) {
                    setState(() {
                      isPopular = !isPopular;
                    });
                  }),
              SizedBox(
                height: 2.h,
              ),
              EcoTextFields(
                controller: productNameC,
                labelText: 'Enter Product Name',
              ),
              EcoTextFields(
                controller: idC,
                labelText: 'Enter Product Id',
              ),
              EcoTextFields(
                controller: priceC,
                labelText: 'Enter Price',
              ),
              EcoTextFields(
                controller: discountPriceC,
                labelText: 'Enter Product Discount',
              ),
              EcoTextFields(
                controller: detailC,
                labelText: 'Enter Product Details',

              ),
              EcoTextFields(
                controller: serialCodeC,
                labelText: 'Enter Product Serial Code',
              ),
              EcoTextFields(
                controller: brandC,
                labelText: 'Enter Product Brand',
              ),
              SizedBox(
                height: 2.h,
              ),
              Buttons(
                  loading: loading,
                  title: 'Upload Product',
                  onTap: () {
                    uploadImages();
                  }),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        )),
      ),
    );
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      productNameC.clear();
      categoryC.clear();
      priceC.clear();
      discountPriceC.clear();
      detailC.clear();
      brandC.clear();
      serialCodeC.clear();
      idC.clear();
    });
  }

  pickImage() async {
    final List<XFile> pickImage = await imagePicker.pickMultiImage();
    if (pickImage != null) {
      setState(() {
        images.addAll(pickImage);
      });
    } else {
      if (kDebugMode) {
        print("no Images Selected");
      }
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      loading = true;
    });
    String? urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        loading = false;
      });
      return urls;
    }
  }

  uploadImages() async {
    await uploadImage();
    await Products.addProducts(Products(
            category: selectedValue,
            id: uuid.v4(),
            brand: brandC.text,
            productName: productNameC.text,
            detail: detailC.text,
            price: int.parse(priceC.text),
            discountPrice: int.parse(discountPriceC.text),
            serialCode: serialCodeC.text,
            imageUrls: imageUrls,
            isSale: isOnSale,
            isPopular: isPopular,
            isFavourite: isFavourite))
        .whenComplete(() {
      setState(() {
        isSaving = false;
        imageUrls.clear();
        images.clear();
        clearFields();
        Utils.showMyDialogue('Product Upload Successfully');
      });
    });
  }

  uploadImage() async {
    for (var image in images) {
      await postImages(image).then((downLoadUrl) => imageUrls.add(downLoadUrl));
    }
  }
}
