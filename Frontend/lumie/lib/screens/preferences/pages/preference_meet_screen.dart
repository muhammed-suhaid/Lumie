import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PreferenceMeetPage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const PreferenceMeetPage({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.preferenceMeetTitle,
            style: TextStyle(
              fontSize: AppConstants.kFontSizeXXL,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingL),
          //************************* Custom Selectable tiles *************************//
          CustomSelectableTile(
            label: AppTexts.man,
            selected: selected == AppTexts.man,
            onTap: () => onSelected(AppTexts.man),
          ),
          const SizedBox(height: AppConstants.kPaddingM),
          CustomSelectableTile(
            label: AppTexts.women,
            selected: selected == AppTexts.women,
            onTap: () => onSelected(AppTexts.women),
          ),
          const SizedBox(height: AppConstants.kPaddingM),
          CustomSelectableTile(
            label: AppTexts.everyone,
            selected: selected == AppTexts.everyone,
            onTap: () => onSelected(AppTexts.everyone),
          ),
        ],
      ),
    );
  }
}
