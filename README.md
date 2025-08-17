# Kütüphane Yönetim Uygulaması

Bu Flutter projesi, kütüphane kitaplarının ve ödünç işlemlerinin yönetimini sağlayan bir mobil uygulamadır.

## Özellikler

- Kullanıcı kimlik doğrulama (giriş, kayıt, şifre sıfırlama)
- Kitap kataloğu görüntüleme ve arama
- Kitap ödünç alma ve iade etme
- Kişisel profil yönetimi
- Çoklu dil desteği (Türkçe, İngilizce)
- Karanlık/Aydınlık tema desteği

## Kurulum

1. Flutter SDK'yı yükleyin: [Flutter Kurulum Rehberi](https://docs.flutter.dev/get-started/install)
2. Projeyi klonlayın:
```bash
git clone https://github.com/arazumut/Library_Management_App.git
```
3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```
4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Proje Yapısı

- `lib/core`: Temel bileşenler, sabitler ve hizmetler
- `lib/features`: Özellik tabanlı modüller (kimlik doğrulama, kitaplar, vb.)
- `lib/shared`: Tüm uygulama genelinde paylaşılan bileşenler
- `assets`: Resimler, simgeler ve yerelleştirme dosyaları

## Katkıda Bulunma

1. Fork yapın
2. Yeni bir özellik dalı oluşturun (`git checkout -b yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik: Açıklama'`)
4. Dalınıza push yapın (`git push origin yeni-ozellik`)
5. Pull Request oluşturun

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır - detaylar için [LICENSE](LICENSE) dosyasına bakın.

## İletişim

Araz Umut - [@arazumut](https://github.com/arazumut)
