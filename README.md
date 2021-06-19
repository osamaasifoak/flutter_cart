# Flutter_Cart 🛒

![pub package](https://img.shields.io/pub/v/flutter_cart?label=flutter_cart&logo=Flutter%20Cart)

A flutter package for make your life easy. This package is used for maintaining a cart.

## Usage

#### It is recommended to use any State Management. i.e:- Provider, Redux etc

To use this plugin, add `flutter_cart` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Getting Started

- first create an instance of flutter cart package.

```
     var cart = FlutterCart();
```

- After getting the instance, we are able to get the built-in methods
  - Add Items into cart
    ```
         cart.addToCart(
                {@required dynamic productId,
                 @required dynamic unitPrice,
                 @required int quantity,
                 dynamic uniqueCheck,
                 dynamic productDetailsObject});
    ```
  - Remove item one by one from cart ➖
    ```
        cart.decrementItemFromCart(index);
    ```
  - Add item one by one to cart ➕
    ```
        cart.incrementItemToCart(index);
    ```
  - Get the total amount
    ```
        cart.getTotalAmount()
    ```
  - Get the total quantity
    ```
        cart.getCartItemCount()
    ```
  - Get Specific Item from Cart
    ```
        cart.getSpecificItemFromCart(cartId)
    ```



