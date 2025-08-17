import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/features/books/views/books_screen.dart';
import 'package:library_app/features/home/views/home_tab.dart';
import 'package:library_app/features/loans/views/loans_screen.dart';
import 'package:library_app/features/profile/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const BooksScreen(),
    const LoansScreen(),
    const ProfileScreen(),
  ];
  
  List<String> _getTitles(BuildContext context) {
    return [
      context.l10n.translate('Anasayfa'),
      context.l10n.translate('Tüm Kitaplar'),
      context.l10n.translate('Ödünçler'),
      context.l10n.translate('Profil'),
    ];
  }
  
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitles(context)[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.caption,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.translate('Anasayfa'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: context.l10n.translate('Tüm Kitaplar'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_online),
            label: context.l10n.translate('Ödünçler'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.l10n.translate('Profil'),
          ),
        ],
      ),
    );
  }
}
