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
    var discount = (product.discountPercentage / 100) * product.price;
    flutterCart.addToCart(
      cartModel: CartModel(
          productId: product.id.toString(),
          productName: product.title,
          variants: [
            ProductVariant(price: product.price),
          ],
          productDetails: product.description,
          discount: discount,
          productMeta: product.toJson()),
    );
    notifyListeners();
  }

  void updateQuantity(CartModel item, int newQuantity) {
    flutterCart.updateQuantity(
        item.productId.toString(), item.variants, newQuantity);
    notifyListeners();
  }

  void removeItemFromCart(CartModel item) {
    flutterCart.removeItem(item.productId.toString(), item.variants);
    notifyListeners();
  }

  void clearCart() {
    flutterCart.clearCart();
    notifyListeners();
  }

  int get getCartCount => flutterCart.cartLength;
  List<CartModel> get getCartItems => flutterCart.cartItemsList;
  double get getTotalAmount => flutterCart.total;
  double get subtotal => flutterCart.subtotal;
}
