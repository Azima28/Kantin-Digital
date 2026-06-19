import 'package:kantin_digital/core/models/user_profile.dart';
import 'package:kantin_digital/core/models/student.dart';
import 'package:kantin_digital/core/models/operator_transaction.dart';

/// Model gabungan untuk detail siswa di panel admin super admin.
///
/// Berisi profile, data student, dan transaksi terbaru siswa.
class AdminStudentDetail {
  final UserProfile profile;
  final Student student;
  final List<OperatorTransaction> recentTransactions;

  const AdminStudentDetail({
    required this.profile,
    required this.student,
    this.recentTransactions = const [],
  });

  /// Parse dari query admin_student_detail_provider.
  factory AdminStudentDetail.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'];
    final studentData = json['student'];
    final txsData = json['transactions'] as List<dynamic>? ?? [];

    return AdminStudentDetail(
      profile: profileData is Map<String, dynamic>
          ? UserProfile.fromJson(profileData)
          : const UserProfile(id: ''),
      student: studentData is Map<String, dynamic>
          ? Student.fromJson(studentData)
          : const Student(id: ''),
      recentTransactions: txsData
          .map((e) => OperatorTransaction.fromSiswaJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'AdminStudentDetail(name: ${profile.fullName}, balance: ${student.balance})';
}
