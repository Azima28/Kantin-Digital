# Rencana Tahapan Implementasi & Arsitektur UI/UX

Dokumen ini berisi cetak biru arsitektur, sitemap, panduan visual, dan tahapan implementasi untuk proyek **Kantin Digital** (multi-platform) agar dapat dibaca, dipahami, dan dilanjutkan oleh agen AI lain atau pengembang.

**Terakhir diperbarui**: 18 Juni 2026

---

## 🎨 1. Panduan Desain Visual (Design System)

Aplikasi ini dirancang dengan gaya **Minimalis Modern** yang berkiblat pada **iOS Layout (Cupertino-style)** dengan bahasa copywriting yang **sangat familiar bagi orang Indonesia (Indonesian Friendly)**.

*   **Tipografi**: Google Fonts `Be Vietnam Pro` — font sans-serif modern yang bersih.
*   **Warna Utama**:
    *   *Primary Teal* (`#003434`): Gelap, profesional, digunakan sebagai warna brand utama.
    *   *Surface Background* (`#FBF9F8`): Off-white hangat.
    *   *Card Background* (`#FFFFFF`): Putih bersih untuk kontainer data.
    *   *Success Green* (`#006A35`): Status aktif/berhasil.
    *   *Danger Red* (`#BA1A1A`): Error/blokir/saldo rendah.
    *   *Muted Text* (`#6F7978`): Teks sekunder.
*   **Karakteristik iOS**:
    *   *Flat Minimalist Elements*: Bayangan halus (`blurRadius: 15, alpha: 0.04`), radius melengkung (`borderRadius: 12` hingga `24`).
    *   *iOS Grab Handle* (`───`): Strip pemandu di bagian atas untuk bottom sheet modal.
    *   *Cupertino Segmented Control*: Tab filter berbentuk pil horizontal.
    *   *Cupertino Switch*: Toggle oval membulat untuk status aktif/nonaktif.
    *   *CupertinoActivityIndicator*: Loading indicator khas iOS.
*   **Istilah Lokal (Copywriting)**:
    *   "Isi Saldo", "Bekukan Kartu", "Riwayat Jajan", "Koreksi Saldo", "Tap Kartu Siswa", "Cek Kartu", "Kartu Terhubung", "Belum Ada Kartu", "Saldo Rendah".

---

## 🏗️ 2. Arsitektur Teknis

### Tech Stack
*   **Frontend**: Flutter (Dart) — single codebase untuk Android & iOS
*   **Backend**: Supabase (PostgreSQL + Auth + Storage + Realtime)
*   **State Management**: Riverpod (StateNotifier, FutureProvider, Family providers)
*   **Routing**: GoRouter (ShellRoute untuk bottom nav, GoRoute untuk sub-pages)
*   **Database**: PostgreSQL dengan Row Level Security (RLS)
*   **Authentication**: Supabase Auth (JWT session) + fallback profiles-based auth

### Layer Arsitektur
```
┌─────────────────────────────────────────────┐
│                  UI Layer                    │
│  (Screens, Widgets, MainLayouts)            │
├─────────────────────────────────────────────┤
│              Provider Layer                  │
│  (Riverpod providers, StateNotifiers)        │
│  core/providers/ + features/*/providers/     │
├─────────────────────────────────────────────┤
│              Model Layer                     │
│  (Typed data classes: fromJson/toJson)       │
│  core/models/                                │
├─────────────────────────────────────────────┤
│             Service Layer                    │
│  (AuthService, SupabaseClient)               │
│  core/services/ + features/*/services/       │
├─────────────────────────────────────────────┤
│              Data Layer                      │
│  (Supabase PostgreSQL + RLS + RPC)           │
│  supabase/migrations/                        │
└─────────────────────────────────────────────┘
```

### Pola Navigasi (GoRouter)
Setiap modul (siswa, kantin, keuangan, admin) menggunakan **ShellRoute** untuk bottom navigation dan **GoRoute** terpisah untuk sub-pages:
```
ShellRoute(MainLayout)
  ├── /module/home        → DashboardScreen
  ├── /module/tab2        → Tab2Screen
  └── /module/tab3        → Tab3Screen

GoRoute (outside shell)
  ├── /module/detail/:id  → DetailScreen
  └── /module/form        → FormScreen
```

---

## 🗺️ 3. Struktur Alur Layar (Sitemap)

### Modul Siswa
```
[Login/Splash] → [Welcome] → [Dashboard (Beranda)]
                              ├── [Isi Saldo]
                              ├── [Riwayat Jajan]
                              ├── [Kartu RFID]
                              ├── [Profil]
                              └── [Notifikasi]
```

### Modul Kantin/POS
```
[Login] → [POS Home (Beranda)]
           ├── [Terminal POS] → [Keranjang] → [NFC Payment]
           ├── [Cek Kartu Siswa]
           ├── [Kelola Menu] → [Form Tambah/Edit]
           └── [Riwayat Penjualan] → [Refund]
```

### Modul Admin Keuangan
```
[Login] → [Keuangan Settings (paling kiri)]
          [Keuangan Home (Beranda)]
          ├── [Manajemen Siswa] → [Detail Siswa] → [Registrasi Kartu]
          ├── [Isi Saldo] (dengan prefilled student)
          ├── [Koreksi Saldo] (dengan prefilled student)
          ├── [Riwayat Transaksi]
          ├── [Laporan & Grafik]
          ├── [Manajemen User]
          └── [Profil]
```

### Modul Orang Tua
```
[Portal (Login NISN)] → [Dashboard Anak]
                        ├── [Isi Saldo]
                        └── [Struk Transaksi]
```

### Modul Super Admin
```
[Secure Entry (PIN)] → [Dashboard]
                       ├── [Manajemen Users] → [Detail Student/Merchant/Finance/Parent]
                       ├── [Audit Log]
                       └── [Settings]
```

---

## 🚀 4. Tahapan Pengembangan (Phases)

| Phase | Nama | Status |
|---|---|---|
| 1 | Database Setup & Supabase Migrations | ✅ Selesai |
| 2 | Core Setup & Visual Branding | ✅ Selesai |
| 3 | Autentikasi (Semua Role) | ✅ Selesai |
| 4 | Modul Siswa (Mobile) | ✅ Selesai |
| 5 | Modul Kantin/POS (Mobile) | ✅ Selesai |
| 6 | Modul Admin Keuangan (Mobile) | ✅ Selesai |
| 7 | Modul Orang Tua (Web/Mobile) | ✅ Selesai |
| 8 | Modul Super Admin (Mobile) | ✅ Selesai |
| 9 | Code Architecture (Models & Providers) | 🔄 Sedang Berjalan |
| 10 | Security Hardening & Production | ⏳ Belum Mulai |

### Detail Phase 9 (Sedang Berjalan): Code Architecture
*   ✅ 7 typed data models (`core/models/`)
*   ✅ Core providers (`app_providers.dart` + `shared_providers.dart`)
*   ✅ Keuangan providers (`keuangan_providers.dart`)
*   ⏳ Migrasi screens ke typed models
*   ⏳ Kantin/Siswa/Admin/Parent providers
*   ⏳ Repository/service layer

### Detail Phase 10 (Belum Mulai): Security & Production
*   ⚠️ Mengaktifkan kembali RLS
*   ⚠️ Password hashing (bcrypt/argon2)
*   ⏳ Input validation & sanitization
*   ⏳ Error boundary & crash reporting
*   ⏳ Environment configuration (dev/staging/prod)

---

## 📦 5. Dependensi Utama (pubspec.yaml)

| Package | Fungsi |
|---|---|
| `supabase_flutter` | Backend (Auth, Database, Storage, Realtime) |
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing & navigation |
| `google_fonts` | Typography (Be Vietnam Pro) |
| `intl` | Formatting (currency, date) |
| `connectivity_plus` | Network monitoring |
| `fl_chart` | Charts & graphs (laporan) |
| `nfc_manager` | NFC/RFID scanning (POS) |
