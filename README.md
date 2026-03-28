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
git clone https://github.com/Hamim688/Gas-Nugas-App.git
cd gas-nugas-app
flutter pub get