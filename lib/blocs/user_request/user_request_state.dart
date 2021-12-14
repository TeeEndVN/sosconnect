import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/request.dart';

class UserRequestState {
  final List<Request>? requests;
  final String? currentUser;
  final Request? selectedRequest;
  final SubmissionStatus submissionStatus;

  UserRequestState(
      {this.requests,
      this.currentUser,
      this.selectedRequest,
      this.submissionStatus = const InitialStatus()});

  UserRequestState copyWith(
      {List<Request>? requests,
      String? currentUser,
      Request? selectedRequest,
      SubmissionStatus? submissionStatus}) {
    return UserRequestState(
        requests: requests ?? this.requests,
        currentUser: currentUser ?? this.currentUser,
        selectedRequest: selectedRequest ?? this.selectedRequest,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
