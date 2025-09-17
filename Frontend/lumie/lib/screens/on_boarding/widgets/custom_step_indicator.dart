import 'package:flutter/material.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    //************************* Step Indicator widget *************************//
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.secondary : colorScheme.primary,
            borderRadius: BorderRadius.circular(isActive ? 4 : 50),
          ),
        );
      }),
    );
  }
}
