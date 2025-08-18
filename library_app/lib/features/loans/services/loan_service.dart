import '../../../core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/loan_model.dart';

class LoanService {
  final ApiService _apiService;

  LoanService({required ApiService apiService}) : _apiService = apiService;

  // Tüm ödünç alma kayıtlarını getir (admin için)
  Future<List<LoanModel>> getAllLoans({
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      Map<String, dynamic>? queryParams;
      if (page != null || limit != null || status != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
        if (status != null) queryParams['status'] = status;
      }

      final response = await _apiService.get(
        ApiEndpoints.loans,
        queryParameters: queryParams,
      );

      List<dynamic> loansData;
      if (response is List) {
        loansData = response;
      } else if (response['results'] != null) {
        loansData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return loansData.map((loanJson) => LoanModel.fromJson(loanJson)).toList();
    } catch (e) {
      throw Exception('Ödünç alma kayıtları yüklenemedi: ${e.toString()}');
    }
  }

  // Kullanıcının ödünç alma kayıtlarını getir
  Future<List<LoanModel>> getUserLoans(
    int userId, {
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.userLoans, {
        'id': userId,
      });

      Map<String, dynamic>? queryParams;
      if (page != null || limit != null || status != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
        if (status != null) queryParams['status'] = status;
      }

      final response = await _apiService.get(
        endpoint,
        queryParameters: queryParams,
      );

      List<dynamic> loansData;
      if (response is List) {
        loansData = response;
      } else if (response['results'] != null) {
        loansData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return loansData.map((loanJson) => LoanModel.fromJson(loanJson)).toList();
    } catch (e) {
      throw Exception(
        'Kullanıcı ödünç alma kayıtları yüklenemedi: ${e.toString()}',
      );
    }
  }

  // ID'ye göre ödünç alma kaydını getir
  Future<LoanModel> getLoanById(int id) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.loanDetail, {
        'id': id,
      });

      final response = await _apiService.get(endpoint);
      return LoanModel.fromJson(response);
    } catch (e) {
      throw Exception('Ödünç alma kaydı bulunamadı: ${e.toString()}');
    }
  }

  // Kitap ödünç alma
  Future<LoanModel> borrowBook({
    required int bookId,
    required int userId,
    required DateTime dueDate,
    String? notes,
  }) async {
    try {
      final loanData = {
        'book_id': bookId,
        'user_id': userId,
        'due_date': dueDate.toIso8601String(),
        'notes': notes,
      };

      final response = await _apiService.post(
        ApiEndpoints.borrowBook,
        data: loanData,
      );

      return LoanModel.fromJson(response);
    } catch (e) {
      throw Exception('Kitap ödünç alınamadı: ${e.toString()}');
    }
  }

  // Kitap iade etme
  Future<LoanModel> returnBook(int loanId, {String? notes}) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(ApiEndpoints.returnBook, {
        'id': loanId,
      });

      final returnData = <String, dynamic>{};
      if (notes != null) returnData['notes'] = notes;

      final response = await _apiService.post(endpoint, data: returnData);
      return LoanModel.fromJson(response);
    } catch (e) {
      throw Exception('Kitap iade edilemedi: ${e.toString()}');
    }
  }

  // Ödünç alma süresini uzatma
  Future<LoanModel> extendLoan(int loanId, DateTime newDueDate) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams('/loans/{id}/extend/', {
        'id': loanId,
      });

      final extendData = {'new_due_date': newDueDate.toIso8601String()};

      final response = await _apiService.post(endpoint, data: extendData);
      return LoanModel.fromJson(response);
    } catch (e) {
      throw Exception('Ödünç alma süresi uzatılamadı: ${e.toString()}');
    }
  }

  // Aktif ödünç alma kayıtlarını getir
  Future<List<LoanModel>> getActiveLoans({int? userId}) async {
    return await getAllLoans(status: 'active');
  }

  // Vadesi geçmiş ödünç alma kayıtlarını getir
  Future<List<LoanModel>> getOverdueLoans({int? userId}) async {
    try {
      Map<String, dynamic> queryParams = {'overdue': 'true'};
      if (userId != null) queryParams['user_id'] = userId;

      final response = await _apiService.get(
        ApiEndpoints.loans,
        queryParameters: queryParams,
      );

      List<dynamic> loansData;
      if (response is List) {
        loansData = response;
      } else if (response['results'] != null) {
        loansData = response['results'];
      } else {
        throw Exception('Beklenmeyen API yanıt formatı');
      }

      return loansData.map((loanJson) => LoanModel.fromJson(loanJson)).toList();
    } catch (e) {
      throw Exception('Vadesi geçmiş kayıtlar yüklenemedi: ${e.toString()}');
    }
  }

  // İade edilmiş ödünç alma kayıtlarını getir
  Future<List<LoanModel>> getReturnedLoans({
    int? userId,
    int? page,
    int? limit,
  }) async {
    if (userId != null) {
      return await getUserLoans(
        userId,
        page: page,
        limit: limit,
        status: 'returned',
      );
    } else {
      return await getAllLoans(page: page, limit: limit, status: 'returned');
    }
  }

  // Kullanıcının mevcut ödünç aldığı kitap sayısı
  Future<int> getUserActiveLoanCount(int userId) async {
    try {
      final loans = await getUserLoans(userId, status: 'active');
      return loans.length;
    } catch (e) {
      return 0;
    }
  }

  // Kitabın müsait olup olmadığını kontrol et
  Future<bool> isBookAvailable(int bookId) async {
    try {
      final response = await _apiService.get('/books/$bookId/availability/');

      return response['available'] == true;
    } catch (e) {
      return false;
    }
  }
}
