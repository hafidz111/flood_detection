# 🌊 Flood Detection

Aplikasi seluler ini berfungsi sebagai **dashboard** dan **sistem pencatatan riwayat (history)** untuk data sensor yang mendeteksi potensi banjir. Aplikasi menyediakan pemantauan real-time serta autentikasi pengguna yang aman.

---

## 🖼️ Tampilan Aplikasi
Aplikasi Flood Detection
![Aplikasi Flood Detection](https://github.com/user-attachments/assets/336fd969-99aa-46cd-bb82-19e842301e98)

---

## ✨ Fitur Utama

### 📊 Real-time Dashboard
- **Status Banjir**: Menampilkan status terkini (Aman, Waspada, Bahaya) berdasarkan data sensor.
- **Data Sensor**: Memvisualisasikan data real-time (Jarak, Curah Hujan, Suhu, Kelembaban) menggunakan *Donut Charts* dan *Progress Bars*.
- **Refresh Data**: Fitur *pull-to-refresh* untuk memuat ulang data sensor dan histori.

### 💾 History & Data Management
- **Capture History**: Menyimpan snapshot data sensor real-time ke histori (Realtime Database).
- **History Screen**: Menampilkan daftar riwayat status banjir per pengguna.
- **Separation of Data**: Riwayat data tersimpan per-user di `histories_by_user`.

### 🔒 Autentikasi
- **Login / Sign In** menggunakan Firebase Authentication (Email & Password).
- **Register / Sign Up** untuk pendaftaran pengguna baru.
- **Error Handling** autentikasi yang spesifik (mis: `weak-password`, `email-already-in-use`).

---

## 💻 Teknologi & Arsitektur

| Kategori | Teknologi | Keterangan |
|---------|-----------|------------|
| Framework | **Flutter** | Frontend/UI |
| State Mgmt | **Provider** | (AuthProvider, SensorProvider, HistoryProvider) |
| Autentikasi | **Firebase Auth** | Mengelola login pengguna |
| Real-time Data | **Cloud Firestore** | Untuk data sensor real-time |
| History Data | **Firebase Realtime DB** | Menyimpan riwayat per pengguna |
| Asynchronous | **Future & Stream** | Operasi I/O dan stream update |

---

## 📂 Struktur Providers (State Management)

| Provider | Tanggung Jawab | Keterangan |
|----------|----------------|------------|
| **AuthProvider** | Mengelola sesi pengguna | Login, register, logout, mapping error FirebaseAuthException |
| **SensorProvider** | Memantau data sensor utama | Listen ke dokumen terbaru di Firestore, menyediakan `currentSensorData` |
| **HistoryProvider** | Mengelola riwayat data | Menyimpan & membaca data dari Realtime DB per user |

---

## 🚀 Instalasi dan Setup

### 1. Prerequisites
Pastikan Anda telah menginstal:
- Flutter SDK  
- Android Studio / VS Code

### 2. Kloning Repositori
```bash
git clone https://github.com/hafidz111/flood-detection.git
cd flood_detection
```

### 3. Konfigurasi Firebase

1. **Buat proyek di Firebase Console.**
2. **Aktifkan layanan berikut:**
   - Firebase Authentication (mode Email/Password)
   - Cloud Firestore
   - Firebase Realtime Database
3. **Hubungkan aplikasi Flutter ke Firebase** menggunakan Firebase CLI atau Setup Manual:
   - Unduh file konfigurasi:
     - `google-services.json` (Android)
     - `GoogleService-Info.plist` (iOS)
   - Letakkan file pada direktori yang sesuai:
     - `android/app/`
     - `ios/Runner/`
4. **Pastikan structure data Firebase telah sesuai:**

---

### 4. Jalankan Aplikasi

```bash
flutter pub get
flutter run
```
