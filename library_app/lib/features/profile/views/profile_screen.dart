import 'package:flutter/material.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/features/auth/view_models/auth_view_model.dart';
import 'package:library_app/core/services/theme_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Kullanıcı verileri
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    // Tema servisinden tema modunu al
    final themeService = Provider.of<ThemeService>(context, listen: false);

    // Varsayılan değerler
    _userData = {
      'name': 'Kullanıcı',
      'email': 'kullanici@example.com',
      'memberSince': DateTime.now().toString(),
      'membershipType': 'Standard',
      'membershipExpiry':
          DateTime.now().add(const Duration(days: 365)).toString(),
      'avatarUrl': '',
      'stats': {
        'totalBooks': 0,
        'currentlyBorrowing': 0,
        'readingStreak': 0,
        'overdueBooks': 0,
        'favoriteGenre': 'Belirlenmedi',
      },
      'preferences': {
        'notifications': true,
        'darkMode': themeService.isDarkMode,
        'language': 'Türkçe',
      },
    };

    // Kullanıcı verilerini yükle
    _loadUserData();
  }

  void _loadUserData() {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      if (authViewModel.isAuthenticated && authViewModel.currentUser != null) {
        final user = authViewModel.currentUser!;
        setState(() {
          _userData['name'] = user.fullName;
          _userData['email'] = user.email;
          if (user.profileImageUrl != null) {
            _userData['avatarUrl'] = user.profileImageUrl!;
          }
        });
      }
    } catch (e) {
      // İsteğe bağlı olarak hata işle
      debugPrint('Kullanıcı verileri yüklenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40.0),
                      // Profile Avatar
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            _userData['avatarUrl'].isNotEmpty
                                ? NetworkImage(_userData['avatarUrl'])
                                : null,
                        child:
                            _userData['avatarUrl'].isEmpty
                                ? Text(
                                  _getInitials(_userData['name']),
                                  style: AppTextStyles.headline3.copyWith(
                                    color: AppColors.primary,
                                  ),
                                )
                                : null,
                      ),
                      const SizedBox(height: 12.0),
                      // Name
                      Text(
                        _userData['name'],
                        style: AppTextStyles.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Membership
                      Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${_userData['membershipType']} Member',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Profile',
                onPressed: () {
                  // Navigate to edit profile
                },
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reading stats
                  _buildStatsSection(),

                  const SizedBox(height: 24.0),

                  // Account info
                  _buildSectionHeader('Account Information'),
                  _buildInfoCard([
                    _buildInfoRow('Email', _userData['email'], Icons.email),
                    const Divider(height: 24.0),
                    _buildInfoRow(
                      'Member Since',
                      _formatDate(_userData['memberSince']),
                      Icons.calendar_today,
                    ),
                    const Divider(height: 24.0),
                    _buildInfoRow(
                      'Membership Expires',
                      _formatDate(_userData['membershipExpiry']),
                      Icons.timer,
                    ),
                  ]),

                  const SizedBox(height: 24.0),

                  // Preferences
                  _buildSectionHeader('Preferences'),
                  _buildPreferencesCard(),

                  const SizedBox(height: 24.0),

                  // Actions
                  _buildSectionHeader('Actions'),
                  _buildActionsCard(),

                  const SizedBox(height: 24.0),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutConfirmationDialog();
                      },
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      label: Text(
                        'Log Out',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // App version
                  Center(
                    child: Text(
                      'App Version 1.0.0',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = _userData['stats'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reading Statistics', style: AppTextStyles.headline4),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  stats['totalBooks'].toString(),
                  'Books Read',
                  Icons.book,
                  AppColors.primary,
                ),
                _buildStatItem(
                  stats['currentlyBorrowing'].toString(),
                  'Borrowing',
                  Icons.book_online,
                  AppColors.secondary,
                ),
                _buildStatItem(
                  '${stats['readingStreak']} days',
                  'Streak',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite Genre',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        stats['favoriteGenre'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overdue Books',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        stats['overdueBooks'].toString(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              stats['overdueBooks'] > 0
                                  ? AppColors.error
                                  : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: AppTextStyles.headline4),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.0, color: AppColors.textSecondary),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(value, style: AppTextStyles.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Get notified about due dates and updates'),
            value: _userData['preferences']['notifications'],
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _userData['preferences']['notifications'] = value;
              });
            },
          ),
          const Divider(height: 0),
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return Column(
                children: [
                  ListTile(
                    title: const Text('Tema Modu'),
                    subtitle: const Text(
                      'Temayı sistem, karanlık veya açık olarak ayarlayın',
                    ),
                    leading: Icon(
                      themeService.themeMode == ThemeMode.system
                          ? Icons.brightness_auto
                          : themeService.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                    ),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeService.themeMode,
                      elevation: 4,
                      underline: Container(),
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.cardDark
                              : AppColors.surface,
                      onChanged: (ThemeMode? newValue) {
                        if (newValue != null) {
                          switch (newValue) {
                            case ThemeMode.system:
                              themeService.setSystemMode();
                              break;
                            case ThemeMode.light:
                              themeService.setLightMode();
                              break;
                            case ThemeMode.dark:
                              themeService.setDarkMode();
                              break;
                          }
                          setState(() {
                            _userData['preferences']['darkMode'] =
                                newValue == ThemeMode.dark;
                          });
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(
                            'Sistem',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(
                            'Açık',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(
                            'Karanlık',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_userData['preferences']['language']),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              // Show language selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Kayıtlı Kitaplarım',
        'icon': Icons.bookmark,
        'color': AppColors.primary,
        'onTap': () {
          // Navigate to saved books
        },
      },
      {
        'title': 'Okuma Geçmişim',
        'icon': Icons.history,
        'color': AppColors.secondary,
        'onTap': () {
          // Navigate to reading history
        },
      },
      {
        'title': 'Ödeme Yöntemleri',
        'icon': Icons.payment,
        'color': Colors.green,
        'onTap': () {
          // Navigate to payment methods
        },
      },
      {
        'title': 'Yardım & Destek',
        'icon': Icons.help_outline,
        'color': Colors.orange,
        'onTap': () {
          // Navigate to help and support
        },
      },
      {
        'title': 'Gizlilik ve Koşullar',
        'icon': Icons.privacy_tip_outlined,
        'color': Colors.purple,
        'onTap': () {
          // Navigate to privacy and terms
        },
      },
      {
        'title': 'Çıkış Yap',
        'icon': Icons.exit_to_app,
        'color': Colors.red,
        'onTap': () {
          _showLogoutConfirmationDialog();
        },
      },
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final action = actions[index];

          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: action['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(action['icon'], color: action['color'], size: 24.0),
            ),
            title: Text(action['title']),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              final onTapFunction = action['onTap'] as void Function();
              onTapFunction();
            },
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1) {
        initials += nameParts[1][0];
      }
    }
    return initials.toUpperCase();
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Çıkış Yapmak İstediğinize Emin Misiniz?'),
            content: const Text(
              'Çıkış yaptığınızda, tekrar giriş yapmanız gerekecektir.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _logout();
                },
                child: const Text('Çıkış Yap'),
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    try {
      // Çıkış işlemi için yükleme göstergesini göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.logout();

      if (!mounted) return;

      // Yükleme göstergesini kaldır
      Navigator.pop(context);

      // Login sayfasına yönlendir
      AppRoutes.navigateToAndRemove(context, AppRoutes.login);
    } catch (e) {
      if (!mounted) return;

      // Yükleme göstergesini kaldır
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yaparken bir hata oluştu: $e')),
      );
    }
  }
}
