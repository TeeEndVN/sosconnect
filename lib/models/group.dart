class Group {
  final int groupId;
  final String description;
  final String name;
  final bool isDelete;
  final String dateCreate;

  Group(
      {required this.groupId,
      required this.description,
      required this.name,
      required this.isDelete,
      required this.dateCreate});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['id_group'],
      description: json['description'],
      name: json['name'],
      isDelete: json['is_deleted'],
      dateCreate: json['date_created'],
    );
  }
}
