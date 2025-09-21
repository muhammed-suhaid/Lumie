import 'package:flutter/material.dart';
import 'package:lumie/widgets/custom_button.dart';

class CustomSelectableTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isSplit;
  final VoidCallback onTap;

  const CustomSelectableTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isSplit = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return isSplit
        ? Expanded(
            child: CustomButton(
              text: label,
              type: ButtonType.outline,
              isFullWidth: true,
              height: 50,
              backgroundColor: selected
                  ? colorScheme.secondary
                  : Colors.transparent,
              textColor: selected
                  ? colorScheme.onSecondary
                  : colorScheme.onSurface,
              borderColor: selected
                  ? colorScheme.secondary
                  : colorScheme.onSurface,
              onPressed: onTap,
            ),
          )
        : CustomButton(
            text: label,
            type: ButtonType.outline,
            isFullWidth: true,
            height: 50,
            backgroundColor: selected
                ? colorScheme.secondary
                : Colors.transparent,
            textColor: selected
                ? colorScheme.onSecondary
                : colorScheme.onSurface,
            borderColor: selected
                ? colorScheme.secondary
                : colorScheme.onSurface,
            onPressed: onTap,
          );
  }
}
