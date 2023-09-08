import 'package:afk_android/models/proizvod.dart';

class Cart {
    List<CartItem> items = [];
}

class CartItem {
  CartItem(this.product, this.count);
  late Proizvod product;
  late int count;
}