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
        actions: [
          IconButton(
            onPressed: () => clearCart(ref),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildCartItemList(cart, ref),
          _buildTotal(context, cart),
        ],
      ),
    );
  }

  Padding _buildTotal(BuildContext context, CartNotifier cart) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '\$${cart.subtotal}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.deepPurple),
                    ),
                  ],
                ),
                Row(
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
              ],
            ),
          ),
        ),
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
        return Dismissible(
          key: Key(item.productId),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Text(
              'swipe to delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Padding(
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
                    onPressed: () => decrementItemCount(ref, item),
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
                    onPressed: () => incrementItemCount(ref, item),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          onDismissed: (direction) => deleteItem(ref, item),
        );
      },
    );
  }

  void clearCart(WidgetRef ref) {
    ref.read(cartNotifierProvider).clearCart();
  }

  void deleteItem(WidgetRef ref, CartModel item) {
    ref.read(cartNotifierProvider).removeItemFromCart(item);
  }

  void decrementItemCount(WidgetRef ref, CartModel item) {
    ref.read(cartNotifierProvider).updateQuantity(item, item.quantity - 1);
  }

  void incrementItemCount(WidgetRef ref, CartModel item) {
    ref.read(cartNotifierProvider).updateQuantity(item, item.quantity + 1);
  }
}
