import 'package:ecommerceapllication/screens/website_screens/addProuduct_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/cartItem_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/dashboard_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/deleteProdut_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/updateProduct_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class WebMainScreen extends StatefulWidget {
  static const String id = "webMainScreen";

    const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  Widget selectedScreen =  const DashBoard();


  chooseScreen(item) {
    switch (item.route) {
      case DashBoard.id:
        setState(() {
          selectedScreen =  const DashBoard();
        });
        break;
      case AddProduct.id:
        setState(() {
          selectedScreen = const AddProduct();
        });
        break;
      case UpdateProductScreen.id:
        setState(() {
          selectedScreen = UpdateProductScreen();
        });
        break;
      case DeleteProduct.id:
        setState(() {
          selectedScreen = const DeleteProduct();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.withOpacity(0.2),
        centerTitle: true,
        title: const Text(
          'Admin Screen',
        ),
      ),
      sideBar: SideBar(
        backgroundColor: Colors.green.withOpacity(0.3),
          textStyle: const TextStyle(color: Colors.black),
          borderColor: Colors.black,
          onSelected: (item){
            chooseScreen(item);
          },
          items: [
        const AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: DashBoard.id),
        const AdminMenuItem(
            title: 'Add Products',
            icon: Icons.add,
            route: AddProduct.id),
        const AdminMenuItem(
            title: 'Update Products',
            icon: Icons.update,
            route: UpdateProductScreen.id),
        const AdminMenuItem(
            title: 'Delete Products',
            icon: Icons.delete,
            route: DeleteProduct.id),
        AdminMenuItem(
            title: 'Cart Items',
            icon: Icons.shopping_cart,
            route: const CartItem().toString()),
      ], selectedRoute: const WebMainScreen().toString()),
      body: selectedScreen,
    );
  }
}
