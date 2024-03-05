import 'package:example/views/cart_view.dart';
import 'package:example/views/products_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const ProductsView();
        },
        routes: [
          GoRoute(
            path: 'cart',
            builder: (BuildContext context, GoRouterState state) {
              return const CartView();
            },
          ),
        ]),
  ],
);
