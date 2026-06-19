import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kantin_digital/core/models/models.dart';
import 'package:kantin_digital/features/auth/providers/auth_provider.dart';

// ============================================================================
// DASHBOARD PROVIDER (Keuangan)
// ============================================================================

/// Fetch data dashboard keuangan (officer-specific).
/// Digunakan di: keuangan_dashboard_screen.dart
final keuanganDashboardProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final client = ref.read(supabaseClientProvider);
      final profile = ref.read(authNotifierProvider).profile;
      final officerId = profile?['id'];
      final school = profile?['assigned_school'] ?? '';

      // Guard: if officer ID is not available, return empty data
      if (officerId == null || officerId.toString().isEmpty) {
        return {
          'profile': profile,
          'school': school,
          'totalSaldo': 0.0,
          'topupToday': 0.0,
          'topupCount': 0,
          'koreksCount': 0,
          'koreksNet': 0.0,
          'recentLogs': <Map<String, dynamic>>[],
        };
      }

      // Recent audit logs by this officer
      final List<dynamic> logs = await client
          .from('audit_logs')
          .select('actor_name, action_type, description, created_at')
          .eq('actor_id', officerId)
          .order('created_at', ascending: false)
          .limit(5);

      return {
        'profile': profile,
        'school': school,
        'totalSaldo':
            14520000.0, // mock - in real: SUM(students.balance) by school
        'topupToday': 1250000.0,
        'topupCount': 18,
        'koreksCount': 3,
        'koreksNet': -35000.0,
        'recentLogs': List<Map<String, dynamic>>.from(logs),
      };
    });

// ============================================================================
// HISTORY PROVIDER (Keuangan)
// ============================================================================

/// Fetch riwayat audit logs milik officer keuangan.
/// Digunakan di: keuangan_history_screen.dart
final keuanganHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final client = ref.read(supabaseClientProvider);
      final profile = ref.read(authNotifierProvider).profile;
      final actorId = profile?['id'];

      // Guard: if actor ID is not available, return empty list
      if (actorId == null || actorId.toString().isEmpty) {
        return <Map<String, dynamic>>[];
      }

      final List<dynamic> res = await client
          .from('audit_logs')
          .select(
            'id, action_type, description, created_at, old_value, new_value, target_id',
          )
          .eq('actor_id', actorId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    });

// ============================================================================
// REPORT PROVIDER (Keuangan)
// ============================================================================

/// Fetch data laporan keuangan (canteen operators, transaksi, koreksi).
/// Digunakan di: keuangan_report_screen.dart
final keuanganReportProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async {
    final client = ref.read(supabaseClientProvider);

    // Fetch canteen operators and their earned balance
    final List<dynamic> canteens = await client
        .from('canteen_operators')
        .select('canteen_name, balance_earned');

    // Fetch all transactions to compile totals
    final List<dynamic> txs = await client
        .from('transactions')
        .select('total_amount, type, status, created_at');

    double totalTopup = 0.0;
    double totalPurchase = 0.0;
    int topupCount = 0;
    int purchaseCount = 0;

    for (var tx in txs) {
      if (tx['status'] != 'success') continue;
      final amt = double.tryParse(tx['total_amount']?.toString() ?? '0') ?? 0.0;
      if (tx['type'] == 'topup') {
        totalTopup += amt;
        topupCount++;
      } else if (tx['type'] == 'purchase') {
        totalPurchase += amt;
        purchaseCount++;
      }
    }

    // Fetch audit logs to compile corrections
    final List<dynamic> logs = await client
        .from('audit_logs')
        .select('old_value, new_value')
        .eq('action_type', 'KOREKSI_SALDO');

    double totalCorrection = 0.0;
    for (var log in logs) {
      final oldVal = log['old_value'] as Map<String, dynamic>? ?? {};
      final newVal = log['new_value'] as Map<String, dynamic>? ?? {};
      final double oldBal =
          double.tryParse(oldVal['balance']?.toString() ?? '0') ?? 0.0;
      final double newBal =
          double.tryParse(newVal['balance']?.toString() ?? '0') ?? 0.0;
      totalCorrection += (newBal - oldBal);
    }

    return {
      'canteens': List<Map<String, dynamic>>.from(canteens),
      'totalTopup': totalTopup,
      'totalPurchase': totalPurchase,
      'totalCorrection': totalCorrection,
      'topupCount': topupCount,
      'purchaseCount': purchaseCount,
    };
  },
);

// ============================================================================
// STUDENTS PROVIDER (Keuangan)
// ============================================================================

/// Fetch semua siswa dengan data profile + student (join).
/// Digunakan di: keuangan_students_screen.dart
final keuanganStudentsProvider =
    FutureProvider.autoDispose<List<StudentWithProfile>>((ref) async {
      final client = ref.read(supabaseClientProvider);

      // Fetch profiles that are students and join student details
      final List<dynamic> res = await client
          .from('profiles')
          .select(
            'id, full_name, email, nisn, is_active, students:students!students_id_fkey(class, balance, rfid_uid)',
          )
          .eq('role', 'student')
          .order('full_name', ascending: true);

      return res
          .map(
            (e) => StudentWithProfile.fromJoinedJson(e as Map<String, dynamic>),
          )
          .toList();
    });

// ============================================================================
// STUDENT DETAIL PROVIDER
// ============================================================================

/// Fetch detail siswa lengkap dengan riwayat transaksi.
/// Digunakan di: keuangan_student_detail_screen.dart
final keuanganStudentDetailProvider = FutureProvider.autoDispose
    .family<AdminStudentDetail, String>((ref, id) async {
      final client = ref.read(supabaseClientProvider);

      // 1. Fetch profile
      final profile = await client
          .from('profiles')
          .select()
          .eq('id', id)
          .single();

      // 2. Fetch student
      final student = await client
          .from('students')
          .select()
          .eq('id', id)
          .single();

      // 3. Fetch recent transactions
      final List<dynamic> txs = await client
          .from('transactions')
          .select(
            'id, total_amount, type, status, created_at, canteen_operators(canteen_name)',
          )
          .eq('student_id', id)
          .order('created_at', ascending: false)
          .limit(10);

      return AdminStudentDetail.fromJson({
        'profile': profile,
        'student': student,
        'transactions': txs,
      });
    });

// ============================================================================
// USERS PROVIDERS (Keuangan)
// ============================================================================

/// Fetch semua parent/ortu dengan data children.
/// Digunakan di: keuangan_users_screen.dart
final keuanganParentsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final client = ref.read(supabaseClientProvider);
      final List<dynamic> res = await client
          .from('profiles')
          .select(
            'id, full_name, email, phone_number, is_active, created_at, parent_students!parent_id(students(id, class, profiles(full_name, nisn)))',
          )
          .eq('role', 'parent')
          .order('full_name', ascending: true);
      return List<Map<String, dynamic>>.from(res);
    });

/// Fetch semua petugas kantin dengan data operator.
/// Digunakan di: keuangan_users_screen.dart
final keuanganStaffProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final client = ref.read(supabaseClientProvider);
      final List<dynamic> res = await client
          .from('profiles')
          .select(
            'id, full_name, username, phone_number, is_active, last_sign_in_at, canteen_operators(canteen_name, balance_earned, transaction_count)',
          )
          .eq('role', 'petugas_kantin')
          .order('full_name', ascending: true);
      return List<Map<String, dynamic>>.from(res);
    });
