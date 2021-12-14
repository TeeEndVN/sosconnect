import 'package:sosconnect/models/request.dart';

abstract class UserRequestEvent {}

class UserRequestInitialized extends UserRequestEvent {}

class UserRequestListReceived extends UserRequestEvent {
  final List<Request>? requests;
  UserRequestListReceived({required this.requests});
}

class UserRequestSelected extends UserRequestEvent {
  final Request selectedRequest;
  UserRequestSelected({required this.selectedRequest});
}

class UserRequestSubmitted extends UserRequestEvent {
  final String content;
  UserRequestSubmitted({required this.content});
}

class UserPostUpdated extends UserRequestEvent {
  final int requestId;
  final String content;
  UserPostUpdated({required this.requestId, required this.content});
}

class UserPostDeleted extends UserRequestEvent{}
