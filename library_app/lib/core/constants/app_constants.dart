class AppConstants {
  // App Info
  static const String appName = 'Library App';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String prefsThemeMode = 'theme_mode';
  static const String prefsLanguageCode = 'language_code';
  static const String prefsToken = 'auth_token';
  static const String prefsRefreshToken = 'refresh_token';
  static const String prefsUserId = 'user_id';
  static const String prefsUserData = 'user_data';
  static const String prefsOnboardingComplete = 'onboarding_complete';
  
  // Theme Modes
  static const String themeModeSystem = 'system';
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';
  
  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 400);
  static const Duration animSlow = Duration(milliseconds: 800);
  
  // Pagination
  static const int pageSize = 20;
  
  // Default Book Cover URL
  static const String defaultBookCoverUrl = 'https://via.placeholder.com/150x220?text=No+Cover';
  
  // Default User Avatar URL
  static const String defaultAvatarUrl = 'https://via.placeholder.com/150?text=User';
  
  // Book Categories
  static const List<String> bookCategories = [
    'Fiction',
    'Non-Fiction',
    'Science Fiction',
    'Fantasy',
    'Romance',
    'Mystery',
    'Thriller',
    'Horror',
    'Historical Fiction',
    'Biography',
    'Self-Help',
    'Business',
    'Children',
    'Young Adult',
    'Poetry',
    'Comics',
    'Cookbooks',
    'Art',
    'Travel',
    'Religion',
    'Science',
    'Technology',
    'Education',
    'Health',
    'Sports',
    'Other',
  ];
  
  // Book Languages
  static const List<String> bookLanguages = [
    'English',
    'Turkish',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Arabic',
    'Hindi',
    'Korean',
    'Dutch',
    'Other',
  ];
  
  // User Roles
  static const String roleReader = 'reader';
  static const String roleLibrarian = 'librarian';
  static const String roleAdmin = 'admin';
  
  // Book Status
  static const String bookStatusAvailable = 'available';
  static const String bookStatusBorrowed = 'borrowed';
  static const String bookStatusReserved = 'reserved';
  static const String bookStatusNotAvailable = 'not_available';
  
  // Loan Status
  static const String loanStatusPending = 'pending';
  static const String loanStatusActive = 'active';
  static const String loanStatusReturned = 'returned';
  static const String loanStatusLate = 'late';
  static const String loanStatusRejected = 'rejected';
  
  // Request Status
  static const String requestStatusPending = 'pending';
  static const String requestStatusApproved = 'approved';
  static const String requestStatusRejected = 'rejected';
  
  // Notification Types
  static const String notificationLoanDue = 'loan_due';
  static const String notificationLoanApproved = 'loan_approved';
  static const String notificationLoanRejected = 'loan_rejected';
  static const String notificationBookAvailable = 'book_available';
  static const String notificationBookAdded = 'book_added';
  static const String notificationReservationAvailable = 'reservation_available';
  static const String notificationSystemAnnouncement = 'system_announcement';
}
