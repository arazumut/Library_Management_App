import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/shared/widgets/book_cover_image.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Welcome back, User!',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 8),
              Text(
                'Discover your next favorite book',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Reading statistics card
              _buildStatisticsCard(),
              const SizedBox(height: 24),
              
              // Recently added books section
              _buildSectionHeader('Recently Added Books', onSeeAllPressed: () {}),
              const SizedBox(height: 16),
              _buildHorizontalBooksList(),
              const SizedBox(height: 24),
              
              // Popular books section
              _buildSectionHeader('Popular Books', onSeeAllPressed: () {}),
              const SizedBox(height: 16),
              _buildHorizontalBooksList(),
              const SizedBox(height: 24),
              
              // Your current loans section
              _buildSectionHeader('Your Current Loans', onSeeAllPressed: () {}),
              const SizedBox(height: 16),
              _buildLoansList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatisticsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Reading Stats',
            style: AppTextStyles.headline3.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('3', 'Books\nReading'),
              ),
              Expanded(
                child: _buildStatItem('12', 'Books\nCompleted'),
              ),
              Expanded(
                child: _buildStatItem('5', 'Books in\nWishlist'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Reading Goal: 75% Complete',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.headline2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.headline3,
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          child: Text(
            'See All',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildHorizontalBooksList() {
    // Dummy book data
    final List<Map<String, dynamic>> books = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c3/1984first.jpg',
      },
      {
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg',
      },
      {
        'title': 'The Hobbit',
        'author': 'J.R.R. Tolkien',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/en/4/4a/TheHobbit_FirstEdition.jpg',
      },
      {
        'title': 'Pride and Prejudice',
        'author': 'Jane Austen',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/1/17/PrideAndPrejudiceTitlePage.jpg',
      },
    ];
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BookCoverImage(
                    imageUrl: books[index]['coverUrl'],
                    width: 140,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  books[index]['title'],
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  books[index]['author'],
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLoansList() {
    // Dummy loan data
    final List<Map<String, dynamic>> loans = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
        'dueDate': 'Due in 3 days',
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c3/1984first.jpg',
        'dueDate': 'Due in 5 days',
      },
    ];
    
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No books borrowed',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our collection and borrow books',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                BookCoverImage(
                  imageUrl: loans[index]['coverUrl'],
                  width: 60,
                  height: 90,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loans[index]['title'],
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        loans[index]['author'],
                        style: AppTextStyles.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            loans[index]['dueDate'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    // Navigate to loan details
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
