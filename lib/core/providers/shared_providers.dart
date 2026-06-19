import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kantin_digital/core/models/models.dart';

// ============================================================================
// SUPABASE CLIENT
// ============================================================================

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// TRANSACTION TYPES - Cached, shared across all features
// ============================================================================

/// Cache transaksi types agar tidak berulang kali query.
/// Digunakan di banyak screen (top-up, adjustment, dll).
final transactionTypesProvider =
    FutureProvider.autoDispose<List<TransactionType>>((ref) async {
  final client = ref.read(supabaseClientProvider);
  final List<dynamic> data = await client
      .from('transaction_types')
      .select('*')
      .order('name', ascending: true);
  return data
      .map((e) => TransactionType.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Map transaction type id -> TransactionType untuk lookup cepat.
final transactionTypeMapProvider =
    FutureProvider.autoDispose<Map<String, TransactionType>>((ref) async {
  final types = await ref.watch(transactionTypesProvider.future);
  return {for (var t in types) t.id: t};
});

// ============================================================================
// CURRENT USER PROFILE
// ============================================================================

/// Fetch profile user yang sedang login.
final currentUserProfileProvider =
    FutureProvider.autoDispose<UserProfile?>((ref) async {
  final client = ref.read(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return null;

  final data = await client
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .maybeSingle();

  if (data == null) return null;
  return UserProfile.fromJson(data);
});

// ============================================================================
// STUDENT LOOKUP PROVIDERS
// ============================================================================

/// Fetch single student by ID (dengan profile join).
final studentByIdProvider =
    FutureProvider.autoDispose.family<StudentWithProfile?, String>(
        (ref, id) async {
  final client = ref.read(supabaseClientProvider);
  final data = await client
      .from('profiles')
      .select(
          'id, full_name, email, nisn, is_active, students:students!students_id_fkey(class, balance, rfid_uid)')
      .eq('id', id)
      .maybeSingle();

  if (data == null) return null;
  return StudentWithProfile.fromJoinedJson(data);
});

// ============================================================================
// RFID PROVIDERS
// ============================================================================

/// Fetch semua RFID cards.
final rfidCardsProvider =
    FutureProvider.autoDispose<List<RfidCard>>((ref) async {
  final client = ref.read(supabaseClientProvider);
  final List<dynamic> data =
      await client.from('rfid_cards').select('*').order('created_at');
  return data
      .map((e) => RfidCard.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Cek apakah RFID UID sudah terdaftar.
final rfidByUidProvider =
    FutureProvider.autoDispose.family<RfidCard?, String>((ref, uid) async {
  final client = ref.read(supabaseClientProvider);
  final data = await client
      .from('rfid_cards')
      .select('*')
      .eq('uid', uid)
      .maybeSingle();
  if (data == null) return null;
  return RfidCard.fromJson(data);
});
