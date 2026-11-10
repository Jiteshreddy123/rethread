import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/signup_screen.dart';
import '../../features/create_listing/presentation/screens/add_item_screen.dart';
import '../../features/create_listing/presentation/screens/create_listing_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/item_details/presentation/screens/item_details_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/recycling/presentation/screens/recycling_discovery_screen.dart';
import '../../features/repair/presentation/screens/repair_discovery_screen.dart';
import '../widgets/app_scaffold_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// AppRouter centralizes all declarative routes and navigation logic using GoRouter.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  errorBuilder: (context, state) => const HomeScreen(),
  routes: [
    // Root & Splash Route
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Route
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Authentication Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),

    // Create / Edit Listing
    GoRoute(
      path: '/create-listing',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateListingScreen(),
    ),

    // Discovery & Secondary Screens
    GoRoute(
      path: '/repair',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RepairDiscoveryScreen(),
    ),
    GoRoute(
      path: '/recycling',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecyclingDiscoveryScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Item Details Route (Pushed on top of the bottom navigation shell)
    GoRoute(
      path: '/item/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final itemId = state.pathParameters['id'] ?? 'item_1';
        return ItemDetailsScreen(itemId: itemId);
      },
    ),

    // Main 5-Tab Stateful Bottom Navigation Shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffoldShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Explore
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),

        // Tab 3: Add Item
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add-item',
              builder: (context, state) => const AddItemScreen(),
            ),
          ],
        ),

        // Tab 4: Activity
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/activity',
              builder: (context, state) => const ActivityScreen(),
            ),
          ],
        ),

        // Tab 5: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
