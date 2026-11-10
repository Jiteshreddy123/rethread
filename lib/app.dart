import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// ReThreadApp is the root widget of the application.
/// 
/// In Phase 2, it is configured with:
/// 1. Material 3 Light Theme.
/// 2. GoRouter declarative navigation (`routerConfig: appRouter`).
/// 3. Centralized application strings and branding.
class ReThreadApp extends StatelessWidget {
  const ReThreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
