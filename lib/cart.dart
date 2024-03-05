import 'dart:async';
import 'dart:convert';
import 'package:flutter_cart/constants/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/cart_model.dart';

class FlutterCart {
  static final FlutterCart _instance = FlutterCart._internal();
  late List<CartModel> _cartItemsList;
  late final SharedPreferences _sharedPreference;

  //OLD
  factory FlutterCart() {
    return _instance;
  }
  FlutterCart._internal();

  /// Set [isPersistanceSupportEnabled] to true to turn on the cart persistance
  Future<void> initializeCart(
      {bool isPersistanceSupportEnabled = false}) async {
    _sharedPreference = await SharedPreferences.getInstance();
    await enableAndDisableCartPersistanceSupport(
        isPersistanceSupportEnabled: isPersistanceSupportEnabled);
    _cartItemsList = <CartModel>[];
  }

  /// This method is called when we have to add [productTemp] into cart
  void addToCart({required CartModel cartModel}) {
    var existingItemIndex =
        getProductIndex(cartModel.productId, cartModel.variants);

    if (existingItemIndex != -1) {
      var quantity =
          _cartItemsList[existingItemIndex].quantity + cartModel.quantity;
      _cartItemsList[existingItemIndex] =
          _cartItemsList[existingItemIndex].copyWith(quantity: quantity);
    } else {
      _cartItemsList.add(cartModel);
    }
    if (getPersistanceSupportStatus()) {
      updatePersistanceCart(_cartItemsList);
    }
  }

  void updateQuantity(
      String productId, List<ProductVariant> variants, int newQuantity) {
    var itemIndex = _cartItemsList.indexWhere((item) =>
        item.productId == productId &&
        _areVariantsEqual(item.variants, variants));

    if (itemIndex != -1) {
      _cartItemsList[itemIndex] =
          _cartItemsList[itemIndex].copyWith(quantity: newQuantity);
    }
  }

  void removeItem(String productId, List<ProductVariant> variants) {
    _cartItemsList.removeWhere((item) =>
        item.productId == productId &&
        _areVariantsEqual(item.variants, variants));
  }

  /// This method is called when we have to get the [cart lenght]

  CartModel? getSpecificProduct(
    String productId,
    List<ProductVariant> variants,
  ) {
    var itemIndex = getProductIndex(productId, variants);
    if (itemIndex != -1) {
      return _cartItemsList[itemIndex];
    }
    return null;
  }

  int getProductIndex(
    String productId,
    List<ProductVariant> variants,
  ) {
    var itemIndex = _cartItemsList.indexWhere((item) =>
        item.productId == productId &&
        _areVariantsEqual(item.variants, variants));

    return itemIndex;
  }

  void applyDiscount(
      String productId, List<ProductVariant> variants, double discount) {
    var itemIndex = getProductIndex(productId, variants);

    if (itemIndex != -1) {
      _cartItemsList[itemIndex] =
          _cartItemsList[itemIndex].copyWith(discount: discount);
    }
  }

  void clearCart() {
    _cartItemsList.clear();
    unawaited(clearPersistanceCart());
  }

  //By default the persistance support will be off
  Future<void> enableAndDisableCartPersistanceSupport(
      {required bool isPersistanceSupportEnabled}) async {
    await _sharedPreference.setBool(
      SharedPreferenceConstants.isPersistanceSupportEnabled,
      isPersistanceSupportEnabled,
    );
    if (!isPersistanceSupportEnabled) {
      await clearPersistanceCart();
    }
  }

  bool getPersistanceSupportStatus() {
    var status = _sharedPreference
        .getBool(SharedPreferenceConstants.isPersistanceSupportEnabled);
    return status ?? false;
  }

  void updatePersistanceCart(List<CartModel> cartItemsList) {
    var cartList = cartItemsList.map((e) => json.encode(e.toJson())).toList();
    unawaited(_sharedPreference.setStringList(
        SharedPreferenceConstants.persistCart, cartList));
  }

  List<CartModel>? getPersistanceCartItems() {
    var items =
        _sharedPreference.getStringList(SharedPreferenceConstants.persistCart);
    if (items != null && items.isNotEmpty) {
      return items.map((e) => CartModel.fromJson(json.decode(e))).toList();
    }
    return null;
  }

  Future<bool> clearPersistanceCart() async {
    var isRemoved =
        await _sharedPreference.remove(SharedPreferenceConstants.persistCart);
    return isRemoved;
  }

  bool _areVariantsEqual(
      List<ProductVariant> variants1, List<ProductVariant> variants2) {
    if (variants1.length != variants2.length) {
      return false;
    }

    for (int i = 0; i < variants1.length; i++) {
      if (variants1[i].size != variants2[i].size ||
          variants1[i].price != variants2[i].price) {
        return false;
      }
    }

    return true;
  }

  /// This method is called when we have to get the [Total amount]
  double get subtotal {
    return _cartItemsList.fold(0, (sum, item) {
      return sum +
          item.variants.fold(
            0,
            (variantSum, variant) =>
                variantSum + (variant.price * item.quantity),
          );
    });
  }

  double get total {
    return subtotal - discount;
  }

  double get discount {
    return _cartItemsList.fold(
        0, (sum, item) => sum + (item.discount * item.quantity));
  }

  int get cartLength {
    return _cartItemsList.length;
  }

  List<CartModel> get cartItemsList {
    return _cartItemsList;
  }
}
