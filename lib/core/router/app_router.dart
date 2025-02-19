import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Page')),
        ),
      ),
      // Diğer route'lar buraya eklenecek
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page not found!')),
    ),
  );
});
