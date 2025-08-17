import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/features/books/services/book_service.dart';
import 'package:library_app/shared/widgets/book_cover_image.dart';
import 'package:provider/provider.dart';
import 'package:library_app/features/auth/view_models/auth_view_model.dart';

class BookDetailScreen extends StatefulWidget {
  final int? bookId;
  final Map<String, dynamic>? bookData;
  
  const BookDetailScreen({Key? key, this.bookId, this.bookData}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final BookService _bookService = BookService();
  bool _isFavorite = false;
  bool _isExpanded = false;
  bool _isLoading = false;
  bool _isBorrowing = false;
  Book? _book;
  
  // Example book data if not provided
  late final Map<String, dynamic> _bookData;
  
  @override
  void initState() {
    super.initState();
    _bookData = widget.bookData ?? {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
      'rating': 4.5,
      'publisher': 'Scribner',
      'publishDate': '1925-04-10',
      'pages': 218,
      'isbn': '9780743273565',
      'language': 'English',
      'category': 'Fiction, Classic',
      'available': true,
      'description': 'The Great Gatsby is a 1925 novel by American writer F. Scott Fitzgerald. Set in the Jazz Age on Long Island, near New York City, the novel depicts first-person narrator Nick Carraway\'s interactions with mysterious millionaire Jay Gatsby and Gatsby\'s obsession to reunite with his former lover, Daisy Buchanan.\n\nA first-rate piece of storytelling that seems to grow fresher rather than staler over the years. It explores a variety of themes — the hollow American dream, the wonder of love, pure wealth, staggering wealth — and allows every reader to take from it what he or she will.',
      'reviews': [
        {
          'user': 'Emma Watson',
          'rating': 5,
          'comment': 'A beautiful classic that remains relevant today.',
          'date': '2023-05-15',
        },
        {
          'user': 'John Smith',
          'rating': 4,
          'comment': 'Excellent character development and setting.',
          'date': '2023-04-22',
        },
        {
          'user': 'Michael Brown',
          'rating': 4.5,
          'comment': 'A masterpiece of American literature.',
          'date': '2023-03-10',
        }
      ]
    };
    
    _isFavorite = _bookData['isFavorite'] ?? false;
    
    // If we have a bookId, load the book data from the service
    if (widget.bookId != null) {
      _loadBookDetails();
    }
  }
  
  Future<void> _loadBookDetails() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final book = await _bookService.getBookById(widget.bookId!);
      
      if (book != null) {
        setState(() {
          _book = book;
          _isFavorite = book.isFavorite;
          
          // Update the bookData map from the book model
          _bookData = {
            'title': book.title,
            'author': book.author,
            'coverUrl': book.coverUrl,
            'rating': book.rating,
            'publisher': book.publisher,
            'publishDate': book.publishDate?.toString() ?? '',
            'pages': book.pages,
            'isbn': book.isbn,
            'language': book.language,
            'category': book.category,
            'available': book.available,
            'description': book.description,
            'isFavorite': book.isFavorite,
            'reviews': book.reviews?.map((review) => {
              'user': review.userName,
              'rating': review.rating,
              'comment': review.comment,
              'date': review.date.toString(),
            }).toList() ?? [],
          };
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading book details: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
        slivers: [
          // App bar with book cover
          _buildSliverAppBar(),
          
          // Book details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and author
                  Text(
                    _bookData['title'],
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${_bookData['author']}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rating and category
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${_bookData['rating']}',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.category,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _bookData['category'].toString().split(',')[0],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Availability status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: _bookData['available'] == true
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _bookData['available'] == true
                              ? Icons.check_circle
                              : Icons.error,
                          color: _bookData['available'] == true
                              ? AppColors.success
                              : AppColors.error,
                          size: 18.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          _bookData['available'] == true
                              ? 'Available'
                              : 'Borrowed',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _bookData['available'] == true
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Book details grid
                  _buildBookDetailsGrid(),
                  
                  const SizedBox(height: 24),
                  
                  // Book description
                  Text(
                    'Book Description',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _bookData['description'],
                          style: AppTextStyles.bodyMedium,
                          maxLines: _isExpanded ? null : 5,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (!_isExpanded)
                          Text(
                            'Read more',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Reviews section
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }
  
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.bookmark : Icons.bookmark_border,
            color: _isFavorite ? AppColors.primary : null,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Share book functionality
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.background,
          child: Center(
            child: Hero(
              tag: 'book-${_bookData['isbn']}',
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: BookCoverImage(
                  imageUrl: _bookData['coverUrl'],
                  width: 160,
                  height: 240,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBookDetailsGrid() {
    final details = [
      {'title': 'Publisher', 'value': _bookData['publisher']},
      {'title': 'Published', 'value': _formatDate(_bookData['publishDate'])},
      {'title': 'Pages', 'value': '${_bookData['pages']}'},
      {'title': 'ISBN', 'value': _bookData['isbn']},
      {'title': 'Language', 'value': _bookData['language']},
      {'title': 'Categories', 'value': _bookData['category']},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details[index]['title']!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              details[index]['value']!,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildReviewsSection() {
    final reviews = _bookData['reviews'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: AppTextStyles.headline4,
            ),
            TextButton(
              onPressed: () {
                // Navigate to all reviews
              },
              child: Text(
                'See All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length > 2 ? 2 : reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index] as Map<String, dynamic>;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          review['user'].toString().characters.first,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['user'],
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              _formatDate(review['date']),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2.0),
                          Text(
                            '${review['rating']}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    review['comment'],
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                ],
              ),
            );
          },
        ),
        
        if (reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No reviews yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Be the first to review this book',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Write review button
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              onPressed: () {
                // Show review dialog
              },
              icon: const Icon(Icons.rate_review),
              label: const Text('Review'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          
          // Borrow/Return button
          Expanded(
            flex: 2,
            child: _isBorrowing
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                onPressed: _bookData['available'] == true
                    ? () => _borrowBook()
                    : () => _returnBook(),
                icon: Icon(
                  _bookData['available'] == true
                      ? Icons.book_online
                      : Icons.assignment_return,
                ),
                label: Text(_bookData['available'] == true ? 'Ödünç Al' : 'İade Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _bookData['available'] == true ? AppColors.primary : AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final month = _getMonthName(parsedDate.month);
      return '${month} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  Future<void> _borrowBook() async {
    // Get the current user from AuthViewModel
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (!authViewModel.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kitap ödünç almak için giriş yapmalısınız')),
      );
      return;
    }
    
    setState(() {
      _isBorrowing = true;
    });
    
    try {
      final bookId = _book?.id ?? widget.bookId;
      if (bookId == null) {
        throw Exception('Book ID is not available');
      }
      
      final userId = authViewModel.currentUser?.id;
      if (userId == null) {
        throw Exception('User ID is not available');
      }
      
      final success = await _bookService.borrowBook(bookId, userId);
      
      if (success) {
        setState(() {
          _bookData['available'] = false;
          if (_book != null) {
            _book = _book!.copyWith(available: false);
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kitap başarıyla ödünç alındı')),
          );
        }
      } else {
        throw Exception('Failed to borrow book');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitabı ödünç alma işlemi başarısız oldu: $e')),
        );
      }
    } finally {
      setState(() {
        _isBorrowing = false;
      });
    }
  }
  
  Future<void> _returnBook() async {
    setState(() {
      _isBorrowing = true;
    });
    
    try {
      final bookId = _book?.id ?? widget.bookId;
      if (bookId == null) {
        throw Exception('Book ID is not available');
      }
      
      final success = await _bookService.returnBook(bookId);
      
      if (success) {
        setState(() {
          _bookData['available'] = true;
          if (_book != null) {
            _book = _book!.copyWith(available: true);
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kitap başarıyla iade edildi')),
          );
        }
      } else {
        throw Exception('Failed to return book');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitap iade işlemi başarısız oldu: $e')),
        );
      }
    } finally {
      setState(() {
        _isBorrowing = false;
      });
    }
  }
}
