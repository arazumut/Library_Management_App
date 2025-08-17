import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';
import 'package:library_app/core/localization/app_localizations.dart';
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
      // This will be implemented when the AuthViewModel is created
      // final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      // await authViewModel.login(
      //   email: _emailController.text,
      //   password: _passwordController.text,
      //   rememberMe: _rememberMe,
      // );
      
      // For now, navigate to home screen directly
      if (!mounted) return;
      AppRoutes.navigateToAndRemove(context, AppRoutes.home);
    }
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
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      size: 60,
                      color: Colors.white,
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
