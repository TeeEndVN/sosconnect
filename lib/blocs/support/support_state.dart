import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/models/support.dart';
import 'package:sosconnect/models/group.dart';

class SupportState {
  final Request? request;
  final List<Support>? supports;
  final Support? selectedSupport;
  final SubmissionStatus submissionStatus;

  SupportState(
      {required this.request,
      this.supports,
      this.selectedSupport,
      this.submissionStatus = const InitialStatus()});

  SupportState copyWith(
      {Request? request,
      List<Support>? supports,
      Support? selectedSupport,
      SubmissionStatus? submissionStatus}) {
    return SupportState(
        request: request ?? this.request,
        supports: supports ?? this.supports,
        selectedSupport: selectedSupport ?? this.selectedSupport,

        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
