import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/screens/legal/privacy_policy_screen.dart';
import 'package:lumie/screens/legal/terms_conditions_screen.dart';
import 'package:lumie/services/razorpay_service.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late RazorpayService _razorpayService;
  String? selectedPlan;
  int? selectedAmount;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService(
      onPaymentSuccess: _handlePaymentSuccess,
      onPaymentError: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  //************************* Handlers *************************//
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final planEndDate = selectedPlan == "monthly"
        ? DateTime.now().add(const Duration(days: 30))
        : DateTime.now().add(const Duration(days: 365));

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    await userDoc.update({
      'isAdFree': true,
      'paymentHistory': {
        'planType': selectedPlan,
        'planStart': Timestamp.now(),
        'planEnd': Timestamp.fromDate(planEndDate),
        'lastPaymentId': response.paymentId,
        'amountPaid': selectedAmount,
      },
    });

    if (mounted) {
      CustomSnackbar.show(
        context,
        "Payment successful and plan updated!",
        isError: false,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackbar.show(context, "Payment Failed ❌ ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbar.show(context, "External Wallet: ${response.walletName}");
  }

  //************************* Start Payment *************************//
  void _startPayment() {
    final user = FirebaseAuth.instance.currentUser;

    if (selectedPlan == null || selectedAmount == null) {
      CustomSnackbar.show(context, "Please select a plan first");
      return;
    }

    CustomSnackbar.show(
      context,
      "Proceeding with ${selectedPlan == 'monthly' ? '1 Month Plan' : '1 Year Plan'}",
      isError: false,
    );

    _razorpayService.openCheckout(
      amount: selectedAmount!,
      planName: selectedPlan!,
      contact: user?.phoneNumber ?? "user",
      email: user?.email ?? "user@email.com",
      userId: user?.uid ?? "unknown",
    );
  }

  //************************* Build *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              id: "monthly",
              title: "1 Month Plan",
              price: "₹199",
              subtitle: "Billed Monthly",
              amount: 199,
              isPopular: false,
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              id: "yearly",
              title: "1 Year Plan",
              price: "₹1499",
              subtitle: "Save 35% compared to monthly",
              amount: 1499,
              isPopular: true,
            ),
            const Spacer(),

            //************************* Payment Button *************************//
            if (selectedPlan != null)
              CustomButton(
                text: "Proceed to Payment",
                isFullWidth: true,
                type: ButtonType.primary,
                backgroundColor: colorScheme.secondary,
                textColor: colorScheme.onPrimary,
                borderRadius: AppConstants.kRadiusM,
                fontSize: AppConstants.kFontSizeM,
                onPressed: _startPayment,
              ),
            const SizedBox(height: 20),

            //************************* Legal *************************//
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
                CustomButton(
                  text: AppTexts.termsAndConditions,
                  type: ButtonType.text,
                  textColor: colorScheme.secondary,
                  fontSize: AppConstants.kFontSizeXS,
                  onPressed: () {
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
                CustomButton(
                  text: AppTexts.privacyPolicy,
                  type: ButtonType.text,
                  textColor: colorScheme.secondary,
                  fontSize: AppConstants.kFontSizeXS,
                  onPressed: () {
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
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  //************************* Plan Card Widget *************************//
  Widget _buildPlanCard(
    BuildContext context, {
    required String id,
    required String title,
    required String price,
    required String subtitle,
    required int amount,
    bool isPopular = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isSelected = selectedPlan == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = id;
          selectedAmount = amount;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.secondary
                : (isPopular
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(80)),
            width: isSelected ? 3 : 1.5,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colorScheme.secondary.withAlpha(100)
                  : colorScheme.onSurface.withAlpha(80),
              blurRadius: isSelected ? 12 : 6,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
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
        ),
      ),
    );
  }
}
