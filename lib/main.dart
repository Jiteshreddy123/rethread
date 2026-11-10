import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Application Entry Point.
/// 
/// `ProviderScope` is the root widget provided by Riverpod that stores
/// the state of all providers across the application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: ReThreadApp(),
    ),
  );
}
