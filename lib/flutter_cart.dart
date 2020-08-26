import 'dart:convert';

import 'package:flutter/material.dart';

import 'model/cart_model.dart';

class FlutterCart {
  static final FlutterCart _instance = FlutterCart._internal();
  CartItem _cartItem;
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

  /// This method is called when we have to add [product] into cart
  addToCart(
      {@required dynamic productId,
      @required dynamic unitPrice,
      @required int quantity,

      ///[uniqueCheck] is used to differentiate the type between item
      ///[e.g] the shirt sizes in (LARGE, MEDIUM, SMALL) the [Product ID] will remain same
      ///But if UUID is not present so, how we can differentiate between them? So in this case we will
      ///User the uniqueCheck
      dynamic uniqueCheck,

      ///[productDetailsObject] is used as a dump variable you can dump your object and any kind of data
      ///that you wanted use in future.
      dynamic productDetailsObject}) {
    _cartItem = new CartItem();
    _setProductValues(
        productId, unitPrice, quantity, uniqueCheck, productDetailsObject);

    if (_cartItemList.isEmpty) {
      _cartItem.subTotal = unitPrice * quantity;
      _uuid.add(_cartItem.uuid);
      _cartItemList.add(_cartItem);
      print(json.encode(_cartItem));
      return {"status": true, "message": _successMessage};
    } else {
      _cartItemList.forEach((x) {
        if (x.productId == productId) {
          /// If item [UniqueCheck] is not null then we update the item in cart
          if (uniqueCheck != null) {
            if (x.uniqueCheck == uniqueCheck) {
              _filterItemFound = true;
              _updateProductDetails(x, quantity, unitPrice);
              print(1);
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
        print(2);
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
          _cartItemList[index].quantity * _cartItemList[index].unitPrice;
    } else {
      _cartItemList.removeAt(index);
      return {"status": true, "message": _removedMessage};
    }
  }

  /// This function is used to increment the item quantity into cart
  incrementItemToCart(int index) {
    _cartItemList[index].quantity = ++_cartItemList[index].quantity;
    _cartItemList[index].subTotal =
        _cartItemList[index].quantity * _cartItemList[index].unitPrice;
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
    cartObject.subTotal = quantity * unitPrice;
  }

  /// This method is called when we have to get the [cart lenght]
  getCartItemCount() {
    return _cartItemList.length;
  }

  /// This method is used for getting the total amount.
  getTotalAmount() {
    double totalAmount = 0.0;
    _cartItemList.forEach((e) => totalAmount += e.subTotal);
    return totalAmount;
  }

  /// static messages
  static final String _successMessage = "Item added to cart successfully.";
  static final String _updateMessage = "Item updated successfully.";
  static final String _removedMessage = "Item removed from cart successfully.";
}
