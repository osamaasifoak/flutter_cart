import 'package:example/providers/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildCartItemList(cart, ref),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$${cart.getTotalAmount}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildCartItemList(CartNotifier cart, WidgetRef ref) {
    return ListView.builder(
      itemCount: cart.getCartItems.length,
      itemBuilder: (context, index) {
        var item = cart.getCartItems[index];
        const width4 = SizedBox(
          width: 4,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor:
                  Color((item.productId.hashCode * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
            ),
            title: Text(item.productName),
            subtitle: Text('\$${item.variants[0].price.toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => removeFromCart(ref, item),
                  icon: const Icon(Icons.remove),
                ),
                width4,
                Text(
                  item.quantity.toString(),
                  style:
                      const TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
                width4,
                IconButton(
                  onPressed: () => addToCart(ref, item),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeFromCart(WidgetRef ref, CartModel item) {
    ref.read(cartNotifierProvider).updateQuantity(item, item.quantity - 1);
  }

  void addToCart(WidgetRef ref, CartModel item) {
    ref.read(cartNotifierProvider).updateQuantity(item, item.quantity + 1);
  }
}
