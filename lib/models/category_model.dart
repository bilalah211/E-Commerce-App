class Category {
  String? title;
  String? image;

  Category({required this.title, this.image});
}

List<Category> categories = [
  Category(title: "Grocery", image: 'images/grocery.png'),
  Category(title: "Electronics", image: 'images/electronics.png'),
  Category(title: "Cosmetics", image: 'images/cosmatics.png'),
  Category(title: "Pharmacy", image: 'images/pharmacy.png'),
  Category(title: "Garments", image: 'images/garments.png'),
];
