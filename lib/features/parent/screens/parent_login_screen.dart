import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantin_digital/core/constants/app_colors.dart';
import 'package:kantin_digital/features/auth/providers/auth_provider.dart';

class ParentLoginScreen extends ConsumerStatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  ConsumerState<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends ConsumerState<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final bool success = await ref.read(authNotifierProvider.notifier).login(
          email,
          password,
          role: 'parent',
        );

    if (success) {
      if (mounted) {
        final profile = ref.read(authNotifierProvider).profile;
        final String studentId = profile?['student_id'] ?? '';
        if (studentId.isNotEmpty) {
          context.go('/parent/dashboard/$studentId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun orang tua tidak memiliki data anak yang tertaut.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        final String? error = ref.read(authNotifierProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Email atau kata sandi salah.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => context.go('/student/welcome'),
          child: Row(
            children: const [
              SizedBox(width: 8),
              Icon(CupertinoIcons.left_chevron, color: AppColors.primary, size: 20),
              SizedBox(width: 4),
              Text(
                'Kembali',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Portal Orang Tua',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masuk menggunakan email dan kata sandi orang tua untuk memantau anak.',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Email Field
                        Text(
                          'Email Orang Tua',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'orangtua@sekolah.sch.id',
                            hintStyle: TextStyle(color: Color(0xFFBDC9C8)),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFBDC9C8)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Password Field
                        Text(
                          'Kata Sandi',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Masukkan kata sandi',
                            hintStyle: const TextStyle(color: Color(0xFFBDC9C8)),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFBDC9C8)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                                color: const Color(0xFFBDC9C8),
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 60),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: authState.isLoading
                                ? const CupertinoActivityIndicator(color: Colors.white)
                                : const Text(
                                    'MASUK PORTAL ORANG TUA',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Preview overlay helper (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'PREVIEW ORANG TUA',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'orangtua@sekolah.sch.id',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Text(
                      'Sandi: parent123',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _emailController.text = 'orangtua@sekolah.sch.id';
                          _passwordController.text = 'parent123';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kredensial Orang Tua diisi!'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Gunakan Kredensial',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              CupertinoIcons.square_pencil,
                              size: 8,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
