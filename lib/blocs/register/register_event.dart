abstract class RegisterEvent {}

class RegisterUserNameChanged extends RegisterEvent {
  final String userName;
  RegisterUserNameChanged({required this.userName});
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged({required this.password});
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  RegisterConfirmPasswordChanged({required this.confirmPassword});
}

class RegisterSubmitted extends RegisterEvent {}
