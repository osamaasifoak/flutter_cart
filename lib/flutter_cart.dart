import 'package:flutter/material.dart';

import 'model/cart_model.dart';

class FlutterCart {
  static final FlutterCart _instance = FlutterCart._internal();
  CartItem _cartItem;
  // CartItemElement _cartItemElement;
  List<CartItem> _cartItemList;
  List<CartItem> get cartItem => _cartItemList;
  List<String> _uuid;
  bool _filterItemFound = false;
  var message;
  factory FlutterCart() {
    return _instance;
  }
  FlutterCart._internal() {
    _cartItemList = new List<CartItem>();
    _uuid = List<String>();
  }

  /// This method is called when we have to add [productTemp] into cart
  addToCart(
      {@required dynamic productId,
      @required dynamic unitPrice,
      @required int quantity,
      dynamic uniqueCheck,
      dynamic productDetailsObject}) {
    _cartItem = new CartItem();
    _setProductValues(
        productId, unitPrice, quantity, uniqueCheck, productDetailsObject);
    if (_cartItemList.isEmpty) {
      _cartItem.subTotal =
          double.parse((quantity * unitPrice).toStringAsFixed(2));
      _uuid.add(_cartItem.uuid);
      _cartItemList.add(_cartItem);
      return {"status": true, "message": _successMessage};
    } else {
      _cartItemList.forEach((x) {
        if (x.productId == productId) {
          /// If item [UniqueCheck] is not null then we update the item in cart
          if (uniqueCheck != null) {
            if (x.uniqueCheck == uniqueCheck) {
              _filterItemFound = true;
              _updateProductDetails(x, quantity, unitPrice);
              message = {"status": true, "message": _updateMessage};
            }
          }

          /// if uniqueCheck is null then we update the [product] in our cart in against of [PRODUCT ID]
          else {
            _filterItemFound = true;
            _updateProductDetails(x, quantity, unitPrice);
            message = {"status": true, "message": _successMessage};
          }
        }
      });

      /// if _filterItemFound is [false] then we directly add the product in our cart
      if (!_filterItemFound) {
        _uuid.add(_cartItem.uuid);
        _updateProductDetails(_cartItem, quantity, unitPrice);
        _cartItemList.add(_cartItem);

        message = {"status": true, "message": _successMessage};
      }
      _filterItemFound = false;
      return message;
    }
  }

  /// This function is used to decrement the item quantity from cart
  decrementItemFromCart(int index) {
    if (_cartItemList[index].quantity > 1) {
      _cartItemList[index].quantity = --_cartItemList[index].quantity;
      _cartItemList[index].subTotal =
          (_cartItemList[index].quantity * _cartItemList[index].unitPrice)
              .roundToDouble();
    } else {
      _cartItemList.removeAt(index);
      return {"status": true, "message": _removedMessage};
      // return true;
    }
  }

  deleteItemFromCart(int index, {int specificIndex}) {
    for (int i = _cartItemList[index].quantity; i > 0; i--) {
      decrementItemFromCart(index);
    }
  }

  deleteAllCart() {
    _cartItemList = new List<CartItem>();
    _uuid = List<String>();
  }

  int findItemIndexFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        return i;
      }
    }
    return null;
  }

  /// This function is used to increment the item quantity into cart
  incrementItemToCart(int index) {
    _cartItemList[index].quantity = ++_cartItemList[index].quantity;
    _cartItemList[index].subTotal =
        (_cartItemList[index].quantity * _cartItemList[index].unitPrice)
            .roundToDouble();
  }

  /// This method is called when we have to [initialize the values in our cart object]
  void _setProductValues(
      productId, unitPrice, int quantity, uniqueCheck, productDetailsObject) {
    _cartItem.uuid =
        productId.toString() + "-" + DateTime.now().toIso8601String();
    _cartItem.productId = productId;
    _cartItem.unitPrice = unitPrice;
    _cartItem.quantity = quantity;
    _cartItem.uniqueCheck = uniqueCheck;
    _cartItem.productDetails = productDetailsObject;
  }

  /// This method is called when we have to update the [product details in  our cart]
  void _updateProductDetails(cartObject, int quantity, dynamic unitPrice) {
    cartObject.quantity = quantity;
    cartObject.subTotal =
        double.parse((quantity * unitPrice).toStringAsFixed(2));
  }

  /// This method is called when we have to get the [cart lenght]
  getCartItemCount() {
    return _cartItemList.length;
  }
 /// This method is called when we have to get the [Total amount]
  getTotalAmount() {
    double totalAmount = 0.0;
    _cartItemList.forEach((e) => totalAmount += e.subTotal);
    return totalAmount;
  }

  static final String _successMessage = "Item added to cart successfully.";
  static final String _updateMessage = "Item updated successfully.";
  static final String _removedMessage = "Item removed from cart successfully.";
}
