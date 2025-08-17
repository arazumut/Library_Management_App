import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/constants/app_constants.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/services/storage_service.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Books',
      'description': 'Explore our vast collection of books across various genres and find your next favorite read.',
      'icon': 'Icons.menu_book',
    },
    {
      'title': 'Borrow & Read',
      'description': 'Easily borrow books from our library and enjoy reading at your own pace.',
      'icon': 'Icons.bookmark',
    },
    {
      'title': 'Track Your Reading',
      'description': 'Keep track of your borrowed books, reading progress, and manage your library experience.',
      'icon': 'Icons.track_changes',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                    icon: _onboardingData[index]['icon']!,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalPages,
                        (index) => _buildPageIndicator(index == _currentPage),
                      ),
                    ),
                    const Spacer(),
                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button
                        TextButton(
                          onPressed: _finishOnboarding,
                          child: Text(
                            'Skip',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        // Next/Done button
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _totalPages - 1) {
                              _finishOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _currentPage == _totalPages - 1 ? 'Start' : 'Next',
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String icon,
  }) {
    // Convert string icon name to actual IconData
    IconData iconData;
    switch (icon) {
      case 'Icons.menu_book':
        iconData = Icons.menu_book;
        break;
      case 'Icons.bookmark':
        iconData = Icons.bookmark;
        break;
      case 'Icons.track_changes':
        iconData = Icons.track_changes;
        break;
      default:
        iconData = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: AppTextStyles.headline2.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  void _finishOnboarding() async {
    // Mark first run as completed
    final storageService = Provider.of<StorageService>(context, listen: false);
    await storageService.setIsFirstRun(false);
    
    if (!mounted) return;
    
    // Navigate to login screen
    AppRoutes.navigateToAndRemove(context, AppRoutes.login);
  }
}
