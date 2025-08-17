import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';

import 'package:library_app/shared/widgets/custom_text_field.dart';
import 'package:library_app/shared/widgets/primary_button.dart';
import 'package:library_app/core/routes/app_routes.dart';
import 'package:library_app/features/libraries/models/library.dart';
import 'package:library_app/features/libraries/services/library_service.dart';

class AddLibraryScreen extends StatefulWidget {
  const AddLibraryScreen({Key? key}) : super(key: key);

  @override
  State<AddLibraryScreen> createState() => _AddLibraryScreenState();
}

class _AddLibraryScreenState extends State<AddLibraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Kütüphane Açılış/Kapanış Saatleri
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 18, minute: 0);
  
  // Açık Günler
  List<bool> _openDays = List.generate(7, (index) => index < 5); // Pazartesi-Cuma açık varsayılan olarak

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _openingTime,
    );
    if (picked != null && picked != _openingTime) {
      setState(() {
        _openingTime = picked;
      });
    }
  }

  Future<void> _selectClosingTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _closingTime,
    );
    if (picked != null && picked != _closingTime) {
      setState(() {
        _closingTime = picked;
      });
    }
  }

  Future<void> _saveLibrary() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create a Library object from the form data
        final library = Library(
          name: _nameController.text,
          address: _addressController.text,
          phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
          email: _emailController.text.isNotEmpty ? _emailController.text : null,
          website: _websiteController.text.isNotEmpty ? _websiteController.text : null,
          description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          openingTime: _openingTime,
          closingTime: _closingTime,
          openDays: _openDays,
          userId: 1, // Current user ID - this would typically come from authentication
          isPublic: true, // Default to public
        );
        
        // Save the library to the database
        final libraryService = LibraryService();
        await libraryService.addLibrary(library);
        
        if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kütüphane başarıyla eklendi')),
      );
        AppRoutes.goBack(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kütüphane Ekle'),
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
              // Kütüphane Fotoğrafı Ekleme Alanı
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
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
                      'Kütüphane Fotoğrafı Ekle',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kütüphane Bilgileri Formu
              CustomTextField(
                controller: _nameController,
                label: 'Kütüphane Adı',
                hint: 'Kütüphane adını girin',
                validator: (value) => ValidationUtils.validateRequired(value, 'Kütüphane Adı'),
                prefix: const Icon(Icons.account_balance),
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _addressController,
                label: 'Adres',
                hint: 'Kütüphane adresini girin',
                validator: (value) => ValidationUtils.validateRequired(value, 'Adres'),
                prefix: const Icon(Icons.location_on),
                maxLines: 3,
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                label: 'Telefon',
                hint: 'Telefon numarasını girin',
                prefix: const Icon(Icons.phone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: 'E-posta',
                hint: 'E-posta adresini girin',
                prefix: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return ValidationUtils.validateEmail(value);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _websiteController,
                label: 'Web Sitesi',
                hint: 'Web sitesi adresini girin',
                prefix: const Icon(Icons.web),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Çalışma Saatleri
              Text(
                'Çalışma Saatleri',
                style: AppTextStyles.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectOpeningTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Açılış Saati',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(_formatTimeOfDay(_openingTime)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectClosingTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Kapanış Saati',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(_formatTimeOfDay(_closingTime)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Açık Günler
              Text(
                'Açık Günler',
                style: AppTextStyles.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  7,
                  (index) => FilterChip(
                    label: Text(weekDays[index]),
                    selected: _openDays[index],
                    onSelected: (selected) {
                      setState(() {
                        _openDays[index] = selected;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Açıklama
              CustomTextField(
                controller: _descriptionController,
                label: 'Açıklama',
                hint: 'Kütüphane hakkında açıklama girin',
                prefix: const Icon(Icons.description),
                maxLines: 5,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              PrimaryButton(
                text: 'Kaydet',
                onPressed: _saveLibrary,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
