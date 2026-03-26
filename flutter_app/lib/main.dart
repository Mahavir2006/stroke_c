// Stroke Mitra - Main Entry Point
//
/// Initializes Supabase, loads environment variables,
/// and launches the Flutter application with theme support.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stroke_mitra/l10n/app_localizations.dart';

import 'app/locale_provider.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'app/theme_provider.dart';
import 'core/supabase_client.dart';
import 'features/face_analysis/face_service.dart';
import 'features/voice_check/voice_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables (graceful fallback for web dev server quirks)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Web dev server sometimes returns 500 for .env — inject values directly
    dotenv.env['SUPABASE_URL'] = 'https://mdbefchaawgmvblcqgyr.supabase.co';
    dotenv.env['SUPABASE_ANON_KEY'] =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1kYmVmY2hhYXdnbXZibGNxZ3lyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1MDIwNzIsImV4cCI6MjA4OTA3ODA3Mn0.DZfWhVx6WyhibM1widf5ZZmqScXQtVkHjI_91XeW89g';
  }

  // Initialize Supabase
  await SupabaseClientManager.initialize();

  // Warm up ML models (fire-and-forget)
  VoiceService.pingHealthCheck();
  FaceService.pingHealthCheck();

  runApp(
    const ProviderScope(child: StrokeMitraApp()),
  );
}

class StrokeMitraApp extends ConsumerWidget {
  const StrokeMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Stroke Mitra — Detect Stroke Early. Save Lives.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
