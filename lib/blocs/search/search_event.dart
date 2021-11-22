import 'package:sosconnect/models/group.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged({required this.query});
}

class SearchGroupListReceived extends SearchEvent {
  final List<Group>? groups;
  SearchGroupListReceived({required this.groups});
}

class SearchGroupSelected extends SearchEvent {
  final Group selectedGroup;
  SearchGroupSelected({required this.selectedGroup});
}

class SearchSubmitted extends SearchEvent {}
