import 'category_model.dart';

class BookModel {
  final int id;
  final String title;
  final String isbn;
  final String author;
  final String publisher;
  final int publicationYear;
  final String description;
  final String? coverImage;
  final CategoryModel category;
  final int pages;
  final String language;
  final String status;
  final bool available;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookModel({
    required this.id,
    required this.title,
    required this.isbn,
    required this.author,
    required this.publisher,
    required this.publicationYear,
    required this.description,
    this.coverImage,
    required this.category,
    required this.pages,
    required this.language,
    required this.status,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a BookModel from Django API JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isbn: json['isbn'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      publicationYear: json['publication_year'] as int,
      description: json['description'] as String,
      coverImage: json['cover_image'] as String?,
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      pages: json['pages'] as int,
      language: json['language'] as String,
      status: json['status'] as String,
      available: json['available'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON map for creating/updating (without nested category)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isbn': isbn,
      'author': author,
      'publisher': publisher,
      'publication_year': publicationYear,
      'description': description,
      'category_id': category.id, // Only send category ID
      'pages': pages,
      'language': language,
      'status': status,
    };
  }

  // Convert to JSON map with full data (for display)
  Map<String, dynamic> toFullJson() {
    return {
      'id': id,
      'title': title,
      'isbn': isbn,
      'author': author,
      'publisher': publisher,
      'publication_year': publicationYear,
      'description': description,
      'cover_image': coverImage,
      'category': category.toJson(),
      'pages': pages,
      'language': language,
      'status': status,
      'available': available,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with some updated fields
  BookModel copyWith({
    int? id,
    String? title,
    String? isbn,
    String? author,
    String? publisher,
    int? publicationYear,
    String? description,
    String? coverImage,
    CategoryModel? category,
    int? pages,
    String? language,
    String? status,
    bool? available,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isbn: isbn ?? this.isbn,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publicationYear: publicationYear ?? this.publicationYear,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      category: category ?? this.category,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      status: status ?? this.status,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status helper methods
  bool get isAvailable => status == 'available' && available;
  bool get isLoanedOut => status == 'loaned';
  bool get isReserved => status == 'reserved';
  bool get isLost => status == 'lost';
  bool get isDamaged => status == 'damaged';

  // Compatibility properties with old Book model
  String? get coverUrl => coverImage;
  DateTime? get publishDate => DateTime(publicationYear);
  double get rating => 4.0; // Default rating
  bool get isFavorite => false; // To be implemented with user favorites
  List<dynamic>? get reviews => null; // To be implemented with reviews system
}
