import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/features/auth/view_models/auth_view_model.dart';
import 'package:library_app/shared/widgets/custom_text_field.dart';
import 'package:library_app/shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      // Show loading indicator
      _showLoadingDialog();
      
      final success = await authViewModel.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
      
      // Hide loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (success) {
        if (!mounted) return;
        AppRoutes.navigateToAndRemove(context, AppRoutes.home);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.errorMessage ?? context.l10n.translate('login_failed'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Giriş yapılıyor..."),
            ],
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo and App name
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.cardDark 
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.menu_book,
                      size: 60,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.primaryLight
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.translate('app_name'),
                    style: AppTextStyles.headline1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.translate('sign_in_to_continue'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    label: context.l10n.translate('email'),
                    hint: context.l10n.translate('enter_email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationUtils.validateEmail,
                    prefix: const Icon(Icons.email_outlined),
                    textInputAction: TextInputAction.next,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    label: context.l10n.translate('password'),
                    hint: context.l10n.translate('enter_password'),
                    obscureText: _obscurePassword,
                    validator: (value) => ValidationUtils.validateRequired(value, context.l10n.translate('password')),
                    prefix: const Icon(Icons.lock_outline),
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    required: true,
                  ),
                  const SizedBox(height: 8),
                  
                  // Remember me and Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          Text(
                            context.l10n.translate('remember_me'),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          AppRoutes.navigateTo(context, AppRoutes.forgotPassword);
                        },
                        child: Text(
                          context.l10n.translate('forgot_password'),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Login button
                  PrimaryButton(
                    text: context.l10n.translate('login'),
                    onPressed: _login,
                  ),
                  const SizedBox(height: 16),
                  
                  // Register option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.translate('dont_have_account'),
                        style: AppTextStyles.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          AppRoutes.navigateTo(context, AppRoutes.register);
                        },
                        child: Text(
                          context.l10n.translate('register'),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Social login options (to be implemented)
                  Text(
                    context.l10n.translate('or_sign_in_with'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google
                      _buildSocialLoginButton(
                        icon: Icons.g_mobiledata,
                        onTap: () {
                          // Implement Google sign in
                        },
                      ),
                      const SizedBox(width: 16),
                      // Facebook
                      _buildSocialLoginButton(
                        icon: Icons.facebook,
                        onTap: () {
                          // Implement Facebook sign in
                        },
                      ),
                      const SizedBox(width: 16),
                      // Apple (for iOS)
                      _buildSocialLoginButton(
                        icon: Icons.apple,
                        onTap: () {
                          // Implement Apple sign in
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialLoginButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 32,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
