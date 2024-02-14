import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

/// [Cart Model] for managing cart data

@freezed
class CartModel with _$CartModel {
  const factory CartModel({
    required String productId,
    required String productName,
    required List<ProductVariant> variants,
    @Default(1) int quantity,
    @Default(0.0) double discount,
    required String productDetails,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, Object?> json) =>
      _$CartModelFromJson(json);
}

@freezed
class ProductVariant with _$ProductVariant {
  factory ProductVariant({
    String? size,
    required double price,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, Object?> json) =>
      _$ProductVariantFromJson(json);
}

class CartItem {
  CartItem(
      {this.uuid,
      this.productId,
      this.productName,
      this.unitPrice,
      this.subTotal,
      this.quantity = 0,
      this.productDetails,
      this.itemCartIndex = -1,
      this.uniqueCheck});

  dynamic uuid;
  dynamic productId;
  String? productName;
  dynamic unitPrice;
  dynamic subTotal;
  dynamic uniqueCheck;
  int quantity;
  dynamic productDetails;
  // Item store on which index of cart so we can update or delete cart easily, initially it is -1
  int itemCartIndex;

  factory CartItem.fromJson(String str) => CartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
        uuid: json["uuid"],
        productId: json["product_id"],
        productName: json["product_name"],
        unitPrice: json["unit_price"],
        subTotal: json["sub_total"],
        uniqueCheck: json["unique_check"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        productDetails:
            json["product_details"] == null ? null : json["product_details"],
        itemCartIndex:
            json["item_cart_index"] == null ? null : json["item_cart_index"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "product_id": productId,
        "product_name": productName,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "unique_check": uniqueCheck,
        "quantity": quantity == 0 ? null : quantity,
        "item_cart_index": itemCartIndex,
        "product_details":
            productDetails == null ? null : productDetails.toJson(),
      };
}
