import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50.0,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: 1.5,
          ),
          foregroundColor: textColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: textColor ?? AppColors.primary,
                ),
              ),
      ),
    );
  }
}
