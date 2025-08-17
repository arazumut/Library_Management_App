import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/utils/validation_utils.dart';
import 'package:library_app/core/localization/app_localizations.dart';
import 'package:library_app/shared/widgets/custom_text_field.dart';
import 'package:library_app/shared/widgets/primary_button.dart';
import 'package:library_app/core/routes/app_routes.dart';

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
      // Kütüphaneyi veritabanına kaydetme işlemi burada yapılacak
      
      // İşlem başarılıysa kütüphaneler sayfasına dönüş
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.translate('library_added_successfully'))),
      );
      AppRoutes.goBack(context);
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
      context.l10n.translate('monday'),
      context.l10n.translate('tuesday'),
      context.l10n.translate('wednesday'),
      context.l10n.translate('thursday'),
      context.l10n.translate('friday'),
      context.l10n.translate('saturday'),
      context.l10n.translate('sunday'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.translate('add_library')),
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
                      context.l10n.translate('add_library_image'),
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
                label: context.l10n.translate('library_name'),
                hint: context.l10n.translate('enter_library_name'),
                validator: (value) => ValidationUtils.validateRequired(value, context.l10n.translate('library_name')),
                prefix: const Icon(Icons.account_balance),
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _addressController,
                label: context.l10n.translate('address'),
                hint: context.l10n.translate('enter_address'),
                validator: (value) => ValidationUtils.validateRequired(value, context.l10n.translate('address')),
                prefix: const Icon(Icons.location_on),
                maxLines: 3,
                required: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                label: context.l10n.translate('phone'),
                hint: context.l10n.translate('enter_phone'),
                prefix: const Icon(Icons.phone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: context.l10n.translate('email'),
                hint: context.l10n.translate('enter_email'),
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
                label: context.l10n.translate('website'),
                hint: context.l10n.translate('enter_website'),
                prefix: const Icon(Icons.web),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Çalışma Saatleri
              Text(
                context.l10n.translate('working_hours'),
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
                          labelText: context.l10n.translate('opening_time'),
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
                          labelText: context.l10n.translate('closing_time'),
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
                context.l10n.translate('open_days'),
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
                label: context.l10n.translate('description'),
                hint: context.l10n.translate('enter_library_description'),
                prefix: const Icon(Icons.description),
                maxLines: 5,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              PrimaryButton(
                text: context.l10n.translate('save'),
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
