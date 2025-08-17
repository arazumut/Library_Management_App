import 'package:flutter/material.dart';
import 'package:library_app/features/onboarding/views/onboarding_screen.dart';
import 'package:library_app/features/auth/views/login_screen.dart';
import 'package:library_app/features/home/views/home_screen.dart';
import 'package:library_app/features/books/views/add_book_screen.dart';
import 'package:library_app/features/libraries/views/add_library_screen.dart';
import 'package:library_app/features/libraries/views/libraries_screen.dart';
import 'package:library_app/features/libraries/views/library_detail_screen.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String bookDetails = '/book-details';
  static const String bookSearch = '/book-search';
  static const String bookAdd = '/book-add';
  static const String libraryManagement = '/library-management';
  static const String loanRequests = '/loan-requests';
  static const String loanHistory = '/loan-history';
  static const String bookRequests = '/book-requests';
  static const String bookReviews = '/book-reviews';
  static const String notifications = '/notifications';
  static const String readingGoals = '/reading-goals';
  static const String settings = '/settings';
  static const String libraries = '/libraries';
  static const String libraryAdd = '/library-add';
  static const String libraryDetail = '/library-detail';
  static const String libraryEdit = '/library-edit';
  
  // Route Map
  static Map<String, WidgetBuilder> routes = {
    // Initial Routes will be defined here later
  };
  
  // Navigation Methods
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  static Future<T?> navigateToAndRemove<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName, 
      (route) => false,
      arguments: arguments
    );
  }
  
  static Future<T?> navigateToAndReplace<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed(
      context, 
      routeName,
      arguments: arguments
    );
  }
  
  static void goBack<T>(BuildContext context, [T? result]) {
    return Navigator.pop(context, result);
  }
  
  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments; // Uncomment when needed
    
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case bookAdd:
        return MaterialPageRoute(
          builder: (_) => const AddBookScreen(),
        );
      case libraryAdd:
      case libraryManagement:
        return MaterialPageRoute(
          builder: (_) => const AddLibraryScreen(),
        );
      case libraries:
        return MaterialPageRoute(
          builder: (_) => const LibrariesScreen(),
        );
      case libraryDetail:
        return MaterialPageRoute(
          builder: (_) => LibraryDetailScreen(
            libraryId: settings.arguments as int,
          ),
        );
      // Add more routes here as they are implemented
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}
