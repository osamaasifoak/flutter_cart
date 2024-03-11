import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_model.freezed.dart';
part 'products_model.g.dart';

/// [Cart Model] for managing cart data

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required List<ProductItemsModel> products,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, Object?> json) =>
      _$ProductModelFromJson(json);
}

@freezed
class ProductItemsModel with _$ProductItemsModel {
  const factory ProductItemsModel({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String brand,
    String? thumbnail,
    List<String>? images,
  }) = _ProductItemsModel;

  factory ProductItemsModel.fromJson(Map<String, Object?> json) =>
      _$ProductItemsModelFromJson(json);
}
