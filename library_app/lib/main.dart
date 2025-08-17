import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:library_app/core/constants/app_constants.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/services/database_service.dart';
import 'package:library_app/core/services/storage_service.dart';
import 'package:library_app/core/services/theme_service.dart';
import 'package:library_app/core/theme/app_theme.dart';
import 'package:library_app/features/auth/view_models/auth_view_model.dart';
import 'package:library_app/core/network/api_service.dart';
import 'package:library_app/features/auth/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize database service
  final databaseService = DatabaseService();
  await databaseService.database; // This initializes the database
  
  // Initialize API service
  final apiService = ApiService(storageService);
  
  // Initialize theme service
  final themeService = ThemeService(storageService);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<DatabaseService>.value(value: databaseService),
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(apiService, storageService),
        ),
        ChangeNotifierProvider<ThemeService>(
          create: (_) => themeService,
        ),
        // Add more providers here as needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    
    // Load language setting
    final languageSetting = await storageService.getLanguage();
    if (languageSetting != null) {
      setState(() {
        _locale = Locale(languageSetting, '');
      });
    } else {
      // Varsayılan olarak Türkçe ayarla
      setState(() {
        _locale = const Locale('tr', '');
      });
      await storageService.saveLanguage('tr');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeService kullanarak tema modunu al
    final themeService = Provider.of<ThemeService>(context);
    
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('tr', ''), // Turkish
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
