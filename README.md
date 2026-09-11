# FAWJ Flutter UX Prototype v1

Prototype lokal untuk memvalidasi pengalaman pertolongan darurat FAWJ. Seluruh data, perpindahan posisi, persona demo, dan status incident disimulasikan di perangkat. Tidak ada backend, API, database, autentikasi, GPS, Google Maps, notifikasi push, analytics, atau integrasi produksi.

## Menjalankan aplikasi

Prasyarat: Flutter stable terbaru, Android Studio/Android SDK untuk Android, dan Xcode untuk iOS.

Project ini dikirim tanpa launcher hasil generator SDK. Setelah mengekstrak project, jalankan satu kali:

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter analyze
flutter test
flutter run
```

Untuk pengujian ringan melalui Chrome dengan tampilan mobile:

```bash
flutter run -d chrome
```

### Mengunduh APK dari GitHub Actions

Setiap push ke branch `main` atau `dev` menjalankan workflow build Android:

1. Buka tab **Actions** di repository.
2. Pilih **Build Android APK** terbaru yang berstatus hijau.
3. Buka bagian **Artifacts**.
4. Unduh `fawj-prototype-android`.
5. Ekstrak hasil unduhan dan pasang `app-release.apk` di Android.

APK hanya untuk pengujian internal dan belum didistribusikan melalui Play Store.

## Navigasi mobile

Jamaah memiliki menu:

- Beranda
- Peta
- Perjalanan
- Bantuan
- Akun

Staff lapangan—Tour Leader, Muthawwif, atau PIC—memiliki menu:

- Dashboard
- Peta
- Jamaah
- Operasional
- Akun

Beranda Jamaah, Dashboard Staff, dan alur SOS berfungsi sebagai prototype utama. Menu lainnya masih berupa placeholder ringan. Travel Admin adalah role web dalam arsitektur final dan tidak muncul sebagai role atau tab mobile.

## Prototype Tools

Dalam debug mode, tekan tombol kecil **DEV**. Panel ini khusus pengujian dan tidak tampil pada release build.

Prototype Tools dapat:

- mengganti viewer antara Jamaah dan Staff tanpa mengubah incident;
- memaksa seluruh state darurat;
- mereset prototype;
- membuka **Travel Web Dashboard Preview** untuk presentasi.

Travel preview bukan implementasi dashboard Nuxt dan bukan role aplikasi mobile.

## Alur demo utama

Karena ini demo satu perangkat, persona diganti secara manual melalui Prototype Tools:

1. Dalam mode **Jamaah**, tekan **BUTUH BANTUAN**.
2. Pilih alasan dan tekan **KIRIM BANTUAN**.
3. Buka **DEV**, lalu ubah viewer ke **Staff**.
4. Pada incoming SOS, tekan **SAYA BANTU**.
5. State berjalan `dispatching → claimed → enRoute` tanpa mengganti persona.
6. Map lokal menggerakkan marker 320 → 240 → 160 → 90 → 40 meter.
7. Tekan **SAYA SUDAH TIBA**.
8. Buka **DEV**, lalu ubah viewer ke **Jamaah**.
9. Pilih **YA, SUDAH** untuk menyelesaikan bantuan.
10. Pada layar **Alhamdulillaah**, tekan **SELESAI**.

## Cabang pengujian

- **Claim Lost:** paksa state `Claim Lost`; Staff dapat kembali aman ke Dashboard.
- **Responder cancellation:** dari map Staff pilih **Tidak dapat melanjutkan → ALIHKAN**. State bergerak `responderCancelled → redispatching → dispatching`, lalu incoming SOS tersedia kembali tanpa membuat SOS baru.
- **Persistent incident:** saat rescue aktif, pindah melalui bottom navigation atau pilih **Tutup tampilan map**. Banner merah tetap terlihat dan dapat membuka incident kembali.
- **No Responder:** tersedia Tour Leader, Kartu Darurat, dan Coba Lagi.
- **Offline:** menampilkan lokasi terakhir tanpa mengakhiri incident.
- **Poor Location Accuracy:** hanya menampilkan peringatan akurasi sekitar ±85 meter. Rescue map normal menampilkan akurasi sekitar ±15 meter.

## Model prototype

`PrototypeController` memisahkan:

- `viewerRole`: Jamaah atau Staff;
- `incidentState`: status alur pertolongan;
- navigation index untuk masing-masing viewer;
- status tampilan incident dan Travel Web Dashboard Preview.

Pergantian viewer melalui Prototype Tools tidak mengubah incident. Navigasi biasa juga tidak mereset incident aktif.

State prototype ini hanya simulasi UX. Dalam arsitektur produksi, konsep berikut harus dimodelkan secara independen dan dapat aktif bersamaan:

```text
incidentState = enRoute
networkState = offline
locationQuality = poor
viewerRole = pilgrim
```

Enum prototype saat ini tidak boleh disalin langsung menjadi domain model produksi.

## Batasan prototype

- Semua data kembali ke awal setelah aplikasi ditutup.
- Panggilan, pesan, navigasi eksternal, quick action, dan detail incident hanya memberi respons demo.
- Tidak ada koordinat geografis, sinkronisasi antarperangkat, atomic claim sungguhan, SLA, audit log, atau mekanisme keamanan produksi.
- Mock map memakai `CustomPainter`; tidak ada provider peta atau GPS.
- Logo memakai placeholder teks `FAWJ / فوج` karena aset logo belum tersedia.
