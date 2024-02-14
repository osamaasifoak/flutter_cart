import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('addToCart should add items to the cart', () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart();

    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');
    final cartModel2 = CartModel(
        productId: '2',
        variants: [ProductVariant(price: 2000)],
        quantity: 4,
        productName: 'Product 2',
        productDetails: 'This is a product 2');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.addToCart(cartModel: cartModel2);

    // Assert
    expect(cart.cartItemsList.length, 2);
    expect(cart.cartItemsList[0].quantity, 2);
    expect(cart.cartItemsList[1].quantity, 4);
    var persistItem = cart.getPersistanceCartItems();
    expect(persistItem, null);
  });

  test('addToCart should add items to the cart with persistance', () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart(isPersistanceSupportEnabled: true);

    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');
    final cartModel2 = CartModel(
        productId: '2',
        variants: [ProductVariant(price: 2000)],
        quantity: 4,
        productName: 'Product 2',
        productDetails: 'This is a product 2');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.addToCart(cartModel: cartModel2);

    // Assert
    expect(cart.cartItemsList.length, 2);
    expect(cart.getPersistanceCartItems()?.length, 2);
  });

  test('addToCart should update quantity for existing items', () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart();
    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');
    final cartModel2 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 3,
        productName: 'Product 1',
        productDetails: 'This is a product 1');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.addToCart(cartModel: cartModel2);

    // Assert
    expect(cart.cartItemsList.length, 1);
    expect(cart.cartItemsList[0].quantity, 5);
  });

  test('updateQuantity should update the quantity for existing items',
      () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart();
    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.updateQuantity(cartModel1.productId, cartModel1.variants, 4);

    // Assert
    expect(cart.cartItemsList.length, 1);
    expect(cart.cartItemsList[0].quantity, 4);
  });

  test('removeItem should remove the item from cart', () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart();
    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');
    final cartModel2 = CartModel(
        productId: '2',
        variants: [ProductVariant(price: 2000)],
        quantity: 4,
        productName: 'Product 2',
        productDetails: 'This is a product 2');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.addToCart(cartModel: cartModel2);

    cart.removeItem(cartModel1.productId, cartModel1.variants);

    // Assert
    expect(cart.cartItemsList.length, 1);
  });

  test('getProductIndex should get the item index from cart', () async {
    // Arrange
    final cart = FlutterCart();
    await cart.initializeCart();
    final cartModel1 = CartModel(
        productId: '1',
        variants: [ProductVariant(price: 1000)],
        quantity: 2,
        productName: 'Product 1',
        productDetails: 'This is a product 1');
    final cartModel2 = CartModel(
        productId: '2',
        variants: [ProductVariant(price: 2000)],
        quantity: 4,
        productName: 'Product 2',
        productDetails: 'This is a product 2');

    // Act
    cart.addToCart(cartModel: cartModel1);
    cart.addToCart(cartModel: cartModel2);

    var index = cart.getProductIndex(cartModel2.productId, cartModel2.variants);

    // Assert
    expect(index, 1);
  });
}
