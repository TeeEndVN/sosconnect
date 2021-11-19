class User {
  final String userName;
  final DateTime dateCreate;
  final bool isAdmin;

  User(
      {required this.userName,
      required this.dateCreate,
      required this.isAdmin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['id_group'],
      dateCreate: json['date_created'],
      isAdmin: json['is_deleted'],
    );
  }
}
