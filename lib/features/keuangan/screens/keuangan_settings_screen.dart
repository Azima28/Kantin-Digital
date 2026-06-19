import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantin_digital/features/auth/providers/auth_provider.dart';

class KeuanganSettingsScreen extends ConsumerStatefulWidget {
  const KeuanganSettingsScreen({super.key});

  @override
  ConsumerState<KeuanganSettingsScreen> createState() => _KeuanganSettingsScreenState();
}

class _KeuanganSettingsScreenState extends ConsumerState<KeuanganSettingsScreen> {
  static const Color primaryTeal = Color(0xFF003434);
  static const Color dangerRed = Color(0xFFBA1A1A);
  static const Color successGreen = Color(0xFF006A35);

  final _passwordController = TextEditingController();
  bool _isChangingPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('Ubah Kata Sandi'),
              content: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    const Text('Masukkan kata sandi baru untuk akun Anda.'),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Kata sandi baru',
                      obscureText: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.inactiveGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Batal'),
                  onPressed: () {
                    _passwordController.clear();
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: _isChangingPassword
                      ? null
                      : () async {
                          final password = _passwordController.text.trim();
                          if (password.isEmpty) return;

                          setDialogState(() {
                            _isChangingPassword = true;
                          });

                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(this.context);

                          try {
                            final client = ref.read(supabaseClientProvider);
                            final profile = ref.read(authNotifierProvider).profile;
                            final profileId = profile?['id'];

                            // 1. Update profiles table password field
                            await client.from('profiles').update({'password': password}).eq('id', profileId);

                            // 2. Try RPC password update if available locally
                            try {
                              await client.rpc('update_auth_user_password', params: {
                                'user_id': profileId,
                                'new_password': password,
                              });
                            } catch (_) {}

                            _passwordController.clear();
                            navigator.pop();
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Kata sandi berhasil diubah!'),
                                backgroundColor: successGreen,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Gagal mengubah kata sandi: $e'),
                                backgroundColor: dangerRed,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } finally {
                            setDialogState(() {
                              _isChangingPassword = false;
                            });
                          }
                        },
                  child: _isChangingPassword
                      ? const CupertinoActivityIndicator()
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleLogout() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) => CupertinoAlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun keuangan ini?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              final router = GoRouter.of(context);
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              router.go('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(authNotifierProvider).profile;
    final fullName = profile?['full_name'] ?? 'Admin Keuangan';
    final email = profile?['email'] ?? '-';
    final username = profile?['username'] ?? '-';
    final school = profile?['assigned_school'] ?? 'SMP Terpadu';
    final phone = profile?['phone'] ?? '-';
    final role = profile?['role'] ?? 'petugas_keuangan';

    // Map role code to human-readable label
    String roleLabel;
    switch (role) {
      case 'petugas_keuangan':
        roleLabel = 'Admin Keuangan';
        break;
      case 'tata_usaha':
        roleLabel = 'Tata Usaha';
        break;
      default:
        roleLabel = 'Admin Keuangan';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF9F8),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: primaryTeal, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Profile Header Bento Card ───
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryTeal,
                      const Color(0xFF004D4D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$roleLabel · $school',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ─── Detail Profil Card ───
              _buildSectionCard(
                title: 'Detail Profil',
                icon: CupertinoIcons.person_crop_circle,
                children: [
                  _buildInfoRow('Nama Lengkap', fullName),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('Email', email),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('Username', username),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('No. Telepon', phone),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('Sekolah', school),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('Role', roleLabel),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Keamanan Card ───
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16, right: 20, bottom: 8),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.lock_shield, color: primaryTeal, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Keamanan',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: const Color(0xFF1B1C1B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryTeal.withValues(alpha: 0.08),
                        child: const Icon(CupertinoIcons.lock_rotation, color: primaryTeal, size: 20),
                      ),
                      title: Text(
                        'Ubah Kata Sandi',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF1B1C1B),
                        ),
                      ),
                      subtitle: Text(
                        'Terakhir diubah: belum pernah',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: const Color(0xFF6F7978),
                        ),
                      ),
                      trailing: const Icon(CupertinoIcons.chevron_forward, size: 16, color: Color(0xFF6F7978)),
                      onTap: _showChangePasswordDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ─── Tentang Aplikasi Card ───
              _buildSectionCard(
                title: 'Tentang Aplikasi',
                icon: CupertinoIcons.info_circle,
                children: [
                  _buildInfoRow('Versi', '1.0.0'),
                  const Divider(height: 16, thickness: 0.5, color: Color(0xFFE4E2E1)),
                  _buildInfoRow('Platform', 'Kantin Digital'),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Logout Button ───
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(CupertinoIcons.square_arrow_right, size: 20),
                  label: Text(
                    'Keluar dari Akun',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryTeal, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: const Color(0xFF1B1C1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(color: const Color(0xFF6F7978), fontSize: 13),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B1C1B),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
