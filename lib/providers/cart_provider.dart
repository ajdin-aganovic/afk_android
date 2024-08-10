// import 'package:afk_android/models/proizvod.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/widgets.dart';

// import '../models/cart.dart';

// class CartProvider with ChangeNotifier {
//   Cart cart = Cart();
//   addToCart(Proizvod product) {
//     if (findInCart(product) != null && product.stateMachine=='active') {
//       findInCart(product)?.count++;
//     } else {
//       cart.items.add(CartItem(product, 1));
//     }
    
//     notifyListeners();
//   }

//   removeFromCart(Proizvod product) {
//     cart.items.removeWhere((item) => item.product.proizvodId == product.proizvodId);
//     notifyListeners();
//   }



//   CartItem? findInCart(Proizvod product) {
//     CartItem? item = cart.items.firstWhereOrNull((item) => item.product.proizvodId == product.proizvodId);
//     return item;
//   }
// }

////RAZGRANICENJE
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
// import 'package:afk_android/models/proizvod.dart';

import '../models/cart.dart';
import '../models/proizvod.dart';

class CartProvider with ChangeNotifier {
  Cart cart = Cart();

  addToCart(Proizvod product) {
    if (findInCart(product) != null) {
      findInCart(product)?.count++;
    } else {
      cart.items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  removeFromCart(Proizvod product) {
    cart.items.removeWhere((item) => item.product.proizvodId == product.proizvodId);
    notifyListeners();
  }

  CartItem? findInCart(Proizvod product) {
    CartItem? item = cart.items.firstWhereOrNull((item) => item.product.proizvodId == product.proizvodId);
    return item;
  }

  Future<bool> processPayment(double amount) async {
    // Mockup payment process
    await Future.delayed(Duration(seconds: 2)); // Simulate payment processing time
    return true; // Simulate successful payment
  }
}
