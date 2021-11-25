import 'package:sosconnect/models/request.dart';

abstract class GroupEvent {}

class GroupInitialized extends GroupEvent{
  
}
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

class GroupJoinSubmitted extends GroupEvent {}
