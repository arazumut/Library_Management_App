import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? buttonText;
  
  const ErrorView({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.buttonText,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.error,
              size: 72.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24.0),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    buttonText ?? 'Try Again',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
