class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://api.libraryapp.com/api/v1'; // Placeholder API URL
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadProfileImage = '/users/profile/image';
  static const String changePassword = '/users/change-password';
  static const String notificationSettings = '/users/notification-settings';
  
  // Book Endpoints
  static const String books = '/books';
  static const String bookDetails = '/books/{id}';
  static const String bookCategories = '/books/categories';
  static const String bookSearch = '/books/search';
  static const String bookReviews = '/books/{id}/reviews';
  static const String addBookReview = '/books/{id}/reviews';
  static const String uploadBookImage = '/books/{id}/image';
  
  // Library Endpoints
  static const String libraries = '/libraries';
  static const String libraryDetails = '/libraries/{id}';
  static const String libraryBooks = '/libraries/{id}/books';
  static const String libraryStats = '/libraries/{id}/stats';
  
  // Loan Endpoints
  static const String loans = '/loans';
  static const String loanDetails = '/loans/{id}';
  static const String userLoans = '/users/loans';
  static const String borrowBook = '/loans/borrow';
  static const String returnBook = '/loans/{id}/return';
  static const String extendLoan = '/loans/{id}/extend';
  
  // Reservation Endpoints
  static const String reservations = '/reservations';
  static const String userReservations = '/users/reservations';
  static const String reserveBook = '/reservations/reserve';
  static const String cancelReservation = '/reservations/{id}/cancel';
  
  // Request Endpoints
  static const String bookRequests = '/requests';
  static const String userRequests = '/users/requests';
  static const String createRequest = '/requests/create';
  static const String updateRequest = '/requests/{id}';
  
  // Reading Goals Endpoints
  static const String readingGoals = '/goals';
  static const String userReadingGoals = '/users/goals';
  static const String createReadingGoal = '/goals/create';
  static const String updateReadingGoal = '/goals/{id}';
  static const String readingStats = '/users/reading-stats';
  
  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
  
  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, dynamic> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
