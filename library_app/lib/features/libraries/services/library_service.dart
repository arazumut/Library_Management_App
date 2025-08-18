import '../../../core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/library_model.dart';
import '../../books/models/book_model.dart';

class LibraryService {
  final ApiService _apiService;

  LibraryService({required ApiService apiService}) : _apiService = apiService;

  // Tüm kütüphaneleri getir
  Future<List<LibraryModel>> getAllLibraries({int? page, int? limit}) async {
    try {
      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        ApiEndpoints.libraries,
        queryParameters: queryParams,
      );

      List<dynamic> librariesData;
      if (response is List) {
        librariesData = response;
      } else if (response['results'] != null) {
        librariesData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return librariesData
          .map((libraryJson) => LibraryModel.fromJson(libraryJson))
          .toList();
    } catch (e) {
      throw Exception('Kütüphaneler yüklenemedi: ${e.toString()}');
    }
  }

  // ID'ye göre kütüphane getir
  Future<LibraryModel> getLibraryById(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.libraryDetail,
        {'id': id},
      );

      final response = await _apiService.get(endpoint);
      return LibraryModel.fromJson(response);
    } catch (e) {
      throw Exception('Kütüphane bulunamadı: ${e.toString()}');
    }
  }

  // Kütüphanedeki kitapları getir
  Future<List<BookModel>> getLibraryBooks(
    int libraryId, {
    int? page,
    int? limit,
  }) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.libraryBooks,
        {'id': libraryId},
      );

      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        endpoint,
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
      throw Exception('Kütüphane kitapları yüklenemedi: ${e.toString()}');
    }
  }

  // Kütüphane arama
  Future<List<LibraryModel>> searchLibraries(
    String query, {
    int? page,
    int? limit,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'search': query};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiService.get(
        ApiEndpoints.libraries,
        queryParameters: queryParams,
      );

      List<dynamic> librariesData;
      if (response is List) {
        librariesData = response;
      } else if (response['results'] != null) {
        librariesData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return librariesData
          .map((libraryJson) => LibraryModel.fromJson(libraryJson))
          .toList();
    } catch (e) {
      throw Exception('Kütüphane arama başarısız: ${e.toString()}');
    }
  }

  // Yeni kütüphane ekle (admin için)
  Future<LibraryModel> addLibrary(LibraryModel library) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.libraries,
        data: library.toJson(),
      );

      return LibraryModel.fromJson(response);
    } catch (e) {
      throw Exception('Kütüphane eklenemedi: ${e.toString()}');
    }
  }

  // Kütüphane güncelle (admin için)
  Future<LibraryModel> updateLibrary(int id, LibraryModel library) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.libraryDetail,
        {'id': id},
      );

      final response = await _apiService.put(endpoint, data: library.toJson());

      return LibraryModel.fromJson(response);
    } catch (e) {
      throw Exception('Kütüphane güncellenemedi: ${e.toString()}');
    }
  }

  // Kütüphane sil (admin için)
  Future<void> deleteLibrary(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.libraryDetail,
        {'id': id},
      );

      await _apiService.delete(endpoint);
    } catch (e) {
      throw Exception('Kütüphane silinemedi: ${e.toString()}');
    }
  }

  // Yakınımdaki kütüphaneler (koordinata göre)
  Future<List<LibraryModel>> getNearbyLibraries(
    double latitude,
    double longitude, {
    double? radius,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'latitude': latitude,
        'longitude': longitude,
      };
      if (radius != null) queryParams['radius'] = radius;

      final response = await _apiService.get(
        ApiEndpoints.libraries,
        queryParameters: queryParams,
      );

      List<dynamic> librariesData;
      if (response is List) {
        librariesData = response;
      } else if (response['results'] != null) {
        librariesData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return librariesData
          .map((libraryJson) => LibraryModel.fromJson(libraryJson))
          .toList();
    } catch (e) {
      throw Exception('Yakın kütüphaneler bulunamadı: ${e.toString()}');
    }
  }
}
