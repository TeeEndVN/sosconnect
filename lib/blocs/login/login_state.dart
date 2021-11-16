import 'package:sosconnect/blocs/submission_status.dart';

class LoginState {
  final String userName;
  bool get isValidUserName => userName.length > 6;
  final String password;
  bool get isValidPassword => password.length > 6;
  final SubmissionStatus submissionStatus;

  LoginState(
      {this.userName = '',
      this.password = '',
      this.submissionStatus = const InitialStatus()});
  LoginState copyWith(
      {String? userName,
      String? password,
      SubmissionStatus? submissionStatus}) {
    return LoginState(
        userName: userName ?? this.userName,
        password: password ?? this.password,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
