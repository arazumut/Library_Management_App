import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/constants/app_constants.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/services/storage_service.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _navigateToNextScreen();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  Future<void> _navigateToNextScreen() async {
    final StorageService storageService = Provider.of<StorageService>(context, listen: false);
    
    // Minimum splash duration
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final bool isLoggedIn = await storageService.isLoggedIn();
    final bool isFirstRun = await storageService.isFirstRun();
    
    if (isFirstRun) {
      // Navigate to onboarding
      AppRoutes.navigateToAndRemove(context, AppRoutes.onboarding);
    } else if (isLoggedIn) {
      // Navigate to home
      AppRoutes.navigateToAndRemove(context, AppRoutes.home);
    } else {
      // Navigate to login
      AppRoutes.navigateToAndRemove(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                // App name
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.headline1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // App version
                Text(
                  'v${AppConstants.appVersion}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
