import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:food_waste_exchange/src/presentation/screens/auth_screen.dart';
import 'package:food_waste_exchange/src/presentation/screens/home_screen.dart';
import 'package:food_waste_exchange/src/presentation/screens/create_listing_screen.dart';
import 'package:food_waste_exchange/src/presentation/screens/listing_detail_screen.dart';
import 'package:food_waste_exchange/src/presentation/screens/impact_dashboard_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'create-listing',
            builder: (context, state) => const CreateListingScreen(),
          ),
          GoRoute(
            path: 'listing/:id',
            builder: (context, state) => ListingDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'impact',
            builder: (context, state) => const ImpactDashboardScreen(),
          ),
        ],
      ),
    ],
  );
}
