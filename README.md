# pay.in - Aplikasi Invoicing untuk Freelancers

## Deskripsi Singkat Project

**pay.in** adalah aplikasi mobile berbasis Flutter (Dart) yang dirancang untuk memudahkan freelancers dalam mengelola quotation dan pembuatan invoice secara efisien dan modern. Dengan antarmuka yang intuitif, **pay.in** memudahkan freelancers untuk mencatat transaksi, membuat quotation, serta membuat dan mengirim invoice langsung dari perangkat mobile.

Aplikasi ini mendukung berbagai fitur utama seperti:
- **Pencatatan transaksi penjualan secara real-time**
- **Pembuatan dan pengelolaan invoice secara otomatis**
- **Laporan penjualan dan analisis performa bisnis**

---

## Cara Menjalankan Program

Ikuti langkah-langkah berikut untuk menjalankan aplikasi **pay.in** di perangkat Anda:

### 1. Persiapan Lingkungan Pengembangan

- Pastikan sudah menginstall [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Pastikan sudah menginstall [Dart SDK](https://dart.dev/get-dart) (biasanya sudah termasuk dalam Flutter SDK)
- Pastikan sudah menginstall Android Studio/Xcode/VS Code (untuk emulator atau perangkat fisik)
- Pastikan sudah mengatur environment variable untuk `flutter` dan `dart`

### 2. Clone Repository

git clone https://github.com/Naangz/payin-app-v1
cd payin-app-v1


### 3. Install Dependencies

flutter pub get


### 4. Jalankan Aplikasi di Emulator/Perangkat

- Pastikan emulator sudah berjalan atau perangkat sudah terhubung.
- Jalankan perintah berikut:

flutter run


---

## Integrasi API Mailer

Untuk mengintegrasikan API Mailer pada aplikasi **pay.in**, ikuti langkah berikut:

1. **Masuk ke folder `payin-mailer`**  
   Pastikan Anda sudah berada di dalam direktori project utama.

cd payin-mailer


2. **Buat file `.dev.vars`**  
Tambahkan file baru bernama `.dev.vars` pada folder `payin-mailer`.

3. **Simpan API Key**  
Masukkan API key Mailer Anda ke dalam file `.dev.vars` dengan format berikut:

MAILER_API_KEY=your_api_key_disini


4. **Pastikan file `.dev.vars` tidak di-commit ke repository**  
Tambahkan `.dev.vars` ke file `.gitignore` untuk menjaga keamanan API key Anda.

---

## Daftar Anggota Kelompok

| Nama                               | NRP         |
|-------------------------------------|-------------|
| Indriyani Alif Safitri             | 5026221009  |
| Muhammad Alvin Fairuz Tsany        | 5026221151  |
| Nathan Pradana Shakti              | 5026221199  |
| M Maulana Mukti                    | 5026221201  |
| Akbar Daniswara Cahya Buana        | 5026221202  |

---

> Untuk pertanyaan atau kontribusi, silakan hubungi salah satu anggota kelompok.
