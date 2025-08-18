import '../../core/network/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/books/services/book_service.dart';
import '../../features/libraries/services/library_service.dart';
import '../../features/loans/services/loan_service.dart';

class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();
  ServiceLocator._();

  // Storage Service
  late final StorageService _storageService;

  // API Service
  late final ApiService _apiService;

  // Services
  late final AuthService _authService;
  late final BookService _bookService;
  late final LibraryService _libraryService;
  late final LoanService _loanService;

  // Initialize all services
  Future<void> init() async {
    // Storage service
    _storageService = StorageService();
    await _storageService.init();

    // API service
    _apiService = ApiService(_storageService);

    // Other services
    _authService = AuthService(
      apiService: _apiService,
      storageService: _storageService,
    );

    _bookService = BookService(apiService: _apiService);
    _libraryService = LibraryService(apiService: _apiService);
    _loanService = LoanService(apiService: _apiService);
  }

  // Getters
  StorageService get storageService => _storageService;
  ApiService get apiService => _apiService;
  AuthService get authService => _authService;
  BookService get bookService => _bookService;
  LibraryService get libraryService => _libraryService;
  LoanService get loanService => _loanService;
}
