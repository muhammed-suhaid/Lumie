//************************* Imports *************************//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/legal/privacy_policy_screen.dart';
import 'package:lumie/screens/legal/terms_conditions_screen.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //************************* Appbar *************************//
      appBar: AppBar(
        title: Text(
          "Upgrade to Ad-Free",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.kFontSizeL,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //************************* Header *************************//
            const SizedBox(height: 30),
            Icon(
              Icons.workspace_premium,
              size: 80,
              color: Colors.amber.shade600,
            ),
            const SizedBox(height: 20),
            Text(
              "Enjoy Lumie without Ads",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Free plan gives you full access, but with ads.\nUpgrade to remove ads completely.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            //************************* Plans *************************//
            _buildPlanCard(
              context,
              title: "1 Month Plan",
              price: "₹199",
              subtitle: "Billed Monthly",
              isPopular: false,
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              title: "1 Year Plan",
              price: "₹1499",
              subtitle: "Save 35% compared to monthly",
              isPopular: true,
            ),

            const Spacer(),

            //************************* Privacy Policy And Terms & Conditions *************************//
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By continuing, you agree to our ",
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeXS,
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                ),

                // Terms & Conditions button
                CustomButton(
                  text: AppTexts.termsAndConditions,
                  type: ButtonType.text,
                  textColor: colorScheme.secondary,
                  fontSize: AppConstants.kFontSizeXS,
                  onPressed: () {
                    debugPrint("Navigate to Terms & Conditions");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsConditionsScreen(),
                      ),
                    );
                  },
                ),

                Text(
                  " and ",
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.kFontSizeXS,
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                ),

                // Privacy Policy button
                CustomButton(
                  text: AppTexts.privacyPolicy,
                  type: ButtonType.text,
                  textColor: colorScheme.secondary,
                  fontSize: AppConstants.kFontSizeXS,
                  onPressed: () {
                    debugPrint("Navigate to Privacy Policy");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  //************************* Plan Card Widget *************************//
  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String subtitle,
    bool isPopular = false,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? colorScheme.secondary : colorScheme.primary,
          width: 2,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.secondary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              price,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (isPopular)
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Popular",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          // TODO: Handle payment logic
          CustomSnackbar.show(context, "Selected $title", isError: false);
        },
      ),
    );
  }
}
