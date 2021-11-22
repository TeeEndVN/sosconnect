import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/group.dart';

class SearchState {
  final String query;
  final List<Group>? groups;
  final Group? selectedGroup;
  final SubmissionStatus submissionStatus;

  SearchState(
      {this.query = '',
      this.groups,
      this.selectedGroup,
      this.submissionStatus = const InitialStatus()});

  SearchState copyWith(
      {String? query,
      List<Group>? groups,
      Group? selectedGroup,
      SubmissionStatus? submissionStatus}) {
    return SearchState(
        query: query ?? this.query,
        groups: groups ?? this.groups,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
