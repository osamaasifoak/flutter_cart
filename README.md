# Flutter_Cart 🛒

![pub package](https://img.shields.io/pub/v/flutter_cart?label=flutter_cart&logo=Flutter%20Cart)

A flutter package for make your life easy. This package is used for maintaining a cart.

![sample](flutter_cart(sample).gif)
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
    - Offline support
- To make your cart save in offline you have to do it your self using SharedPreferences/something that store data in local.We strongly recommend you to use SharedPreferences for this job. Let's talk about how to do it.


1. Make a dart file name offlinecart.dart and just copy-paste this code there.You may need some configuration to do that.

```
        
class OfflineCart {
  SharedPreferences? preferance;
  initSharePref() async {
    preferance = await SharedPreferences.getInstance();
  }

  var cart = FlutterCart();
  var carString = [];
  makeOffline() async {
    await initSharePref();
    carString = [];
    if (cart.cartItem.isEmpty) {
      await preferance!.setString('offlineCart', ''); //
    } else {
      for (var i = 0; i < cart.cartItem.length; i++) {
        var obj = {
          "productId": cart.cartItem[i].productId,
          "unitPrice": cart.cartItem[i].unitPrice,
          "quantity": cart.cartItem[i].quantity,
          "productName": cart.cartItem[i].productName,
          "productDetailsObject": cart.cartItem[i].productDetails
        };
        carString.add(obj);
      }

      await preferance!.setString(
          'offlineCart', jsonEncode(carString).toString()); // saving your cart
    }
  }

  addProducts(String productID, int priceof1, int quantity, String productName,
      dynamic productDetails) async {
    cart.addToCart(
        productId: productID,
        unitPrice: priceof1,
        quantity: quantity,
        productName: productName,
        productDetailsObject: productDetails);
  }

  getFromOffline() {
    String x = preferance!.getString('offlineCart') ?? '';

    if (x.length > 3) {
      var offlineData = preferance!.getString('offlineCart');
      var data = jsonDecode(offlineData!);

      for (var i = 0; i < data.length; i++) {
        addProducts(
            data[i]['productId'],
            data[i]['unitPrice'],
            data[i]['quantity'],
            data[i]['productName'],
            data[i]['productDetailsObject']);
      }
    }
  }
}


```
2. Boom we are ready to goooooo..
-When you add a product to cart just use after your add to cart method
```
OfflineCart().makeOffline();
```
3. To get all the cart from your local use:
```
OfflineCart().getFromOffline();
```

4. To Delete all the cart from your local use:
```
await preferance!.setString('offlineCart', '');
```

