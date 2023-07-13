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

class UpdateCompleteScreen extends StatefulWidget {
  String? id;
  Products? products;

  UpdateCompleteScreen({Key? key, this.id, this.products}) : super(key: key);

  @override
  State<UpdateCompleteScreen> createState() => _UpdateCompleteScreenState();
}

class _UpdateCompleteScreenState extends State<UpdateCompleteScreen> {
  TextEditingController categoryC = TextEditingController();
  TextEditingController idC = TextEditingController();
  TextEditingController productNameC = TextEditingController();
  TextEditingController detailC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController discountPriceC = TextEditingController();
  TextEditingController serialCodeC = TextEditingController();
  TextEditingController brandC = TextEditingController();

  bool isOnSale = false;
  bool isPopular = false;
  bool isFavourite = false;

  String? selectedValue = "";
  bool isSaving = false;
  bool isUploading = false;

  final imagePicker = ImagePicker();
  List<XFile> images = [];
  List<dynamic> imageUrls = [];
  var uuid = const Uuid();

  @override
  void initState() {
    selectedValue = widget.products!.category!;
    productNameC.text = widget.products!.productName!;
    detailC.text = widget.products!.detail!;
    priceC.text = widget.products!.price!.toString();
    discountPriceC.text = widget.products!.discountPrice!.toString();
    serialCodeC.text = widget.products!.serialCode!;
    isOnSale = widget.products!.isSale!;
    isPopular = widget.products!.isPopular!;
    brandC.text = widget.products!.brand.toString();
    super.initState();
  }

  // List categories = [
  //   'Grocery',
  //   'Electronics',
  //   'Pharmacy',
  //   'Garments',
  //   'Cosmetics'
  // ];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              children: [
                const Text(
                  'Update Product',
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
                          itemBuilder: (context, int index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:
                                            Colors.pinkAccent.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.network(
                                      File(images[index].path).path,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 1,
                                    right: 25,
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
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          const TextStyle(color: Color(0xFF000000))),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () {
                                pickImage();
                              },
                              child: const Text('Pick Images')),
                        )),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: widget.products!.imageUrls!
                      .map((e) => Stack(
                    children: [
                      Image.network(
                        e,
                        height: 10.h,
                        width: 10.w,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.products!.imageUrls!.removeAt(e);
                                });
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.black.withOpacity(0.5),
                              )))

                    ],
                  ))
                      .toList(),
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
                      uploadsImages();
                    }),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  uploadsImages() async {
    setState(() {
      loading = true;
    });
    await uploadImages();
    await Products.updateProducts(
        widget.id!,
        Products(
          brand: brandC.text,
          category: selectedValue,
          id: widget.id!,
          productName: productNameC.text,
          detail: detailC.text,
          price: int.parse(priceC.text),
          discountPrice: int.parse(discountPriceC.text),
          serialCode: serialCodeC.text,
          imageUrls: imageUrls,
          isSale: isOnSale,
          isPopular: isPopular,
          isFavourite: isFavourite,
        )).whenComplete(() {
      setState(() {
        imageUrls.clear();
        images.clear();
        clearFields();
        Utils.showMyDialogue('Update Successfully');
      });
    });
    // await FirebaseFirestore.instance
    //     .collection("products")
    //     .add({"images": imageUrls}).whenComplete(() {
    //   setState(() {
    //     isSaving = false;
    //     images.clear();
    //     imageUrls.clear();
    //   });
    // });
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      productNameC.clear();
    });
  }

  pickImage() async {
    final List<XFile>? pickImage = await imagePicker.pickMultiImage();
    if (pickImage != null) {
      setState(() {
        images.addAll(pickImage);
      });
    } else {
      print("no images selected");
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
    for (var image in images) {
      await postImages(image).then((downLoadUrl) => imageUrls.add(downLoadUrl));
    }
    imageUrls.addAll(widget.products!.imageUrls!);
  }
}
