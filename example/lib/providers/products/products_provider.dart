import 'dart:convert';
import 'package:example/models/products_model.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Necessary for code-generation to work
part 'products_provider.g.dart';

/// This will create a provider named `fetchProductsProvider`
/// which will cache the result of this function.
@riverpod
Future<ProductModel> fetchProducts(FetchProductsRef ref) async {
  final String response = await rootBundle.loadString('assets/products.json');
  final json = jsonDecode(response) as Map<String, dynamic>;
   return ProductModel.fromJson(json);
}
