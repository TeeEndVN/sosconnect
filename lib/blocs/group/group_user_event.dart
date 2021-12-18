import 'package:sosconnect/models/member.dart';

abstract class GroupUserEvent {}

class GroupUserInitialized extends GroupUserEvent {}

class GroupUserListReceived extends GroupUserEvent {
  final List<Member>? members;
  GroupUserListReceived({required this.members});
}

class GroupUserQueryChanged extends GroupUserEvent {
  final String query;
  GroupUserQueryChanged({required this.query});
}

class GroupUserSelected extends GroupUserEvent {
  final Member selectedMember;
  GroupUserSelected({required this.selectedMember});
}

class GroupUserSearchSubmitted extends GroupUserEvent {}
