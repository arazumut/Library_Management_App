import '../../../core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';

class BookService {
  final ApiService _apiService;

  BookService({required ApiService apiService}) : _apiService = apiService;

  // Tüm kitapları getir
  Future<List<BookModel>> getAllBooks({int? page, int? limit}) async {
    try {
      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        ApiEndpoints.books,
        queryParameters: queryParams,
      );

      // API'den gelen yanıt list formatında olabilir veya paginated olabilir
      List<dynamic> booksData;
      if (response is List) {
        booksData = response;
      } else if (response['results'] != null) {
        // Paginated response
        booksData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return booksData.map((bookJson) => BookModel.fromJson(bookJson)).toList();
    } catch (e) {
      throw Exception('Kitaplar yüklenemedi: ${e.toString()}');
    }
  }

  // ID'ye göre kitap getir
  Future<BookModel> getBookById(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.bookDetail, {
        'id': id,
      });

      final response = await _apiService.get(endpoint);
      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Kitap bulunamadı: ${e.toString()}');
    }
  }

  // Kategori ID'sine göre kitapları getir
  Future<List<BookModel>> getBooksByCategory(int categoryId) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.booksByCategory,
        {'id': categoryId},
      );

      final response = await _apiService.get(endpoint);

      List<dynamic> booksData;
      if (response is List) {
        booksData = response;
      } else if (response['results'] != null) {
        booksData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return booksData.map((bookJson) => BookModel.fromJson(bookJson)).toList();
    } catch (e) {
      throw Exception('Kategori kitapları yüklenemedi: ${e.toString()}');
    }
  }

  // Kitap arama
  Future<List<BookModel>> searchBooks(
    String query, {
    int? page,
    int? limit,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'search': query};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiService.get(
        ApiEndpoints.books,
        queryParameters: queryParams,
      );

      List<dynamic> booksData;
      if (response is List) {
        booksData = response;
      } else if (response['results'] != null) {
        booksData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return booksData.map((bookJson) => BookModel.fromJson(bookJson)).toList();
    } catch (e) {
      throw Exception('Kitap arama başarısız: ${e.toString()}');
    }
  }

  // Yeni kitap ekle (admin için)
  Future<BookModel> addBook(BookModel book) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.books,
        data: book.toJson(),
      );

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Kitap eklenemedi: ${e.toString()}');
    }
  }

  // Kitap güncelle (admin için)
  Future<BookModel> updateBook(int id, BookModel book) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.bookDetail, {
        'id': id,
      });

      final response = await _apiService.put(endpoint, data: book.toJson());

      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Kitap güncellenemedi: ${e.toString()}');
    }
  }

  // Kitap sil (admin için)
  Future<void> deleteBook(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.bookDetail, {
        'id': id,
      });

      await _apiService.delete(endpoint);
    } catch (e) {
      throw Exception('Kitap silinemedi: ${e.toString()}');
    }
  }

  // Tüm kategorileri getir
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.categories);

      List<dynamic> categoriesData;
      if (response is List) {
        categoriesData = response;
      } else if (response['results'] != null) {
        categoriesData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return categoriesData
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
    } catch (e) {
      throw Exception('Kategoriler yüklenemedi: ${e.toString()}');
    }
  }

  // Kategori detayı getir
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.categoryDetail,
        {'id': id},
      );

      final response = await _apiService.get(endpoint);
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Kategori bulunamadı: ${e.toString()}');
    }
  }
}
