import 'dart:async';
import 'dart:convert';
import 'package:flutter_cart/constants/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/cart_model.dart';

class FlutterCart {
  static final FlutterCart _instance = FlutterCart._internal();
  late List<CartModel> _cartItemsList;
  late final SharedPreferences _sharedPreference;

  factory FlutterCart() {
    return _instance;
  }
  FlutterCart._internal();

  /// Set [isPersistenceSupportEnabled] to true to turn on the cart persistence
  /// Example:
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   var cart = FlutterCart();
  ///   await cart.initializeCart(isPersistenceSupportEnabled: true);
  ///   runApp(MyApp());
  /// }
  Future<void> initializeCart(
      {bool isPersistenceSupportEnabled = false}) async {
    _cartItemsList = <CartModel>[];
    _sharedPreference = await SharedPreferences.getInstance();
    await _enableAndDisableCartPersistenceSupport(
        isPersistenceSupportEnabled: isPersistenceSupportEnabled);
    if (isPersistenceSupportEnabled) {
      _cartItemsList = _getPersistenceCartItems() ?? [];
    }
  }

  /// This method is called when we have to add an item to the cart
  /// Example:
  ///   void addToCart(YourProductModel product) {
  ///   flutterCart.addToCart(
  ///     cartModel: CartModel(
  ///       // ... other parameters
  ///       if [discount] is applicable and in percentage so, you can
  ///       calculate the discount like this
  ///       var discount = (product.discountPercentage / 100) * product.price;
  ///       discount: discount,
  ///       [productMeta] takes Map<String, dynamic> so, you can store your complete product data in productMeta
  ///       productMeta: product.toJson()),
  ///   );
  /// }
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
    if (getPersistenceSupportStatus()) {
      _updatePersistenceCart(_cartItemsList);
    }
  }

  /// [updateQuantity] is used to increment/decrement the item quantity
  /// Example:
  ///  void updateQuantity(CartModel item, int newQuantity) {
  ///     flutterCart.updateQuantity(
  ///     item.productId, item.variants, newQuantity);
  /// }

  void updateQuantity(
      String productId, List<ProductVariant> variants, int newQuantity) {
    if (newQuantity == 0) {
      removeItem(productId, variants);
    } else {
      var itemIndex = _cartItemsList.indexWhere((item) =>
          item.productId == productId &&
          _areVariantsEqual(item.variants, variants));

      if (itemIndex != -1) {
        _cartItemsList[itemIndex] =
            _cartItemsList[itemIndex].copyWith(quantity: newQuantity);
        if (getPersistenceSupportStatus()) {
          _updatePersistenceCart(_cartItemsList);
        }
      }
    }
  }

  /// [removeItem] is used for removing the specific item from the cart
  /// Example:
  /// void removeItemFromCart(CartModel item) {
  //    flutterCart.removeItem(item.productId, item.variants);
  //  }
  void removeItem(String productId, List<ProductVariant> variants) {
    _cartItemsList.removeWhere((item) =>
        item.productId == productId &&
        _areVariantsEqual(item.variants, variants));
    if (getPersistenceSupportStatus()) {
      _updatePersistenceCart(_cartItemsList);
    }
  }

  /// [getSpecificProduct] will return the specific item from cart
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

  /// [getProductIndex] will return the specific item index
  int getProductIndex(
    String productId,
    List<ProductVariant> variants,
  ) {
    var itemIndex = _cartItemsList.indexWhere((item) =>
        item.productId == productId &&
        _areVariantsEqual(item.variants, variants));

    return itemIndex;
  }

  /// [applyDiscount] use this method when you have case where you have to apply discount
  /// on specific product. Otherwise you can also apply discount the time of adding product into the cart.
  /// Check [addToCart] example for more info.
  void applyDiscount(
      String productId, List<ProductVariant> variants, double discount) {
    var itemIndex = getProductIndex(productId, variants);

    if (itemIndex != -1) {
      _cartItemsList[itemIndex] =
          _cartItemsList[itemIndex].copyWith(discount: discount);
    }
  }

  /// [clearCart] will clear the complete cart, including both in-memory and persistent cart data.
  void clearCart() {
    _cartItemsList.clear();
    unawaited(_clearPersistenceCart());
  }

  /// [getPersistenceSupportStatus] use this method to check the persistence storage enable/disable status
  bool getPersistenceSupportStatus() {
    var status = _sharedPreference
        .getBool(SharedPreferenceConstants.isPersistenceSupportEnabled);
    return status ?? false;
  }

  //By default the persistence support will be off
  Future<void> _enableAndDisableCartPersistenceSupport(
      {required bool isPersistenceSupportEnabled}) async {
    try {
      await _sharedPreference.setBool(
        SharedPreferenceConstants.isPersistenceSupportEnabled,
        isPersistenceSupportEnabled,
      );
      if (!isPersistenceSupportEnabled) {
        await _clearPersistenceCart();
      }
    } catch (_) {
      rethrow;
    }
  }

  void _updatePersistenceCart(List<CartModel> cartItemsList) {
    var cartList = cartItemsList.map((e) => json.encode(e.toJson())).toList();
    unawaited(_sharedPreference.setStringList(
        SharedPreferenceConstants.persistCart, cartList));
  }

  List<CartModel>? _getPersistenceCartItems() {
    var items =
        _sharedPreference.getStringList(SharedPreferenceConstants.persistCart);
    if (items != null && items.isNotEmpty) {
      return items.map((e) => CartModel.fromJson(json.decode(e))).toList();
    }
    return null;
  }

  Future<bool> _clearPersistenceCart() async {
    var isRemoved =
        await _sharedPreference.remove(SharedPreferenceConstants.persistCart);
    return isRemoved;
  }

  /// Compares two lists of ProductVariant objects for equality.
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

  List<CartModel>? get persistenceCartItemsList {
    return _getPersistenceCartItems();
  }
}
