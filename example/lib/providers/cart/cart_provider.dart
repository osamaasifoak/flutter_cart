import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:example/models/products_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartNotifierProvider = ChangeNotifierProvider<CartNotifier>((ref) {
  return CartNotifier();
});

class CartNotifier extends ChangeNotifier {
  var flutterCart = FlutterCart();

  void addToCart(ProductItemsModel product) {
    flutterCart.addToCart(
      cartModel: CartModel(
          productId: product.id.toString(),
          productName: product.title,
          variants: [
            ProductVariant(price: product.price),
          ],
          productDetails: product.description,
          discount: product.discountPercentage),
    );
    notifyListeners();
  }

  int get getCartCount => flutterCart.cartLength;
  List<CartModel> get getCartItems => flutterCart.cartItemsList;
}
