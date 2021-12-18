import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/models/request.dart';

class MemberProfileState {
  final String userName;
  final Profile? profile;
  final List<Request>? requests;
  final SubmissionStatus submissionStatus;

  MemberProfileState(
      {required this.userName,
      this.profile,
      this.requests,
      this.submissionStatus = const InitialStatus()});

  MemberProfileState copyWith(
      {Profile? profile,
      List<Request>? requests,
      SubmissionStatus? submissionStatus}) {
    return MemberProfileState(
        userName: userName,
        profile: profile ?? this.profile,
        requests: requests ?? this.requests,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
