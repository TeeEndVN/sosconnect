import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/member.dart';
import 'package:sosconnect/models/group.dart';

class GroupUserState {
  final Group? group;
  final List<Member>? members;
  final String? query;
  final Member? selectedMember;
  final SubmissionStatus submissionStatus;

  GroupUserState(
      {required this.group,
      this.members,
      this.query,
      this.selectedMember,
      this.submissionStatus = const InitialStatus()});

  GroupUserState copyWith(
      {Group? group,
      List<Member>? members,
      String? query,
      Member? selectedMember,
      SubmissionStatus? submissionStatus}) {
    return GroupUserState(
        group: group ?? this.group,
        members: members ?? this.members,
        query: query ?? this.query,
        selectedMember: selectedMember ?? this.selectedMember,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
