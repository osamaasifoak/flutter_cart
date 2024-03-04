import 'package:example/providers/products/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          AsyncData(:final value) => ListView.builder(
              itemCount: value.products.length,
              itemBuilder: (context, index) {
                var product = value.products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      print(product);
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Color((product.title.hashCode * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                    ),
                    title: Text(product.title),
                    trailing: Text('\$${product.price.toString()}'),
                  ),
                );
              },
            ),
          AsyncError() => Text(response.error.toString()),
          _ => const CircularProgressIndicator(),
        });
  }
}

class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.purpleAccent,
      label: Text('10'),
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
