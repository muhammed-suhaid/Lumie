import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PreferenceGoalPage extends StatelessWidget {
  final String? selectedMain;
  final String? selectedSub;
  final ValueChanged<String> onMainSelected;
  final ValueChanged<String> onSubSelected;

  const PreferenceGoalPage({
    super.key,
    required this.selectedMain,
    required this.selectedSub,
    required this.onMainSelected,
    required this.onSubSelected,
  });

  //************************* _openGoalSubModal method *************************//
  void _openGoalSubModal(BuildContext context) {
    final options = [
      "Short-Term",
      "Long-Term",
      "Short-Term Open to Long",
      "Open",
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.kPaddingM),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, (1 - value) * 50),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((o) {
                  final isSel = selectedSub == o;
                  return ListTile(
                    title: Text(o),
                    trailing: isSel ? const Icon(Icons.check) : null,
                    onTap: () {
                      Navigator.pop(context);
                      onSubSelected(o);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* title *************************//
          Text(
            AppTexts.preferenceGoalTitle,
            style: TextStyle(
              fontSize: AppConstants.kFontSizeXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingS),
          //************************* subTitle *************************//
          Text(AppTexts.preferenceGoalSubTitle),
          const SizedBox(height: AppConstants.kPaddingL),

          // Options
          CustomSelectableTile(
            label: AppTexts.dating,
            selected: selectedMain == AppTexts.dating,
            onTap: () {
              onMainSelected(AppTexts.dating);
              _openGoalSubModal(context);
            },
          ),
          const SizedBox(height: AppConstants.kPaddingM),
          CustomSelectableTile(
            label: AppTexts.friends,
            selected: selectedMain == AppTexts.friends,
            onTap: () => onMainSelected(AppTexts.friends),
          ),

          const Spacer(),

          if (selectedMain == AppTexts.dating && selectedSub != null)
            Text(
              "Selected: $selectedSub",
              style: TextStyle(color: colorScheme.onSurface.withAlpha(180)),
            ),
        ],
      ),
    );
  }
}
