import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/shared/widgets/book_cover_image.dart';
import 'package:library_app/core/routes/app_routes.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.translate('search_books_hint'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Show filter options
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.surfaceDark
                    : Colors.grey.shade100,
              ),
              onSubmitted: (value) {
                // Perform search
              },
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: [
              Tab(text: context.l10n.translate('all_books')),
              Tab(text: context.l10n.translate('categories')),
              Tab(text: context.l10n.translate('saved')),
            ],
          ),
          
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Books Tab
                _buildAllBooksTab(),
                
                // Categories Tab
                _buildCategoriesTab(),
                
                // Saved Tab
                _buildSavedBooksTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.navigateTo(context, AppRoutes.bookAdd);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }
  
  Widget _buildAllBooksTab() {
    // Dummy book data
    final List<Map<String, dynamic>> books = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
        'rating': 4.5,
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c3/1984first.jpg',
        'rating': 4.8,
      },
      {
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg',
        'rating': 4.7,
      },
      {
        'title': 'The Hobbit',
        'author': 'J.R.R. Tolkien',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/en/4/4a/TheHobbit_FirstEdition.jpg',
        'rating': 4.6,
      },
      {
        'title': 'Pride and Prejudice',
        'author': 'Jane Austen',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/1/17/PrideAndPrejudiceTitlePage.jpg',
        'rating': 4.3,
      },
      {
        'title': 'The Catcher in the Rye',
        'author': 'J.D. Salinger',
        'coverUrl': '',
        'rating': 4.1,
      },
      {
        'title': 'Lord of the Flies',
        'author': 'William Golding',
        'coverUrl': '',
        'rating': 4.0,
      },
    ];
    
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh book list
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () {
                // Navigate to book details
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book cover
                    BookCoverImage(
                      imageUrl: books[index]['coverUrl'],
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
                            books[index]['title'],
                            style: AppTextStyles.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            books[index]['author'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                books[index]['rating'].toString(),
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
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
                                  color: index % 3 == 0 ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  index % 3 == 0 ? 'Borrowed' : 'Available',
                                  style: AppTextStyles.caption.copyWith(
                                    color: index % 3 == 0 ? AppColors.error : AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Book format tag (e.g., Hardcover, Paperback)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  index % 2 == 0 ? 'Hardcover' : 'Paperback',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Bookmark button
                    IconButton(
                      icon: Icon(
                        index % 2 == 0 ? Icons.bookmark : Icons.bookmark_border,
                        color: index % 2 == 0 ? AppColors.primary : null,
                      ),
                      onPressed: () {
                        // Toggle bookmark
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildCategoriesTab() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Fiction', 'icon': Icons.auto_stories, 'count': 156},
      {'name': 'Science Fiction', 'icon': Icons.rocket_launch, 'count': 89},
      {'name': 'Mystery', 'icon': Icons.search, 'count': 102},
      {'name': 'Biography', 'icon': Icons.person, 'count': 74},
      {'name': 'History', 'icon': Icons.history_edu, 'count': 128},
      {'name': 'Self-Help', 'icon': Icons.psychology, 'count': 95},
      {'name': 'Business', 'icon': Icons.business, 'count': 83},
      {'name': 'Romance', 'icon': Icons.favorite, 'count': 112},
      {'name': 'Fantasy', 'icon': Icons.castle, 'count': 76},
      {'name': 'Horror', 'icon': Icons.cabin, 'count': 45},
      {'name': 'Poetry', 'icon': Icons.edit, 'count': 67},
      {'name': 'Children', 'icon': Icons.child_care, 'count': 120},
      {'name': 'Education', 'icon': Icons.school, 'count': 88},
      {'name': 'Art', 'icon': Icons.palette, 'count': 52},
    ];
    
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigate to category details
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  index % 3 == 0 ? AppColors.primary : AppColors.secondary,
                  index % 3 == 0 ? AppColors.primaryLight : AppColors.secondaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    categories[index]['icon'],
                    color: Colors.white,
                    size: 32.0,
                  ),
                  const Spacer(),
                  Text(
                    categories[index]['name'],
                    style: AppTextStyles.headline4.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${categories[index]['count']} books',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
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
  
  Widget _buildSavedBooksTab() {
    // Dummy saved books data
    final List<Map<String, dynamic>> savedBooks = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
        'savedDate': 'Saved 2 days ago',
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c3/1984first.jpg',
        'savedDate': 'Saved 1 week ago',
      },
    ];
    
    if (savedBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved books yet',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your bookmarked books will appear here',
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
      itemCount: savedBooks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(savedBooks[index]['title']),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            color: AppColors.error,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Remove from saved books
            setState(() {
              // savedBooks.removeAt(index);
            });
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () {
                // Navigate to book details
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book cover
                    BookCoverImage(
                      imageUrl: savedBooks[index]['coverUrl'],
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
                            savedBooks[index]['title'],
                            style: AppTextStyles.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            savedBooks[index]['author'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            savedBooks[index]['savedDate'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Request to borrow the book
                                },
                                icon: const Icon(Icons.book_online),
                                label: const Text('Borrow'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Remove button
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: AppColors.primary),
                      onPressed: () {
                        // Remove from saved books
                        setState(() {
                          // savedBooks.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
