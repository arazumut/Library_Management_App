class ApiEndpoints {
  // Base URL - NetworkConfig'den al
  static String get baseUrl => 'http://localhost:8000/api';

  // Auth Endpoints - Django Token Auth
  static const String login = '/token/';
  static const String userProfile = '/users/me/';
  static const String refreshToken = '/token/refresh/';

  // User Endpoints
  static const String users = '/users/';
  static const String userDetail = '/users/{id}/';
  static const String changePassword = '/users/change-password/';

  // Book Endpoints
  static const String books = '/books/';
  static const String bookDetail = '/books/{id}/';
  static const String booksByCategory = '/categories/{id}/books/';

  // Category Endpoints
  static const String categories = '/categories/';
  static const String categoryDetail = '/categories/{id}/';

  // Library Endpoints
  static const String libraries = '/libraries/';
  static const String libraryDetail = '/libraries/{id}/';
  static const String libraryBooks = '/libraries/{id}/books/';

  // Loan Endpoints
  static const String loans = '/loans/';
  static const String loanDetail = '/loans/{id}/';
  static const String userLoans = '/users/{id}/loans/';
  static const String borrowBook = '/loans/';
  static const String returnBook = '/loans/{id}/return/';

  // Notification Endpoints (Django admin panel ile ileride eklenebilir)
  static const String notifications = '/notifications/';
  static const String markNotificationRead = '/notifications/{id}/read/';

  // Helper method to replace path parameters
  static String replacePathParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
