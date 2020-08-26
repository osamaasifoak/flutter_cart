// To parse this JSON data, do
//
//     final cartItem = cartItemFromMap(jsonString);

import 'dart:convert';

/// [Cart Model] for managing cart data
class CartItem {
  CartItem(
      {this.uuid,
      this.productId,
      this.unitPrice,
      this.subTotal,
      this.quantity,
      this.productDetails,
      this.uniqueCheck});

  dynamic uuid;
  dynamic productId;
  dynamic unitPrice;
  dynamic subTotal;
  dynamic uniqueCheck;
  int quantity;
  dynamic productDetails;

  factory CartItem.fromJson(String str) => CartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
        uuid: json["uuid"],
        productId: json["product_id"],
        unitPrice: json["unit_price"],
        subTotal: json["sub_total"],
        uniqueCheck: json["unique_check"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        productDetails:
            json["product_details"] == null ? null : json["product_details"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "product_id": productId,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "unique_check": uniqueCheck,
        "quantity": quantity == null ? null : quantity,
        "product_details":
            productDetails == null ? null : productDetails.toMap(),
      };
}
