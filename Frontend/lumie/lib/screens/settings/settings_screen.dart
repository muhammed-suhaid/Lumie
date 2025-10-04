import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/auth/auth_screen.dart';
import 'package:lumie/screens/legal/privacy_policy_screen.dart';
import 'package:lumie/screens/legal/terms_conditions_screen.dart';
import 'package:lumie/screens/payment/payment_screen.dart';
import 'package:lumie/screens/profile/profile_screen.dart';
import 'package:lumie/services/ad_service.dart';
import 'package:lumie/services/phone_auth_service.dart';
import 'package:lumie/services/profile_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ProfileService _profileService = ProfileService();

  String profileImageUrl = "";
  String userName = "";
  // bool isAdFree = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   AdService.loadBannerAd(context);
    // });
  }

  @override
  void dispose() {
    AdService.disposeBannerAd();
    super.dispose();
  }

  //************************* load user Profile *************************//
  Future<void> _loadUserProfile() async {
    final user = await _profileService.getUserProfile();
    if (user != null && mounted) {
      setState(() {
        profileImageUrl = user.profileImage;
        userName = user.name;
        isLoading = false;
        // isAdFree = user.isAdFree;
      });
    }
  }

  //************************* signOut method *************************//
  Future<void> _signOut(BuildContext context) async {
    try {
      await PhoneAuthService.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      CustomSnackbar.show(context, "Failed to sign out", isError: true);
    }
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.kFontSizeL,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.kPaddingL),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // if (!isAdFree) AdService.getBannerAdWidget(),

                  //************************* Profile Image *************************//
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage("assets/default_profile.png")
                              as ImageProvider,
                  ),

                  const SizedBox(height: 12),

                  //************************* User Name *************************//
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  //************************* Custom button *************************//
                  CustomButton(
                    text: "View Full Profile",
                    type: ButtonType.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  const Divider(),

                  //************************* Privacy Policy *************************//
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text(AppTexts.privacyPolicy),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  //************************* Terms & Conditions *************************//
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text(AppTexts.termsAndConditions),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsConditionsScreen(),
                        ),
                      );
                    },
                  ),
                  //************************* Payment *************************//
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text("Payment"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                  ),
                  //************************* SignOut *************************//
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _signOut(context),
                  ),
                ],
              ),
            ),
    );
  }
}
