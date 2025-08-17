import 'package:library_app/core/services/database_service.dart';
import 'package:library_app/features/libraries/models/library.dart';

class LibraryService {
  final DatabaseService _databaseService = DatabaseService();

  // Add a new library
  Future<int> addLibrary(Library library) async {
    final libraryMap = library.toMap();
    // Add current timestamp
    libraryMap['createdAt'] = DateTime.now().toIso8601String();
    return await _databaseService.insertLibrary(libraryMap);
  }

  // Get all libraries
  Future<List<Library>> getAllLibraries() async {
    final librariesMap = await _databaseService.getLibraries();
    return librariesMap.map((map) => Library.fromMap(map)).toList();
  }

  // Get libraries owned by a specific user
  Future<List<Library>> getUserLibraries(int userId) async {
    final librariesMap = await _databaseService.getUserLibraries(userId);
    return librariesMap.map((map) => Library.fromMap(map)).toList();
  }

  // Get public libraries
  Future<List<Library>> getPublicLibraries() async {
    final librariesMap = await _databaseService.getPublicLibraries();
    return librariesMap.map((map) => Library.fromMap(map)).toList();
  }

  // Get a single library by ID
  Future<Library?> getLibrary(int id) async {
    final libraryMap = await _databaseService.getLibrary(id);
    return libraryMap != null ? Library.fromMap(libraryMap) : null;
  }

  // Update a library
  Future<int> updateLibrary(Library library) async {
    return await _databaseService.updateLibrary(library.toMap());
  }

  // Delete a library
  Future<int> deleteLibrary(int id) async {
    return await _databaseService.deleteLibrary(id);
  }

  // Get books in a specific library
  Future<List<Map<String, dynamic>>> getLibraryBooks(int libraryId) async {
    return await _databaseService.getLibraryBooks(libraryId);
  }
}
