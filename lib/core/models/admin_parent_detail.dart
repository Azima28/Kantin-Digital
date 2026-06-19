import 'package:kantin_digital/core/models/user_profile.dart';

/// Model gabungan untuk detail orang tua di panel admin.
///
/// Berisi profile parent dan data anak-anak yang terhubung.
class AdminParentDetail {
  final UserProfile profile;
  final List<Map<String, dynamic>> children;

  const AdminParentDetail({
    required this.profile,
    this.children = const [],
  });

  /// Parse dari query admin_parent_detail_provider.
  factory AdminParentDetail.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'];
    final childrenData = json['children'] as List<dynamic>? ?? [];

    return AdminParentDetail(
      profile: profileData is Map<String, dynamic>
          ? UserProfile.fromJson(profileData)
          : const UserProfile(id: ''),
      children: childrenData.cast<Map<String, dynamic>>(),
    );
  }

  int get childCount => children.length;

  @override
  String toString() =>
      'AdminParentDetail(name: ${profile.fullName}, children: $childCount)';
}
