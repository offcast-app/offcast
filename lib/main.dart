import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/app_database.dart';

void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database singleton early
  AppDatabase.instance;

  runApp(
    const ProviderScope(
      child: OffcastApp(),
    ),
  );
}
