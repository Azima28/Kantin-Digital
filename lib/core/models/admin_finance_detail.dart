import 'package:kantin_digital/core/models/user_profile.dart';
import 'package:kantin_digital/core/models/audit_log.dart';

/// Model gabungan untuk detail finance officer di panel admin.
///
/// Berisi profile, data finance officer, dan aktivitas audit terbaru.
class AdminFinanceDetail {
  final UserProfile profile;
  final Map<String, dynamic> officer;
  final List<AuditLog> recentLogs;

  const AdminFinanceDetail({
    required this.profile,
    this.officer = const {},
    this.recentLogs = const [],
  });

  /// Parse dari query admin_finance_detail_provider.
  factory AdminFinanceDetail.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'];
    final officerData = json['officer'];
    final logsData = json['logs'] as List<dynamic>? ?? [];

    return AdminFinanceDetail(
      profile: profileData is Map<String, dynamic>
          ? UserProfile.fromJson(profileData)
          : const UserProfile(id: ''),
      officer: officerData is Map<String, dynamic> ? officerData : const {},
      recentLogs: logsData
          .map((e) => AuditLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int get logCount => recentLogs.length;

  @override
  String toString() =>
      'AdminFinanceDetail(name: ${profile.fullName}, logs: $logCount)';
}
