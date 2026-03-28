# 🚀 Gas Nugas - Task Management App

Aplikasi manajemen tugas (To-Do List) berbasis **Flutter** dan **Firebase** yang dirancang khusus buat ngebantu mahasiswa atau siapa aja biar nggak keteteran sama *deadline*. Dibuat dengan UI/UX yang *clean*, modern, dan responsif.

## ✨ Fitur Unggulan
* **🔐 Authentication:** Sistem Login dan Register aman menggunakan Firebase Authentication (Email & Password).
* **🗂️ Multi-User Ready:** Data tiap pengguna dipisah secara aman menggunakan UID. Tugas lu nggak bakal kecampur sama tugas orang lain!
* **📝 CRUD Operations:** Tambah, baca, edit, dan hapus tugas dengan mudah secara *real-time*.
* **✅ Status Tracking:** Tandai tugas yang udah selesai, dan tugas bakal otomatis pindah ke tab "Selesai".
* **🗑️ Swipe to Delete:** Hapus tugas gampang banget, tinggal *swipe* (geser) kartu ke kiri dilengkapi dengan pop-up konfirmasi (mencegah salah hapus).
* **🎨 Custom UI & Icon:** Dilengkapi dengan pop-up profil pengguna dan *custom app icon*.

## 🛠️ Tech Stack
* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Cloud Firestore & Authentication)

---

## ⚙️ Tutorial Lengkap Install & Setup Firebase (PENTING!)

Karena alasan keamanan (*Security Best Practices*), file konfigurasi rahasia Firebase bawaan aplikasi ini **TIDAK** disertakan di dalam repository publik ini. 

Kalau lu nge-clone project ini dan langsung di-run, layarnya bakal merah/error! Lu harus bikin database Firebase lu sendiri dengan ngikutin 4 langkah gampang di bawah ini:

### Langkah 1: Clone Repository
Buka terminal/CMD lu, lalu ketik perintah ini:
```bash
git clone [https://github.com/Hamim688/Gas-Nugas-App.git](https://github.com/Hamim688/Gas-Nugas-App.git)
cd Gas-Nugas-App
flutter pub get
```

### Langkah 2: Bikin Project & Database di Firebase (GRATIS)
1. Buka [Firebase Console](https://console.firebase.google.com/) dan login pakai akun Google.
2. Klik **Add Project** (Tambah Proyek), kasih nama bebas (misal: "Gas Nugas Ku"), dan klik **Continue** sampai project berhasil dibuat.
3. **Nyalain Fitur Login (Auth):** Di menu sebelah kiri, masuk ke **Build** -> **Authentication** -> klik **Get Started**. Pilih tab **Sign-in method**, klik opsi **Email/Password**, nyalain switch **Enable** yang paling atas, lalu klik **Save**.
4. **Nyalain Fitur Database:** Di menu sebelah kiri, masuk ke **Build** -> **Firestore Database** -> klik **Create database**.
   * Pilih lokasi server (disarankan `asia-southeast2` / Jakarta biar cepat).
   * Pilih opsi **Start in test mode** untuk sementara agar bisa langsung dipakai nulis data.
   * Klik **Enable**.

### Langkah 3: Sambungin Firebase ke Kodingan (Pilih Salah Satu)
Biar kodingan lu bisa ngobrol sama database yang baru aja lu bikin, lu butuh kunci rahasianya.

**Cara Paling Gampang (Pakai Firebase CLI):**
1. Buka terminal di VS Code lu.
2. Ketik perintah ini buat manggil jin Firebase:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
3. Nanti di terminal bakal muncul pilihan project. Pilih project Firebase yang baru aja lu bikin di Langkah 2 pakai panah keyboard dan tekan Enter.
4. Centang Android (dan iOS kalau butuh) pakai Spasi, lalu Enter.
5. Tungguin sampai beres. File `firebase_options.dart` dan `google-services.json` bakal otomatis ter-generate di folder lu!

**Cara Manual (Khusus Android):**
1. Di halaman depan Firebase Console lu, klik logo **Android** (gambar robot ijo).
2. Masukin Android package name (bisa dicek di file `android/app/build.gradle` bagian `applicationId`, contoh: `com.example.proect_gas_nugas`).
3. Klik **Register app**.
4. Download file `google-services.json`.
5. Pindahkan file yang baru di-download itu ke dalam folder `android/app/` di project Flutter lu.

### Langkah 4: Run Aplikasi!
Kalau file konfigurasi udah masuk, lu tinggal nge-run aplikasinya di emulator atau device Android lu:
```bash
flutter run
```