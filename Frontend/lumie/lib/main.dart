import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/utils/app_colors.dart';
import 'package:lumie/widgets/tab_screen.dart';

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
        scaffoldBackgroundColor: AppColors.lilacBackground,
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
      home: TabScreen(
        pages: [
          const SizedBox(
            child: Center(child: Text("Discover screen")),
          ), // Discover screen
          const SizedBox(
            child: Center(child: Text("Match Requests Screen")),
          ), // Match Requests Screen
          const SizedBox(
            child: Center(child: Text("Chat Screen")),
          ), // Chat Screen
          const SizedBox(
            child: Center(child: Text("Profile Screen")),
          ), // Profile settings
        ],
      ),
      // TODO: Change to GetStartedScreen
    );
  }
}
