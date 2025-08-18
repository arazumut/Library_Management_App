import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

import 'package:library_app/features/libraries/models/library_model.dart';
import 'package:library_app/features/libraries/services/library_service.dart';
import 'package:library_app/features/books/models/book_model.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/shared/widgets/book_cover_image.dart';

class LibraryDetailScreen extends StatefulWidget {
  final int libraryId;

  const LibraryDetailScreen({Key? key, required this.libraryId})
    : super(key: key);

  @override
  State<LibraryDetailScreen> createState() => _LibraryDetailScreenState();
}

class _LibraryDetailScreenState extends State<LibraryDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final LibraryService _libraryService;

  LibraryModel? _library;
  List<BookModel> _books = [];
  bool _isLoading = true;
  bool _isCurrentUserOwner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _libraryService = Provider.of<LibraryService>(context, listen: false);
    _loadLibraryData();
  }

  Future<void> _loadLibraryData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get library details
      final library = await _libraryService.getLibraryById(widget.libraryId);
      if (library == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Library not found')));
          Navigator.pop(context);
        }
        return;
      }

      // Get books in library
      final books = await _libraryService.getLibraryBooks(widget.libraryId);

      // Check if current user is the owner
      // In a real app, this would use authentication
      const int currentUserId = 1;
      final bool isOwner = false; // LibraryModel'de userId yok

      setState(() {
        _library = library;
        _books = books;
        _isCurrentUserOwner = isOwner;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading library data: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatOpenDays(List<bool> openDays) {
    final List<String> weekDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];

    final List<String> days = [];
    for (int i = 0; i < openDays.length; i++) {
      if (openDays[i]) {
        days.add(weekDays[i]);
      }
    }

    return days.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kütüphane Detayları')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with library image
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            actions: [
              if (_isCurrentUserOwner)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit library screen
                  },
                ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share library functionality
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _library!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              background: Container(
                color: AppColors.primary.withOpacity(0.8),
                child:
                    _library?.image != null && _library!.image!.isNotEmpty
                        ? Image.network(_library!.image!, fit: BoxFit.cover)
                        : Center(
                          child: Icon(
                            Icons.account_balance,
                            size: 64,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
              ),
            ),
          ),

          // Library details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _library!.address,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Working hours
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _library!.openingHours,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Open days
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pazartesi - Cuma', // LibraryModel'de openDays yok
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Contact info
                  if (_library?.phone != null && _library!.phone!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.phone, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(_library!.phone!, style: AppTextStyles.bodyMedium),
                      ],
                    ),

                  if (_library?.email != null && _library!.email!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _library!.email!,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                  if (_library?.website != null &&
                      _library!.website!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _library!.website!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Description
                  if (_library?.description != null &&
                      _library!.description!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Açıklama', style: AppTextStyles.headline4),
                    const SizedBox(height: 8),
                    Text(
                      _library!.description!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  const Tab(text: 'Kitaplar'),
                  const Tab(text: 'Ödünç Verilen Kitaplar'),
                ],
              ),
            ),
            pinned: true,
          ),

          // Tab contents
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [_buildBooksTab(), _buildBorrowedBooksTab()],
            ),
          ),
        ],
      ),
      floatingActionButton:
          _isCurrentUserOwner
              ? FloatingActionButton(
                onPressed: () {
                  // Navigate to add book screen with library ID
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add_box, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildBooksTab() {
    if (_books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Kütüphanede hiç kitap yok',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (_isCurrentUserOwner)
              Text(
                'Kütüphanenize kitap ekleyin',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to book details
              AppRoutes.navigateTo(
                context,
                AppRoutes.bookDetails,
                arguments: book.id,
              );
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover
                  BookCoverImage(
                    imageUrl: book.coverImage ?? '',
                    width: 80,
                    height: 120,
                  ),

                  const SizedBox(width: 16.0),

                  // Book details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: AppTextStyles.headline4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          book.author,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            // Status tag (e.g., Available, Borrowed)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    book.available
                                        ? AppColors.success.withOpacity(0.1)
                                        : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                book.available ? 'Mevcut' : 'Ödünç Verildi',
                                style: AppTextStyles.caption.copyWith(
                                  color:
                                      book.available
                                          ? AppColors.success
                                          : AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isCurrentUserOwner)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Edit book
                                  },
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Düzenle'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Toggle availability
                                  },
                                  icon: Icon(
                                    book.available
                                        ? Icons.block
                                        : Icons.check_circle,
                                    size: 16,
                                  ),
                                  label: Text(
                                    book.available
                                        ? 'Mevcut Değil İşaretle'
                                        : 'Mevcut İşaretle',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        book.available
                                            ? AppColors.error
                                            : AppColors.success,
                                    side: BorderSide(
                                      color:
                                          book.available
                                              ? AppColors.error
                                              : AppColors.success,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBorrowedBooksTab() {
    // Filter for borrowed books
    final borrowedBooks = _books.where((book) => !book.available).toList();

    if (borrowedBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_online, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Ödünç Verilen Kitap Yok',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isCurrentUserOwner
                  ? 'Henüz kimse kitap ödünç almadı'
                  : 'Ödünç verdiğiniz kitaplar burada gösterilecek',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: borrowedBooks.length,
      itemBuilder: (context, index) {
        final book = borrowedBooks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to loan details
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover
                  BookCoverImage(
                    imageUrl: book.coverImage ?? '',
                    width: 80,
                    height: 120,
                  ),

                  const SizedBox(width: 16.0),

                  // Book details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: AppTextStyles.headline4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          book.author,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Borrower info (placeholder)
                        Text(
                          'Borrowed by: John Doe',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Due date: 2023-08-25',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        if (_isCurrentUserOwner)
                          ElevatedButton.icon(
                            onPressed: () {
                              // Mark as returned
                            },
                            icon: const Icon(Icons.assignment_return, size: 16),
                            label: const Text('İade Edildi İşaretle'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.background,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
