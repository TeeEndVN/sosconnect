class Request {
  final int requestId;
  final int groupId;
  final String userName;
  final String content;
  final bool isDelete;
  final String dateCreate;
  final bool isApprove;

  Request({
    required this.requestId,
    required this.groupId,
    required this.userName,
    required this.content,
    required this.isDelete,
    required this.dateCreate,
    required this.isApprove,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      requestId: json['id_request'],
      groupId: json['id_group'],
      userName: json['username'],
      content: json['content'],
      isDelete: json['is_deleted'],
      dateCreate: json['date_created'],
      isApprove: json['is_approved'],
    );
  }
}
