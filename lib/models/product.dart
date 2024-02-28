class Product {
  String name;
  double price;
  String imagePath;
  String subscription;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.subscription,
  });

  String get _name => _name;
  double get _price => _price;
  String get _imagePath => _imagePath;
  String get _subscription => _subscription;
}
