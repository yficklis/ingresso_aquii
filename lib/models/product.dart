class Product {
  String id;
  String name;
  double price;
  String imagePath;
  String subscription;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.subscription,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'subscription': subscription,
      'quantity': quantity,
    };
  }

  String get _id => id;
  String get _name => name;
  double get _price => price;
  String get _imagePath => imagePath;
  String get _subscription => subscription;
  int get _quantity => quantity;
}
