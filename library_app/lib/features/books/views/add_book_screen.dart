import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/shared/widgets/custom_text_field.dart';
import 'package:library_app/shared/widgets/primary_button.dart';
import 'package:library_app/core/routes/app_routes.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _isbnController = TextEditingController();
  final _pagesController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _publicationDate;
  String? _selectedCategory;
  String? _selectedLanguage;

  final List<String> _categories = [
    'Roman',
    'Bilim Kurgu',
    'Fantastik',
    'Biyografi',
    'Tarih',
    'Felsefe',
    'Psikoloji',
    'Çocuk',
    'Kişisel Gelişim',
    'Ekonomi',
    'Diğer',
  ];

  final List<String> _languages = [
    'Türkçe',
    'İngilizce',
    'Fransızca',
    'Almanca',
    'İspanyolca',
    'İtalyanca',
    'Rusça',
    'Çince',
    'Japonca',
    'Arapça',
    'Diğer',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _isbnController.dispose();
    _pagesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publicationDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _publicationDate) {
      setState(() {
        _publicationDate = picked;
      });
    }
  }

  Future<void> _saveBook() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Kitabı veritabanına kaydetme işlemi burada yapılacak
      
      // İşlem başarılıysa kitaplar sayfasına dönüş
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.translate('book_added_successfully'))),
      );
      AppRoutes.goBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.translate('add_book')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kitap Kapağı Ekleme Alanı
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.translate('add_cover_image'),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kitap Bilgileri Formu
              CustomTextField(
                controller: _titleController,
                label: context.l10n.translate('title'),
                hint: context.l10n.translate('enter_book_title'),
                validator: (value) => ValidationUtils.validateRequired(value, context.l10n.translate('title')),
                prefix: const Icon(Icons.book),
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _authorController,
                label: context.l10n.translate('author'),
                hint: context.l10n.translate('enter_author_name'),
                validator: (value) => ValidationUtils.validateRequired(value, context.l10n.translate('author')),
                prefix: const Icon(Icons.person),
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _publisherController,
                label: context.l10n.translate('publisher'),
                hint: context.l10n.translate('enter_publisher_name'),
                prefix: const Icon(Icons.business),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _isbnController,
                label: context.l10n.translate('isbn'),
                hint: context.l10n.translate('enter_isbn'),
                prefix: const Icon(Icons.qr_code),
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateISBN(value),
              ),
              const SizedBox(height: 16),

              // Sayfa Sayısı
              CustomTextField(
                controller: _pagesController,
                label: context.l10n.translate('pages'),
                hint: context.l10n.translate('enter_page_count'),
                prefix: const Icon(Icons.format_list_numbered),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Kategori Seçimi
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: context.l10n.translate('category'),
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Dil Seçimi
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: context.l10n.translate('language'),
                  prefixIcon: const Icon(Icons.language),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Yayın Tarihi Seçimi
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.l10n.translate('publication_date'),
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _publicationDate == null
                            ? context.l10n.translate('select_date')
                            : '${_publicationDate!.day}/${_publicationDate!.month}/${_publicationDate!.year}',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Açıklama
              CustomTextField(
                controller: _descriptionController,
                label: context.l10n.translate('description'),
                hint: context.l10n.translate('enter_book_description'),
                prefix: const Icon(Icons.description),
                maxLines: 5,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              PrimaryButton(
                text: context.l10n.translate('save'),
                onPressed: _saveBook,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
