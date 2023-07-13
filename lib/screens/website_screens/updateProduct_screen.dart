
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapllication/screens/website_screens/update_complete_product.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/products_model.dart';

class UpdateProductScreen extends StatelessWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);
  static const String id = "UpdateProduct";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                "Update Product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("NO DATA EXISTS"));
                }

                final data = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: ListTile(
                                title: Text(
                                    snapshot.data!.docs[index]['productName']),
                                trailing: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0,
                                      itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                    return UpdateCompleteScreen(
                                                      id: data[index].id,
                                                      products: Products(
                                                        brand: data[index]
                                                            ["brand"],
                                                        category: data[index]
                                                            ["category"],
                                                        id: id,
                                                        productName: data[index]
                                                            ["productName"],
                                                        detail: data[index]
                                                            ["detail"],
                                                        price: data[index]
                                                            ["price"],
                                                        discountPrice: data[index]
                                                            ["discountPrice"],
                                                        serialCode: data[index]
                                                            ["serialCode"],
                                                        imageUrls: data[index]
                                                            ["imageUrls"],
                                                        isSale: data[index]
                                                            ["isOnSale"],
                                                        isPopular: data[index]
                                                            ["isPopular"],
                                                        isFavourite: data[index]
                                                            ["isFavourite"],
                                                      ),
                                                    );
                                                  }));
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.edit),
                                                    Text('Edit'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: (context),
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Are You Sure To Delete?'),
                                                          content: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Products.deleteProduct(
                                                                      data[index]
                                                                          .id);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text(
                                                                    'Yes'),
                                                              ),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'))
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.delete),
                                                    Text('Delete'),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
