import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);

    // Create an overlay entry for the snackbar
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: AppConstants.kPaddingL,
        left: AppConstants.kPaddingL,
        right: AppConstants.kPaddingL,
        child: _SnackbarAnimated(message: message, isError: isError),
      ),
    );

    // Insert overlay
    overlay.insert(overlayEntry);

    // Remove overlay after the duration + animation time
    Future.delayed(duration + const Duration(milliseconds: 300), () {
      overlayEntry.remove();
    });
  }
}

//************************* Animated Snackbar Widget *************************//
class _SnackbarAnimated extends StatefulWidget {
  final String message;
  final bool isError;

  const _SnackbarAnimated({required this.message, this.isError = true});

  @override
  State<_SnackbarAnimated> createState() => _SnackbarAnimatedState();
}

class _SnackbarAnimatedState extends State<_SnackbarAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    //************************* Animation Controller *************************//
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Slide from bottom to its position
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Fade in animation
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start animations
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Material(
          color: widget.isError ? Colors.red[400] : Colors.green[400],
          borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.kPaddingM,
              horizontal: AppConstants.kPaddingL,
            ),
            child: Text(
              widget.message,
              style: const TextStyle(
                fontSize: AppConstants.kFontSizeM,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
