import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'presentation/pages/home_page.dart';

// --- DESIGN CONSTANTS ---
class AppColors {
  static const Color powderPink = Color(0xFFFFF0F3); // Soft background
  static const Color softLilac = Color(0xFFE0D7FF); // Accents/Chips
  static const Color deepLilac = Color(0xFF6750A4); // Selected text/icons
  static const Color textBlack = Color(0xFF2D2D2D); // Main text
  static const Color textGrey = Color(0xFF757575); // Subtitles
  static const Color surfaceWhite = Colors.white; // Cards
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.powderPink, // Global Background
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.deepLilac,
          surface: AppColors.powderPink,
        ),

        // Elegant Text Theme
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5, // Tighter spacing looks more elegant
          ),
          bodyLarge: TextStyle(color: AppColors.textBlack),
          bodyMedium: TextStyle(color: AppColors.textGrey),
        ),

        // Soft AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.powderPink,
          surfaceTintColor: Colors.transparent, // Removes material tint
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textBlack,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Serif', // Serif fonts often look more "food elegant"
          ),
          iconTheme: IconThemeData(color: AppColors.textBlack),
        ),

        // Rounded Inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceWhite,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Pill shape
            borderSide: BorderSide.none, // Clean look
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.softLilac,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
