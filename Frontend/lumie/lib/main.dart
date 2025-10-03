import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/firebase_options.dart';
import 'package:lumie/screens/chat_screen/chat_list_screen.dart';
import 'package:lumie/screens/discover_screen/discover_screen.dart';
import 'package:lumie/screens/match_screen/match_screen.dart';
import 'package:lumie/screens/profile/profile_screen.dart';
import 'package:lumie/utils/app_colors.dart';
import 'package:lumie/widgets/tab_screen.dart';

void main() async {
  // Firebase Initizing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

      // Automatically follows system mode
      themeMode: ThemeMode.system,
      // TODO: change to Get Started Screen
      home: const TabScreen(
        pages: [
          // Discover screen
          DiscoverScreen(),
          // Matches Screen
          MatchesScreen(),
          // Chat Screen
          ChatsListScreen(),
          // Profile Screen
          ProfileScreen(),
        ],
      ),
    );
  }
}
