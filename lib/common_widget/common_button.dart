import 'package:flutter/material.dart';
import '../core/res/colors.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFilled;
  final bool isOutlined;
  final bool isTransparent;
  final bool isLoading;
  final Color fillColor;
  final Color outlineColor;
  final Color? textColor;
  final double width;
  final double height;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isDisabled;


  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFilled = true,
    this.isOutlined = false,
    this.isTransparent = false,
    this.isLoading = false,
    this.fillColor = AppColor.primary,
    this.outlineColor = AppColor.primary,
    this.textColor,
    this.width = double.infinity,
    this.height = 50.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,

  });

  const CommonButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFilled = false,
    this.isOutlined = true,
    this.isTransparent = false,
    this.isLoading = false,
    this.fillColor = AppColor.primary,
    this.outlineColor = AppColor.primary,
    this.textColor,
    this.width = double.infinity,
    this.height = 50.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(elevation),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return fillColor.withOpacity(0.5);
            }
            return _getBackgroundColor();
          }),
       //   foregroundColor: WidgetStateProperty.all(textColor ?? Colors.white),
          side: WidgetStateProperty.all(
            isOutlined
                ? BorderSide(color: outlineColor, width: 1)
                : BorderSide.none,
          ),
          padding: WidgetStateProperty.all(padding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: borderRadius),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  /// Determines the background color based on button type and state
  Color _getBackgroundColor() {
    if (isTransparent) return Colors.transparent;
    if (isFilled) {
      return fillColor;
    } else {
      return AppColor.white;
    }
    return Colors.transparent; // Default for outlined button
  }

  /// Builds the button content with loading, icons, and text
  Widget _buildChild() {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 8)],
        Text(
          text,
          style:
              textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? Colors.grey
                    : textColor ?? (!isFilled ? AppColor.primary : Colors.white),
              ),
        ),
        if (suffixIcon != null) ...[const SizedBox(width: 8), suffixIcon!],
      ],
    );
  }
}
