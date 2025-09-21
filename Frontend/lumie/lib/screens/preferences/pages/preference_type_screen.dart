import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PreferenceTypePage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const PreferenceTypePage({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final choices = ["Monogamous", "Open", "Polyamorous", "Casual"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.preferenceTypeTitle,
            style: TextStyle(
              fontSize: AppConstants.kFontSizeXXL,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingL),
          //************************* ListView Builder *************************//
          ListView.separated(
            itemCount: choices.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => CustomSelectableTile(
              label: choices[index],
              selected: selected == choices[index],
              onTap: () => onSelected(choices[index]),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: AppConstants.kPaddingM),
          ),
        ],
      ),
    );
  }
}
