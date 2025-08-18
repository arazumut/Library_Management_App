import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';

import 'package:library_app/features/libraries/models/library_model.dart';
import 'package:library_app/features/libraries/services/library_service.dart';
import 'package:provider/provider.dart';
import 'package:library_app/core/routes/app_routes.dart';

class LibrariesScreen extends StatefulWidget {
  const LibrariesScreen({Key? key}) : super(key: key);

  @override
  State<LibrariesScreen> createState() => _LibrariesScreenState();
}

class _LibrariesScreenState extends State<LibrariesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final LibraryService _libraryService;

  List<LibraryModel> _myLibraries = [];
  List<LibraryModel> _publicLibraries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _libraryService = Provider.of<LibraryService>(context, listen: false);
    _loadLibraries();
  }

  Future<void> _loadLibraries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, we would get the current user ID from authentication
      int currentUserId = 1;

      // Load all libraries (simplified - API doesn't have separate user/public methods)
      final allLibraries = await _libraryService.getAllLibraries();
      final myLibraries =
          <LibraryModel>[]; // Placeholder - would filter by user
      final publicLibraries = allLibraries;

      // Filter out user's own libraries from public libraries to avoid duplicates
      final filteredPublicLibraries =
          publicLibraries
              .where((lib) => !myLibraries.any((myLib) => myLib.id == lib.id))
              .toList();

      setState(() {
        _myLibraries = myLibraries;
        _publicLibraries = filteredPublicLibraries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading libraries: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kütüphaneler')),
      body: Column(
        children: [
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: [
              Tab(text: 'Kütüphanelerim'),
              Tab(text: 'Halk Kütüphaneleri'),
            ],
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // My Libraries Tab
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildMyLibrariesTab(),

                // Public Libraries Tab
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildPublicLibrariesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AppRoutes.navigateTo(context, AppRoutes.libraryManagement);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Kütüphane Ekle',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMyLibrariesTab() {
    if (_myLibraries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Henüz kütüphanen yok',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'İlk kütüphaneni ekleyerek başla',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                AppRoutes.navigateTo(context, AppRoutes.libraryManagement);
              },
              icon: const Icon(Icons.add),
              label: const Text('Kütüphane Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLibraries,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _myLibraries.length,
        itemBuilder: (context, index) {
          return _buildLibraryCard(_myLibraries[index], isUserLibrary: true);
        },
      ),
    );
  }

  Widget _buildPublicLibrariesTab() {
    if (_publicLibraries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Halka açık kütüphane bulunamadı',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'İlk halka açık kütüphaneyi sen oluştur',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLibraries,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _publicLibraries.length,
        itemBuilder: (context, index) {
          return _buildLibraryCard(
            _publicLibraries[index],
            isUserLibrary: false,
          );
        },
      ),
    );
  }

  Widget _buildLibraryCard(
    LibraryModel library, {
    required bool isUserLibrary,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          // Navigate to library detail page
          AppRoutes.navigateTo(
            context,
            AppRoutes.libraryDetail,
            arguments: library.id,
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Library image or header
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                color: AppColors.primary.withOpacity(0.8),
                image:
                    library.image != null && library.image!.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(library.image!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child: Stack(
                children: [
                  if (library.image == null || library.image!.isEmpty)
                    Center(
                      child: Icon(
                        Icons.library_books,
                        size: 48,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  if (isUserLibrary)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: const Icon(
                                Icons
                                    .public, // LibraryModel'de isPublic yok, varsayılan public
                                size: 16,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                // Toggle library visibility
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                // Edit library
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Library details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Library name
                  Text(
                    library.name,
                    style: AppTextStyles.headline4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),

                  // Library address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          library.address,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Working hours
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        library
                            .openingHours, // LibraryModel'de string olarak saklı
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // View library books
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Kitapları Gör'),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Visit library or add book to library
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            isUserLibrary ? 'Kitap Ekle' : 'Ziyaret Et',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
