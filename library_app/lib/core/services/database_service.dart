import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'library_database.db');
    return await openDatabase(
      path,
      version: 2, // Increment version number to trigger onUpgrade
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create Libraries table if upgrading from version 1
      await db.execute('''
        CREATE TABLE libraries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          address TEXT NOT NULL,
          phone TEXT,
          email TEXT,
          website TEXT,
          description TEXT,
          imageUrl TEXT,
          openingTime TEXT NOT NULL,
          closingTime TEXT NOT NULL,
          openDays TEXT NOT NULL,
          userId INTEGER NOT NULL,
          isPublic INTEGER DEFAULT 1,
          createdAt TEXT NOT NULL,
          FOREIGN KEY (userId) REFERENCES users (id)
        )
      ''');
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create Books table
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        isbn TEXT,
        coverUrl TEXT,
        description TEXT,
        pageCount INTEGER,
        publishedDate TEXT,
        category TEXT,
        libraryId INTEGER,
        isAvailable INTEGER DEFAULT 1
      )
    ''');

    // Create Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        passwordHash TEXT NOT NULL,
        role TEXT DEFAULT 'member',
        createdAt TEXT NOT NULL
      )
    ''');

    // Create Libraries table
    await db.execute('''
      CREATE TABLE libraries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        website TEXT,
        description TEXT,
        imageUrl TEXT,
        openingTime TEXT NOT NULL,
        closingTime TEXT NOT NULL,
        openDays TEXT NOT NULL,
        userId INTEGER NOT NULL,
        isPublic INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Create Loans table
    await db.execute('''
      CREATE TABLE loans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        loanDate TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        returnDate TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (bookId) REFERENCES books (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // Books CRUD operations
  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    return await db.insert('books', book);
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  Future<Map<String, dynamic>?> getBook(int id) async {
    final db = await database;
    final results = await db.query('books', where: 'id = ?', whereArgs: [id], limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateBook(Map<String, dynamic> book) async {
    final db = await database;
    return await db.update(
      'books',
      book,
      where: 'id = ?',
      whereArgs: [book['id']],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Users CRUD operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  // Loans CRUD operations
  Future<int> insertLoan(Map<String, dynamic> loan) async {
    final db = await database;
    return await db.insert('loans', loan);
  }

  Future<List<Map<String, dynamic>>> getLoans() async {
    final db = await database;
    return await db.query('loans');
  }

  Future<List<Map<String, dynamic>>> getUserLoans(int userId) async {
    final db = await database;
    return await db.query('loans', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> updateLoan(Map<String, dynamic> loan) async {
    final db = await database;
    return await db.update(
      'loans',
      loan,
      where: 'id = ?',
      whereArgs: [loan['id']],
    );
  }

  // Search books by title or author
  Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final db = await database;
    return await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  // Get books by category
  Future<List<Map<String, dynamic>>> getBooksByCategory(String category) async {
    final db = await database;
    return await db.query(
      'books',
      where: 'category = ?',
      whereArgs: [category],
    );
  }
  
  // Libraries CRUD operations
  Future<int> insertLibrary(Map<String, dynamic> library) async {
    final db = await database;
    return await db.insert('libraries', library);
  }
  
  Future<List<Map<String, dynamic>>> getLibraries() async {
    final db = await database;
    return await db.query('libraries');
  }
  
  Future<List<Map<String, dynamic>>> getUserLibraries(int userId) async {
    final db = await database;
    return await db.query(
      'libraries',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
  
  Future<List<Map<String, dynamic>>> getPublicLibraries() async {
    final db = await database;
    return await db.query(
      'libraries',
      where: 'isPublic = ?',
      whereArgs: [1],
    );
  }
  
  Future<Map<String, dynamic>?> getLibrary(int id) async {
    final db = await database;
    final results = await db.query(
      'libraries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  Future<int> updateLibrary(Map<String, dynamic> library) async {
    final db = await database;
    return await db.update(
      'libraries',
      library,
      where: 'id = ?',
      whereArgs: [library['id']],
    );
  }
  
  Future<int> deleteLibrary(int id) async {
    final db = await database;
    return await db.delete(
      'libraries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Get books in a library
  Future<List<Map<String, dynamic>>> getLibraryBooks(int libraryId) async {
    final db = await database;
    return await db.query(
      'books',
      where: 'libraryId = ?',
      whereArgs: [libraryId],
    );
  }
}
