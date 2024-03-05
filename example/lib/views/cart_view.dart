import 'package:example/providers/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cart = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.getCartItems.length,
        itemBuilder: (context, index) {
          var product = cart.getCartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor:
                    Color((product.productId.hashCode * 0xFFFFFF).toInt())
                        .withOpacity(1.0),
              ),
              title: Text(product.productName),
              subtitle: Text('\$${product.variants[0].price.toString()}'),
              trailing: TextButton(
                onPressed: () => {},
                child: const Text('Add to cart'),
              ),
            ),
          );
        },
      ),
    );
  }
}
