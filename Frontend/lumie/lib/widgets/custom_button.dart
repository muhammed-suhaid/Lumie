import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';

enum ButtonType { primary, secondary, outline, text, elevated }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final bool? isIconRight;
  final double? iconSize;
  final double? fontSize;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.isIconRight,
    this.iconSize,
    this.fontSize,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    /// Loading spinner
    Widget buttonChild = isLoading
        ? SizedBox(
            width: AppConstants.kIconSizeM,
            height: AppConstants.kIconSizeM,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && isIconRight == null) ...[
                Icon(icon, size: iconSize ?? AppConstants.kIconSizeS),
                const SizedBox(width: AppConstants.kPaddingS),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? appConstantsTextColor(type, colorScheme),
                  fontSize: fontSize ?? AppConstants.kFontSizeM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isIconRight == true) ...[
                const SizedBox(width: AppConstants.kPaddingS),
                Icon(icon, size: iconSize ?? AppConstants.kIconSizeS),
              ],
            ],
          );

    /// Button style based on type
    Widget button;
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            foregroundColor: textColor ?? colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.kPaddingL,
              vertical: AppConstants.kPaddingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.kRadiusM,
              ),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.secondary,
            foregroundColor: textColor ?? colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.kRadiusM,
              ),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? colorScheme.primary,
            backgroundColor: backgroundColor,
            side: BorderSide(color: borderColor ?? colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.kRadiusM,
              ),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            foregroundColor: textColor ?? colorScheme.primary,
            elevation: 4,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.kRadiusM,
              ),
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    /// Handle sizing
    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        height: height ?? 50,
        child: button,
      );
    } else if (width != null || height != null) {
      button = SizedBox(width: width, height: height ?? 48, child: button);
    }

    return button;
  }

  /// Helper to set text color depending on type
  Color appConstantsTextColor(ButtonType type, ColorScheme colorScheme) {
    switch (type) {
      case ButtonType.primary:
        return colorScheme.onPrimary;
      case ButtonType.secondary:
        return colorScheme.onSecondary;
      default:
        return colorScheme.primary;
    }
  }
}
