import 'package:diet_app/core/config/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'presentation/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/providers/auth/auth_notifier.dart';
import 'presentation/pages/home/home_page.dart';
import 'core/storage/cache_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Environment'ı ayarla
  AppConfig.initialize(Environment.dev); // veya .prod ya da .stage

  // Timeago Türkçe dil desteği
  timeago.setLocaleMessages('tr', timeago.TrMessages());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Sağlık temasına uygun yeşil
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.green.shade300,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade300,
              width: 2,
            ),
          ),
        ),
      ),
      home: authState.maybeWhen(
        initial: () => const SplashPage(),
        authenticated: (_) => const HomePage(),
        unauthenticated: () => const LoginPage(),
        error: (_) => const LoginPage(),
        orElse: () => const SplashPage(),
      ),
    );
  }
}
