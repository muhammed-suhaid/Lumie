import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/get_started/get_started_screen.dart';
import 'package:lumie/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumie',
      // Light theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryLavender,
          secondary: AppColors.deepPurple,
          surface: AppColors.lilacBackground,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.deepPurple,
        ),
      ),
      // Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground1,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.textWhite,
          displayColor: AppColors.textWhite,
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.darkLavender,
          secondary: AppColors.darkDeepPurple,
          surface: AppColors.darkSurfaceDeep,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.textWhite,
        ),
      ),

      // Automatically follows system dark mode
      themeMode: ThemeMode.system,
      home: GetStartedScreen(),
    );
  }
}
