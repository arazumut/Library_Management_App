# Library Management App - Django API Entegrasyonu Kurulum Rehberi

## 🚀 Tebrikler! Django API Entegrasyonu Tamamlandı!

Bu Flutter uygulaması artık Django API'niz ile tam entegre olarak çalışmaya hazır!

## 📱 Neler Yapıldı

### ✅ API Entegrasyonu
- **Django Token Authentication** entegrasyonu
- **RESTful API servisleri** (Books, Libraries, Loans, Users)
- **Modern model sınıfları** Django API'ye uygun
- **Otomatik token yönetimi** ve refresh mekanizması
- **Error handling** ve network güvenliği

### ✅ Yeni Servis Mimarisi
- `ApiService` - HTTP istekleri için temel servis
- `AuthService` - Kimlik doğrulama işlemleri
- `BookService` - Kitap yönetimi
- `LibraryService` - Kütüphane yönetimi  
- `LoanService` - Ödünç alma işlemleri
- `ServiceLocator` - Dependency injection

### ✅ Güncellenmiş Modeller
- `UserModel` - Django user formatına uygun
- `BookModel` - API'den gelen kitap verileri
- `LibraryModel` - Kütüphane bilgileri
- `LoanModel` - Ödünç alma kayıtları
- `CategoryModel` - Kitap kategorileri

## 🔧 Django API Ayarları

### 1. API Base URL Konfigürasyonu

Uygulamanın API endpoint'i şu şekilde ayarlandı:

```dart
// lib/core/network/api_endpoints.dart
static String get baseUrl => 'http://10.0.2.2:8000/api';
```

### 2. Platform Bazlı URL'ler

**Android Emülatör:**
```
http://10.0.2.2:8000/api
```

**iOS Simulator:**
```
http://127.0.0.1:8000/api
```

**Fiziksel Cihaz:**
```
http://[BILGISAYAR_IP]:8000/api
```

### 3. Django Sunucusu Başlatma

Django sunucunuzu şu komutla başlatın:

```bash
# Tüm arayüzlerde dinle (fiziksel cihaz için)
python manage.py runserver 0.0.0.0:8000

# Veya sadece localhost
python manage.py runserver 127.0.0.1:8000
```

## 🔐 Kimlik Doğrulama

### Token Tabanlı Giriş
Uygulama Django Token Authentication kullanıyor:

```json
POST /api/token/
{
  "username": "kullanici_adi",
  "password": "sifre"
}
```

### Yanıt:
```json
{
  "token": "your_auth_token_here"
}
```

## 📊 API Endpoint'leri

### Books (Kitaplar)
- `GET /api/books/` - Tüm kitaplar
- `GET /api/books/{id}/` - Kitap detayı
- `POST /api/books/` - Yeni kitap (admin)
- `PUT /api/books/{id}/` - Kitap güncelle (admin)
- `DELETE /api/books/{id}/` - Kitap sil (admin)

### Libraries (Kütüphaneler)
- `GET /api/libraries/` - Tüm kütüphaneler
- `GET /api/libraries/{id}/` - Kütüphane detayı
- `GET /api/libraries/{id}/books/` - Kütüphanedeki kitaplar

### Users (Kullanıcılar)
- `GET /api/users/me/` - Mevcut kullanıcı bilgisi
- `POST /api/token/` - Login

### Loans (Ödünç Alma)
- `GET /api/loans/` - Ödünç alma kayıtları
- `POST /api/loans/` - Kitap ödünç al
- `POST /api/loans/{id}/return/` - Kitap iade et

## 🎯 Kullanım Kılavuzu

### 1. Uygulama Başlatma

```bash
# Dependencies yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

### 2. Test Kullanıcısı

Django admin panelinden test kullanıcısı oluşturun:

```bash
python manage.py createsuperuser
```

### 3. API Test

Swagger UI ile API'yi test edin:
```
http://127.0.0.1:8000/api/docs/
```

## 🔧 Yapılandırma

### API URL Değiştirme

Fiziksel cihazda test için IP adresinizi bulun:

```bash
# macOS/Linux
ifconfig | grep "inet " | grep -v 127.0.0.1

# Windows  
ipconfig
```

Sonra `api_endpoints.dart` dosyasında URL'i güncelleyin:

```dart
static String get baseUrl => 'http://[YOUR_IP]:8000/api';
```

### CORS Ayarları

Django'da CORS sorunları için:

```bash
pip install django-cors-headers
```

`settings.py`:
```python
INSTALLED_APPS = [
    'corsheaders',
    # ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    # ...
]

CORS_ALLOW_ALL_ORIGINS = True  # Geliştirme için
```

## 🎨 UI Güncellemeleri

### Login Screen
- Username/password ile giriş
- Django token authentication

### Dashboard
- Gerçek API verisiyle kitap listesi
- Dinamik kategoriler
- Canlı arama

### Profile
- API'den kullanıcı bilgileri
- Token tabanlı session yönetimi

## 🚦 Sonraki Adımlar

1. **Django sunucunuzu başlatın**
2. **Test kullanıcısı oluşturun**
3. **Uygulamayı çalıştırın**
4. **Login yapın ve test edin**

## 🐛 Sorun Giderme

### Network Hatası
- Django sunucusunun çalıştığından emin olun
- IP adresinin doğru olduğunu kontrol edin
- CORS ayarlarını kontrol edin

### Authentication Hatası
- Kullanıcı adı/şifrenin doğruluğunu kontrol edin
- Django'da token authentication aktif olduğundan emin olun

### Model Hatası
- API response formatının model'e uygunluğunu kontrol edin
- Django serializer'ların doğru çalıştığından emin olun

## 🎉 Tebrikler!

Flutter uygulamanız artık Django API ile tamamen entegre! Gerçek bir library management sistemi olarak çalışmaya hazır! 🚀📚

Happy coding! 💻✨
