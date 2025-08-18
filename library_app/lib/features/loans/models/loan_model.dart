import '../../../features/books/models/book_model.dart';
import '../../../features/auth/models/user_model.dart';

class LoanModel {
  final int id;
  final BookModel book;
  final UserModel user;
  final DateTime loanDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoanModel({
    required this.id,
    required this.book,
    required this.user,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a LoanModel from Django API JSON
  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as int,
      book: BookModel.fromJson(json['book'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      loanDate: DateTime.parse(json['loan_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      returnDate:
          json['return_date'] != null
              ? DateTime.parse(json['return_date'] as String)
              : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON map for creating/updating
  Map<String, dynamic> toJson() {
    return {
      'book_id': book.id,
      'user_id': user.id,
      'loan_date': loanDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  // Convert to JSON map with full data
  Map<String, dynamic> toFullJson() {
    return {
      'id': id,
      'book': book.toFullJson(),
      'user': user.toJson(),
      'loan_date': loanDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with some updated fields
  LoanModel copyWith({
    int? id,
    BookModel? book,
    UserModel? user,
    DateTime? loanDate,
    DateTime? dueDate,
    DateTime? returnDate,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LoanModel(
      id: id ?? this.id,
      book: book ?? this.book,
      user: user ?? this.user,
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isActive => status == 'active';
  bool get isReturned => status == 'returned';
  bool get isOverdue => isActive && DateTime.now().isAfter(dueDate);

  int get daysUntilDue {
    if (isReturned) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }

  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  Duration get loanDuration {
    final endDate = returnDate ?? DateTime.now();
    return endDate.difference(loanDate);
  }
}
