import 'package:sosconnect/blocs/submission_status.dart';

class RegisterState {
  final String userName;
  bool get isValidUserName => userName.length > 6;
  final String password;
  bool get isValidPassword => password.length > 6;
  final String confirmPassword;
  bool get isValidConfirmPassword =>
      confirmPassword.length > 6 || password == confirmPassword;
  final SubmissionStatus submissionStatus;

  RegisterState(
      {this.userName = '',
      this.password = '',
      this.confirmPassword = '',
      this.submissionStatus = const InitialStatus()});

  RegisterState copyWith(
      {String? userName,
      String? password,
      String? confirmPassword,
      SubmissionStatus? submissionStatus}) {
    return RegisterState(
        userName: userName ?? this.userName,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
