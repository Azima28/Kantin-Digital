import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;
  Map<String, dynamic>? _currentProfile;

  AuthService(this._client);

  // Sign In using email and password queried directly from profiles table
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    String expectedRole = '',
  }) async {
    try {
      final String rawInput = email.trim();
      String queryEmail = rawInput.toLowerCase();
      
      // Validation for parent expected role: must be a numeric NISN
      if (expectedRole == 'parent') {
        final isNumeric = RegExp(r'^\d+$').hasMatch(rawInput);
        if (!isNumeric) {
          throw Exception('Akses ditolak: Orang Tua hanya dapat masuk menggunakan NISN Anak (angka).');
        }
      }

      // If it looks like a NIS (numeric or doesn't have @), append domain suffix
      if (!queryEmail.contains('@')) {
        queryEmail = '$queryEmail@sekolah.sch.id';
      }

      // Mock Parent Account
      if ((queryEmail == '20260012@sekolah.sch.id' || queryEmail == 'orangtua@sekolah.sch.id') && password == 'parent123') {
        if (expectedRole != 'parent') {
          throw Exception('Akses ditolak: Silakan gunakan tab login Orang Tua.');
        }
        final parentProfile = {
          'id': 'parent-id-wali-ahmad',
          'email': 'orangtua@sekolah.sch.id',
          'full_name': 'Budi Subarjo (Wali Ahmad)',
          'role': 'parent',
          'student_id': '03525ad9-d9e3-4f55-8ee6-7ff5b06d2025'
        };
        _currentProfile = parentProfile;
        return parentProfile;
      }

      Map<String, dynamic>? profile;
      try {
        // Query profiles: try matching email, username, or nisn
        profile = await _client
            .from('profiles')
            .select()
            .or('email.eq.$queryEmail,username.eq.$rawInput,nisn.eq.$rawInput')
            .eq('password', password)
            .maybeSingle();
      } catch (e) {
        // Graceful fallback if username or nisn columns don't exist yet
        profile = await _client
            .from('profiles')
            .select()
            .eq('email', queryEmail)
            .eq('password', password)
            .maybeSingle();
      }

      if (profile == null) {
        throw Exception('Email/Username/NISN atau kata sandi salah.');
      }

      final String role = profile['role'] ?? '';
      
      // Prevent parent login on general siswa/staff tab
      if (role == 'parent' && expectedRole != 'parent') {
        throw Exception('Akses ditolak: Silakan gunakan pilihan login Orang Tua.');
      }

      // Authorization check: must match expected role if provided
      if (expectedRole.isNotEmpty && role != expectedRole) {
        if (expectedRole == 'petugas_kantin') {
          throw Exception('Akses ditolak: Hanya petugas/operator kantin yang dapat masuk ke Kasir.');
        } else if (expectedRole == 'student') {
          throw Exception('Akses ditolak: Akun ini bukan akun siswa.');
        } else {
          throw Exception('Akses ditolak: Hak akses tidak sesuai.');
        }
      }

      _currentProfile = profile;
      return profile;
    } on PostgrestException catch (e) {
      // Menangkap error jika kolom password tidak ditemukan di database
      if (e.code == '42703' || e.message.contains('password')) {
        throw Exception(
          'Konfigurasi database belum lengkap. Kolom "password" belum ditambahkan ke tabel "profiles". '
          'Silakan jalankan query migrasi SQL yang saya berikan di Supabase.',
        );
      }
      throw Exception('Gagal menghubungi database (${e.code}): ${e.message}');
    } catch (e) {
      final String errString = e.toString();
      // Menangkap error koneksi internet
      if (errString.contains('SocketException') || errString.contains('Failed host lookup')) {
        throw Exception(
          'Gagal menghubungkan ke server. Periksa koneksi internet Anda atau pastikan URL Supabase sudah benar.',
        );
      }
      // Meneruskan exception jika sudah berupa custom Exception
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  // Sign Out current session
  Future<void> signOut() async {
    _currentProfile = null;
  }

  // Check if session is active
  Session? get currentSession => null;

  // Get current authenticated user profile
  Future<Map<String, dynamic>?> getCurrentProfile() async {
    return _currentProfile;
  }
}
