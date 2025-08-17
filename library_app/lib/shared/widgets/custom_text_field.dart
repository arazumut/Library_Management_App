import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final bool enabled;
  final String? initialValue;
  final bool required;
  
  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.contentPadding,
    this.enabled = true,
    this.initialValue,
    this.required = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  label!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (required)
                  Text(
                    ' *',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding: contentPadding ?? const EdgeInsets.all(16.0),
            filled: true,
            fillColor: enabled ? null : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.textLight,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.textLight,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2.0,
              ),
            ),
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          autofocus: autofocus,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          validator: validator ?? (required ? (value) => ValidationUtils.validateRequired(value, label ?? 'Field') : null),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
