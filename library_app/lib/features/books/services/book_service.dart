import 'package:flutter/material.dart';
import 'package:library_app/core/services/database_service.dart';

class Book {
  final int? id;
  final String title;
  final String author;
  final String? coverUrl;
  final String publisher;
  final DateTime? publishDate;
  final int pages;
  final String isbn;
  final String language;
  final String category;
  final String description;
  final double rating;
  final bool available;
  final int libraryId;
  final List<BookReview>? reviews;
  final bool isFavorite;
  
  Book({
    this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.publisher,
    this.publishDate,
    required this.pages,
    required this.isbn,
    required this.language,
    required this.category,
    required this.description,
    this.rating = 0.0,
    this.available = true,
    required this.libraryId,
    this.reviews,
    this.isFavorite = false,
  });
  
  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? coverUrl,
    String? publisher,
    DateTime? publishDate,
    int? pages,
    String? isbn,
    String? language,
    String? category,
    String? description,
    double? rating,
    bool? available,
    int? libraryId,
    List<BookReview>? reviews,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      publisher: publisher ?? this.publisher,
      publishDate: publishDate ?? this.publishDate,
      pages: pages ?? this.pages,
      isbn: isbn ?? this.isbn,
      language: language ?? this.language,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      available: available ?? this.available,
      libraryId: libraryId ?? this.libraryId,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'publisher': publisher,
      'publishDate': publishDate?.toIso8601String(),
      'pages': pages,
      'isbn': isbn,
      'language': language,
      'category': category,
      'description': description,
      'rating': rating,
      'available': available ? 1 : 0,
      'libraryId': libraryId,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
  
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverUrl: map['coverUrl'],
      publisher: map['publisher'],
      publishDate: map['publishDate'] != null ? DateTime.parse(map['publishDate']) : null,
      pages: map['pages'],
      isbn: map['isbn'],
      language: map['language'],
      category: map['category'],
      description: map['description'],
      rating: map['rating'],
      available: map['available'] == 1,
      libraryId: map['libraryId'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}

class BookReview {
  final int? id;
  final int bookId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  
  BookReview({
    this.id,
    required this.bookId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
  
  factory BookReview.fromMap(Map<String, dynamic> map) {
    return BookReview(
      id: map['id'],
      bookId: map['bookId'],
      userId: map['userId'],
      userName: map['userName'],
      rating: map['rating'],
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }
}

class BookService {
  final DatabaseService _databaseService;

  BookService({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  Future<List<Book>> getBooks({int? libraryId}) async {
    final db = await _databaseService.database;
    
    String query;
    List<dynamic> args;
    
    if (libraryId != null) {
      query = 'SELECT * FROM books WHERE libraryId = ?';
      args = [libraryId];
    } else {
      query = 'SELECT * FROM books';
      args = [];
    }
    
    // Simulated delay to represent database access
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simulated data for demonstration
    return _getMockBooks(libraryId: libraryId);
  }

  Future<Book?> getBookById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulated data for demonstration
    final mockBooks = _getMockBooks();
    final book = mockBooks.firstWhere((book) => book.id == id, orElse: () => mockBooks[0]);
    
    // Also get reviews for the book
    final reviews = await getBookReviews(id);
    return book.copyWith(reviews: reviews);
  }

  Future<bool> addBook(Book book) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> updateBook(Book book) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> deleteBook(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> borrowBook(int bookId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> returnBook(int bookId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> toggleFavorite(int bookId, bool isFavorite) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<List<BookReview>> getBookReviews(int bookId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock reviews for now
    final now = DateTime.now();
    return [
      BookReview(
        id: 1,
        bookId: bookId,
        userId: '1',
        userName: 'Ahmet Yılmaz',
        rating: 4.5,
        comment: 'Harika bir kitap, kesinlikle tavsiye ederim!',
        date: now.subtract(const Duration(days: 5)),
      ),
      BookReview(
        id: 2,
        bookId: bookId,
        userId: '2',
        userName: 'Ayşe Demir',
        rating: 5,
        comment: 'Bu kitap beni derinden etkiledi. Okurken zamanın nasıl geçtiğini anlamadım.',
        date: now.subtract(const Duration(days: 12)),
      ),
      BookReview(
        id: 3,
        bookId: bookId,
        userId: '3',
        userName: 'Mehmet Kaya',
        rating: 4,
        comment: 'Çok güzel bir kitap fakat sonunu biraz aceleye getirmişler.',
        date: now.subtract(const Duration(days: 30)),
      ),
    ];
  }

  Future<bool> addReview(BookReview review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  // Mock data for demonstration
  List<Book> _getMockBooks({int? libraryId}) {
    final books = [
      Book(
        id: 1,
        title: 'Sefiller',
        author: 'Victor Hugo',
        coverUrl: 'https://i.dr.com.tr/cache/600x600-0/originals/0001788076001-1.jpg',
        publisher: 'İş Bankası Kültür Yayınları',
        publishDate: DateTime(1862, 1, 1),
        pages: 1724,
        isbn: '9789754589010',
        language: 'Türkçe',
        category: 'Roman, Klasik',
        description: 'Sefiller, Victor Hugo\'nun 1862\'de yayımlanan ve en önemli eserlerinden biri olarak kabul edilen romanıdır. Hugo, toplumsal adaleti sorgulayan, insanların acı ve sefaletine ışık tutan bu eserinde, hayatlarında büyük mücadeleler veren karakterlerin etrafında bir hikaye örer. Roman, eski bir mahkum olan Jean Valjean\'ın hikayesini anlatır. Jean Valjean, işlediği suçun cezasını çektikten sonra topluma geri dönmeye çalışır fakat geçmişi onu rahat bırakmaz.',
        rating: 4.8,
        available: true,
        libraryId: 1,
        isFavorite: true,
      ),
      Book(
        id: 2,
        title: 'Suç ve Ceza',
        author: 'Fyodor Dostoyevski',
        coverUrl: 'https://i.dr.com.tr/cache/600x600-0/originals/0001981900001-1.jpg',
        publisher: 'İş Bankası Kültür Yayınları',
        publishDate: DateTime(1866, 1, 1),
        pages: 687,
        isbn: '9789754589027',
        language: 'Türkçe',
        category: 'Roman, Klasik, Psikolojik',
        description: 'Suç ve Ceza, Rus yazar Fyodor Dostoyevski\'nin 1866 yılında yayımlanan psikolojik bir romanıdır. Kitap, fakir bir öğrenci olan Rodion Raskolnikov\'un bir tefeci kadını öldürmesi ve sonrasında yaşadığı psikolojik çöküşü anlatır. Roman, suçun ve günahın insan ruhunda yarattığı tahribatı ve vicdani muhasebeyi ele alır.',
        rating: 4.7,
        available: false,
        libraryId: 1,
        isFavorite: false,
      ),
      Book(
        id: 3,
        title: 'Simyacı',
        author: 'Paulo Coelho',
        coverUrl: 'https://i.dr.com.tr/cache/600x600-0/originals/0000000411326-1.jpg',
        publisher: 'Can Yayınları',
        publishDate: DateTime(1988, 1, 1),
        pages: 184,
        isbn: '9789750726439',
        language: 'Türkçe',
        category: 'Roman, Felsefe',
        description: 'Simyacı, Brezilyalı yazar Paulo Coelho\'nun dünya çapında üne kavuşmasını sağlayan, 1988 yılında yayımlanan romanıdır. Kitap, Santiago adlı bir çobanın İspanya\'dan Mısır\'a uzanan yolculuğunu ve kişisel efsanesini gerçekleştirme çabasını anlatır. Yaşam amacını arayan ve rüyalarının peşinden giden bir gencin manevi yolculuğunu alegorik bir dille anlatan eser, kişisel gelişim ve motivasyon edebiyatının önemli örneklerindendir.',
        rating: 4.5,
        available: true,
        libraryId: 2,
        isFavorite: false,
      ),
      Book(
        id: 4,
        title: '1984',
        author: 'George Orwell',
        coverUrl: 'https://i.dr.com.tr/cache/600x600-0/originals/0001828069001-1.jpg',
        publisher: 'Can Yayınları',
        publishDate: DateTime(1949, 6, 8),
        pages: 352,
        isbn: '9789750718532',
        language: 'Türkçe',
        category: 'Roman, Distopya',
        description: '1984, George Orwell\'in 1949\'da yayımlanan distopik romanıdır. Eser, totaliter bir rejim altında bireyselliğin tamamen yok edildiği, düşünce suçunun var olduğu ve geçmişin sürekli değiştirildiği bir dünyada geçer. Winston Smith, Parti\'ye karşı içten içe isyan eden bir karakterdir ve yasak bir aşk yaşar. Roman, özgürlük, gözetim, tarihsel gerçeklik ve düşünce kontrolü gibi temaları işleyerek, totalitarizmin insani değerler üzerindeki tehlikeli etkilerini gözler önüne serer.',
        rating: 4.9,
        available: true,
        libraryId: 2,
        isFavorite: true,
      ),
    ];
    
    if (libraryId != null) {
      return books.where((book) => book.libraryId == libraryId).toList();
    }
    
    return books;
  }
}
