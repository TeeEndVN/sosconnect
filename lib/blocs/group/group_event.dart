import 'package:sosconnect/models/request.dart';

abstract class GroupEvent {}

class GroupInitialized extends GroupEvent {}

class GroupRoleChanged extends GroupEvent {
  final bool? role;
  GroupRoleChanged({required this.role});
}

class GroupRequestListReceived extends GroupEvent {
  final List<Request>? requests;
  GroupRequestListReceived({required this.requests});
}

class GroupRequestSelected extends GroupEvent {
  final Request selectedRequest;
  GroupRequestSelected({required this.selectedRequest});
}

class GroupPostSubmitted extends GroupEvent {
  final int groupId;
  final String content;
  GroupPostSubmitted({required this.groupId, required this.content});
}

class GroupPostUpdated extends GroupEvent {
  final int requestId;
  final String content;
  GroupPostUpdated({required this.requestId, required this.content});
}

class GroupJoinSubmitted extends GroupEvent {}

class GroupPostDeleted extends GroupEvent{}
