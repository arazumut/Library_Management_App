import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/shared/widgets/book_cover_image.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Loans'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'History'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Current Loans Tab
          _buildCurrentLoansTab(),
          
          // Loan History Tab
          _buildLoanHistoryTab(),
          
          // Loan Requests Tab
          _buildLoanRequestsTab(),
        ],
      ),
    );
  }
  
  Widget _buildCurrentLoansTab() {
    // Dummy loan data
    final List<Map<String, dynamic>> currentLoans = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
        'borrowDate': '2023-08-15',
        'dueDate': '2023-09-15',
        'remainingDays': 5,
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c3/1984first.jpg',
        'borrowDate': '2023-08-20',
        'dueDate': '2023-09-20',
        'remainingDays': 10,
      },
    ];
    
    if (currentLoans.isEmpty) {
      return _buildEmptyState('No current loans', 'You haven\'t borrowed any books yet');
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh loan list
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: currentLoans.length,
        itemBuilder: (context, index) {
          final loan = currentLoans[index];
          final bool isOverdue = loan['remainingDays'] < 0;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover
                  BookCoverImage(
                    imageUrl: loan['coverUrl'],
                    width: 80,
                    height: 120,
                  ),
                  
                  const SizedBox(width: 16.0),
                  
                  // Loan details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan['title'],
                          style: AppTextStyles.headline4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          loan['author'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16.0,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Due: ${_formatDate(loan['dueDate'])}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Time remaining indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue 
                                ? AppColors.error.withOpacity(0.1)
                                : loan['remainingDays'] <= 3
                                    ? Colors.orange.withOpacity(0.1)
                                    : AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            isOverdue
                                ? 'Overdue by ${-loan['remainingDays']} days'
                                : '${loan['remainingDays']} days remaining',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isOverdue
                                  ? AppColors.error
                                  : loan['remainingDays'] <= 3
                                      ? Colors.orange
                                      : AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            // Return button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Return book process
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text('Return'),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            // Renew button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Renew book process
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text('Renew'),
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
        },
      ),
    );
  }
  
  Widget _buildLoanHistoryTab() {
    // Dummy loan history data
    final List<Map<String, dynamic>> loanHistory = [
      {
        'title': 'The Hobbit',
        'author': 'J.R.R. Tolkien',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/en/4/4a/TheHobbit_FirstEdition.jpg',
        'borrowDate': '2023-06-15',
        'returnDate': '2023-07-15',
        'status': 'Returned',
      },
      {
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg',
        'borrowDate': '2023-05-10',
        'returnDate': '2023-06-10',
        'status': 'Returned',
      },
      {
        'title': 'Pride and Prejudice',
        'author': 'Jane Austen',
        'coverUrl': 'https://upload.wikimedia.org/wikipedia/commons/1/17/PrideAndPrejudiceTitlePage.jpg',
        'borrowDate': '2023-04-20',
        'returnDate': '2023-05-05',
        'status': 'Late Return',
      },
    ];
    
    if (loanHistory.isEmpty) {
      return _buildEmptyState('No loan history', 'Your previous loans will appear here');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: loanHistory.length,
      itemBuilder: (context, index) {
        final loan = loanHistory[index];
        final bool isLate = loan['status'] == 'Late Return';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book cover
                BookCoverImage(
                  imageUrl: loan['coverUrl'],
                  width: 70,
                  height: 100,
                ),
                
                const SizedBox(width: 16.0),
                
                // Loan details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan['title'],
                        style: AppTextStyles.headline4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        loan['author'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 16.0,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${_formatDate(loan['borrowDate'])} - ${_formatDate(loan['returnDate'])}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      // Status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: isLate
                              ? AppColors.error.withOpacity(0.1)
                              : AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          loan['status'],
                          style: AppTextStyles.caption.copyWith(
                            color: isLate ? AppColors.error : AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Borrow again button
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.primary,
                  ),
                  tooltip: 'Borrow Again',
                  onPressed: () {
                    // Borrow again process
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildLoanRequestsTab() {
    // Dummy loan requests data
    final List<Map<String, dynamic>> loanRequests = [
      {
        'title': 'The Alchemist',
        'author': 'Paulo Coelho',
        'coverUrl': '',
        'requestDate': '2023-09-05',
        'status': 'Pending',
      },
      {
        'title': 'Sapiens: A Brief History of Humankind',
        'author': 'Yuval Noah Harari',
        'coverUrl': '',
        'requestDate': '2023-09-01',
        'status': 'Approved',
        'pickupDate': '2023-09-15',
      },
      {
        'title': 'The Da Vinci Code',
        'author': 'Dan Brown',
        'coverUrl': '',
        'requestDate': '2023-08-25',
        'status': 'Rejected',
        'reason': 'Book damaged and under repair',
      },
    ];
    
    if (loanRequests.isEmpty) {
      return _buildEmptyState('No requests', 'Your loan requests will appear here');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: loanRequests.length,
      itemBuilder: (context, index) {
        final request = loanRequests[index];
        final status = request['status'];
        
        // Determine status color
        Color statusColor;
        switch (status) {
          case 'Pending':
            statusColor = Colors.orange;
            break;
          case 'Approved':
            statusColor = AppColors.success;
            break;
          case 'Rejected':
            statusColor = AppColors.error;
            break;
          default:
            statusColor = AppColors.textSecondary;
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Book cover
                    BookCoverImage(
                      imageUrl: request['coverUrl'],
                      width: 60,
                      height: 90,
                    ),
                    
                    const SizedBox(width: 16.0),
                    
                    // Request details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['title'],
                            style: AppTextStyles.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            request['author'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 24.0),
                
                // Request info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Requested on: ${_formatDate(request['requestDate'])}',
                      style: AppTextStyles.bodySmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Additional info based on status
                if (status == 'Approved' && request.containsKey('pickupDate')) ...[
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your request has been approved!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Please pick up your book by ${_formatDate(request['pickupDate'])}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (status == 'Rejected' && request.containsKey('reason')) ...[
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request rejected',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Reason: ${request['reason']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (status == 'Pending') ...[
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Cancel request
                        },
                        child: const Text('Cancel Request'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
