import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PreferenceStatusPage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const PreferenceStatusPage({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  //************************* _option Widget *************************//
  Widget _option(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.kPaddingM),
      child: CustomSelectableTile(
        label: label,
        selected: selected == label,
        onTap: () => onSelected(label),
      ),
    );
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final items = [
      "Single",
      "Divorced",
      "Separated",
      "Widowed",
      "It's complicated",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.preferenceStatusTitle,
            style: TextStyle(
              fontSize: AppConstants.kFontSizeXXL,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingL),
          //************************* _option Widget Mapping *************************//
          ...items.map((i) => _option(i, context)),
        ],
      ),
    );
  }
}
