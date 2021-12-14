import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/request.dart';

class GroupState {
  final Group? group;
  final bool? role;
  final String? currentUser;
  final List<Request>? requests;
  final Request? selectedRequest;
  final SubmissionStatus submissionStatus;

  GroupState(
      {required this.group,
      this.role,
      this.currentUser,
      this.requests,
      this.selectedRequest,
      this.submissionStatus = const InitialStatus()});

  GroupState copyWith(
      {Group? group,
      bool? role,
      String? currentUser,
      List<Request>? requests,
      Request? selectedRequest,
      SubmissionStatus? submissionStatus}) {
    return GroupState(
        group: group ?? this.group,
        role: role ?? this.role,
        currentUser: currentUser ?? this.currentUser,
        requests: requests ?? this.requests,
        selectedRequest: selectedRequest ?? this.selectedRequest,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
