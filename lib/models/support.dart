class Support {
  final int supportId;
  final int requestId;
  final String username;
  final String content;
  final bool isConfirm;
  final DateTime dateCreate;

  Support(
      {required this.supportId,
      required this.requestId,
      required this.username,
      required this.content,
      required this.isConfirm,
      required this.dateCreate});

   factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      supportId: json['id_support'],
      requestId: json['id_request'],
      username: json['username'],
      content: json['content'],
      isConfirm: json['is_confirmed'],
      dateCreate: json['date_created'],
    );
  }   
}
