// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartModelImpl _$$CartModelImplFromJson(Map<String, dynamic> json) =>
    _$CartModelImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImages: (json['productImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      variants: (json['variants'] as List<dynamic>)
          .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as int? ?? 1,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      productDetails: json['productDetails'] as String,
      productMeta: (json['productMeta'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      ),
    );

Map<String, dynamic> _$$CartModelImplToJson(_$CartModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productImages': instance.productImages,
      'variants': instance.variants,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'productDetails': instance.productDetails,
      'productMeta': instance.productMeta,
    };

_$ProductVariantImpl _$$ProductVariantImplFromJson(Map<String, dynamic> json) =>
    _$ProductVariantImpl(
      size: json['size'] as String?,
      color: json['color'] as String?,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductVariantImplToJson(
        _$ProductVariantImpl instance) =>
    <String, dynamic>{
      'size': instance.size,
      'color': instance.color,
      'price': instance.price,
    };
