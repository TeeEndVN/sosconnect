class Member {
  final String userName;
  final int groupId;
  final int role;
  final bool isAdminInvite;
  final DateTime dateCreate;

  Member({
    required this.userName,
    required this.groupId,
    required this.role,
    required this.isAdminInvite,
    required this.dateCreate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userName: json['user_name'],
      groupId: json['id_group'],
      role: json['as_role'],
      isAdminInvite: json['is_admin_invited'],
      dateCreate: json['date_created'],
    );
  }
}
