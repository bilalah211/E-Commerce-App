import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapllication/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../models/products_model.dart';
import '../widgets/header.dart';

class ProductScreen extends StatefulWidget {
  // const ProductScreen({Key? key}) : super(key: key);
  String? category;
  ProductScreen({this.category});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Products> allProducts = [];
  TextEditingController sC = TextEditingController();

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      if (widget.category == null) {
        snapshot!.docs.forEach((e) {
          if (e.exists) {
            setState(() {
              allProducts.add(
                Products(
                  id: e["id"],
                  productName: e["productName"],
                  imageUrls: e["imageUrls"],
                ),
              );
            });
          }
        });
      } else {
        snapshot!.docs
            .where((element) => element["category"] == widget.category)
            .forEach((e) {
          if (e.exists) {
            for (var item in e['imagesUrls']) {
              if (item.isNotEmpty) {
                setState(() {
                  allProducts.add(
                    Products(
                      id: e["id"],
                      productName: e["productName"],
                      imageUrls: e["imageUrls"],
                    ),
                  );
                });
              }
            }
          }
        });
      }
    });
    // print(allProducts[0].discountPrice);
  }

  List<Products> totalItems = [];

  @override
  void initState() {
    getDate();
    Future.delayed(const Duration(seconds: 1), () {
      totalItems.addAll(allProducts);
    });

    super.initState();
  }

  filterData(String query) {
    List<Products> dummySearch = [];
    dummySearch.addAll(allProducts);
    if (query.isNotEmpty) {
      List<Products> dummyData = [];
      dummySearch.forEach((element) {
        if (element.productName!.toLowerCase().contains(query.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        allProducts.clear();
        allProducts.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        allProducts.clear();

        allProducts.addAll(totalItems);
      });
      // return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: Header(
            title: "${widget.category ?? "ALL PRODUCTS"}",
          ),
          preferredSize: Size.fromHeight(5.h)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 50,
              child: TextFormField(
                controller: sC,
                onChanged: (v) {
                  filterData(sC.text);
                },
                decoration: InputDecoration(
                  hintText: "Search Products Here...",
                  prefixIcon: const Icon(Icons.search_outlined),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2)),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: allProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                                  id: allProducts![index].id,
                                )));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Image.network(
                                allProducts[index].imageUrls!.last,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(
                            allProducts[index].productName!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
