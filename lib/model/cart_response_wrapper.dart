import 'cart_model.dart';

class CartResponseWrapper {
  final bool status;
  final String message;
  List<CartItem> cartItemList;
  final int price = 42;

  CartResponseWrapper(this.status, this.message, this.cartItemList);
  // To make the sample app look nicer, each item is given one of the
  // Material Design primary colors.
  // : color = Colors.primaries[id % Colors.primaries.length];

}
