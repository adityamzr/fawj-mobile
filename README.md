# FAWJ Flutter UX Prototype v1

Prototype lokal untuk memvalidasi pengalaman pertolongan darurat FAWJ. Seluruh data, perpindahan posisi, pergantian peran, dan status incident disimulasikan di perangkat. Tidak ada backend, API, database, autentikasi, GPS, Google Maps, notifikasi push, analytics, atau integrasi produksi.

## Menjalankan aplikasi

Prasyarat: Flutter stable terbaru, Android Studio/Android SDK untuk Android, dan Xcode untuk iOS.

Project ini sengaja dikirim tanpa file launcher hasil generator SDK karena Flutter SDK tidak tersedia di lingkungan penyusunan. Setelah mengekstrak project, jalankan satu kali:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
flutter run
```

Perintah `flutter create` hanya membangkitkan launcher Android/iOS standar; isi aplikasi di `lib/`, konfigurasi paket, dan test tetap dipertahankan.

### Cara termudah untuk non-developer

Setiap push ke branch `main` atau `dev` otomatis menjalankan GitHub Actions:

1. Buka tab **Actions** di repository.
2. Pilih proses **Build Android APK** yang paling baru dan berstatus hijau.
3. Buka bagian **Artifacts**.
4. Unduh `fawj-prototype-android`.
5. Ekstrak ZIP hasil unduhan, lalu pasang `app-release.apk` di Android.

APK merupakan prototype untuk pengujian internal dan belum didistribusikan melalui Play Store.

## Alur demo utama

1. Buka mode **Jamaah**.
2. Tekan lingkaran merah **BUTUH BANTUAN**.
3. Pilih **Saya Tersesat**, lalu **KIRIM BANTUAN**.
4. Layar pencarian tampil selama sekitar 3 detik dan beralih ke mode **Staff**.
5. Pada incoming SOS, tekan **SAYA BANTU**.
6. Map lokal mulai menggerakkan marker dari 320 → 240 → 160 → 90 → 40 meter.
7. Tekan **SAYA SUDAH TIBA**.
8. Aplikasi beralih ke jamaah. Tekan **YA, SUDAH**.
9. Layar **Alhamdulillaah** tampil. Tekan **SELESAI** untuk kembali ke Home normal.

## Mengganti peran

Gunakan navigasi bawah:

- **Jamaah** — Home, pemilihan SOS, pencarian, map, konfirmasi bertemu.
- **Staff** — dashboard pendamping, incoming SOS, dan map menuju jamaah.
- **Travel** — demonstrasi mobile dashboard travel/PPIU masa depan.

Pergantian mode tidak menghapus incident aktif.

## Memicu state pengujian

Saat berjalan dalam debug mode, tekan tombol kecil bergambar pengaturan di kanan bawah. Panel ini dapat memaksa state:

- Idle
- Pilih SOS / konfirmasi
- Searching
- Claimed / En Route / Nearby
- Arrived / Resolved
- Claim Lost
- No Responder
- Responder Cancelled / Redispatching
- Offline
- Poor Location Accuracy

Cabang khusus:

- **Claim Lost:** paksa `Claim Lost`; tampil pesan bahwa petugas lain sudah menangani permintaan.
- **Responder cancellation:** saat berada di map Staff, buka menu tiga titik → **Tidak dapat melanjutkan** → **ALIHKAN**. Jamaah melihat pencarian ulang tanpa membuat SOS baru.
- **Persistent banner:** saat rescue aktif, pilih menu map → **Tutup tampilan map**. Banner merah tetap terlihat dan dapat membuka kembali incident.
- **No responder:** paksa `No Responder`; tersedia Tour Leader, Kartu Darurat, dan Coba Lagi.
- **Offline / poor accuracy:** paksa state terkait untuk memeriksa pesan lokasi terakhir dan peringatan akurasi.

## Arsitektur singkat

- `PrototypeController` adalah `ChangeNotifier` tunggal yang menyimpan peran, state incident, jarak, alasan SOS, dan status tampilan map.
- `PrototypeShell` memilih layar berdasarkan kombinasi peran dan state, sekaligus menjaga banner incident tetap persisten.
- `MockRescueMap` memakai `CustomPainter` dan marker lokal; tidak memakai provider peta atau GPS.
- Timer lokal mensimulasikan dispatch dan pergerakan responder.
- Setiap fitur disimpan dalam foldernya sendiri agar prototype mudah dibaca tanpa membawa arsitektur produksi.

## Batasan prototype

- Semua data akan kembali ke awal setelah aplikasi ditutup.
- Panggilan, pesan, navigasi eksternal, quick action, dan detail incident hanya memberi respons demo.
- Tidak ada koordinat geografis, sinkronisasi antarperangkat, atomic claim sungguhan, SLA, audit log, atau mekanisme keamanan produksi.
- Dashboard Travel adalah representasi mobile saja, bukan aplikasi Nuxt.
- Logo memakai placeholder teks resmi `FAWJ / فوج` karena aset logo tidak dilampirkan.
