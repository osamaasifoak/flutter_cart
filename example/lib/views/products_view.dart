import 'package:example/models/products_model.dart';
import 'package:example/providers/cart/cart_provider.dart';
import 'package:example/providers/products/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsView extends ConsumerWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final response = ref.watch(fetchProductsProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShoppingCartIcon(),
            ),
          ],
        ),
        body: switch (response) {
          AsyncData(:final value) => _buildMain(ref, value),
          AsyncError() => Text(response.error.toString()),
          _ => const CircularProgressIndicator(),
        });
  }

  ListView _buildMain(WidgetRef ref, ProductModel value) {
    return ListView.builder(
      itemCount: value.products.length,
      itemBuilder: (context, index) {
        var product = value.products[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor:
                  Color((product.title.hashCode * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
            ),
            title: Text(product.title),
            subtitle: Text('\$${product.price.toString()}'),
            trailing: TextButton(
              onPressed: () => _handleAddToCart(ref, product),
              child: const Text('Add to cart'),
            ),
          ),
        );
      },
    );
  }

  void _handleAddToCart(WidgetRef ref, ProductItemsModel product) {
    ref.read(cartNotifierProvider).addToCart(product);
  }
}

class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cartCount = ref.watch(cartNotifierProvider).getCartCount;
    return InkWell(
      onTap: () => context.push('/cart'),
      child: Badge(
        backgroundColor: Colors.purpleAccent,
        label: Text(cartCount.toString()),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}
