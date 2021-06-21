// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:flutter_cart_sample/models/catelog.dart';
import 'package:flutter_cart_sample/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class MyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index)),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final Item item;

  const _AddButton({required this.item, Key? key}) : super(key: key);

  @override
  __AddButtonState createState() => __AddButtonState();
}

class __AddButtonState extends State<_AddButton> {
  late CartProvider _cartProvider;
  late CartItem? _cartItem;
  late int _isInCart;

  @override
  void initState() {
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    super.initState();
  }

  int _checkItemisInCart() {
    _cartItem = _cartProvider.getSpecificItemFromCartProvider(widget.item.id);
    return _cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.
    /*   var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(widget.item),
    );

    var isInCart = context.select<CartProvider, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.flutterCart.cartItem.contains(widget.item),
    ); */

    _isInCart = _checkItemisInCart();

    /* return Row(
      children: [
        _itemCount != 0
            ? new IconButton(
                icon: new Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _cartProvider.decrementItemFromCartProvider(
                        _cartItem!.itemCartIndex);
                    _itemCount--;
                  });
                },
              )
            : new Container(),
        new Text(_itemCount.toString()),
        new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              setState(() {
                _cartProvider
                    .incrementItemToCartProvider(_cartItem!.itemCartIndex);
                _itemCount++;
              });
            })
      ],
    ); */

    return TextButton(
      onPressed: _isInCart != 0
          ? null
          : () {
              // If the item is not in cart, we let the user add it.
              // We are using context.read() here because the callback
              // is executed whenever the user taps the button. In other
              // words, it is executed outside the build method.
              /*    var cart = context.read<CartModel>();
              cart.add(item); */
              _cartProvider.addToCart(widget.item);
              setState(() {});
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: _isInCart != 0
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Catalog', style: Theme.of(context).textTheme.headline1),
      floating: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
            Consumer<CartProvider>(
              builder: (context, consumer, child) {
                return Positioned(
                  right: 10,
                  child: Text("${consumer.getCartItems().length}"),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      // Here, we are only interested in the item at [index]. We don't care
      // about any other change.
      (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            Consumer<CartProvider>(builder: (context, cart, child) {
              return _AddButton(item: item);
            }),
          ],
        ),
      ),
    );
  }
}
