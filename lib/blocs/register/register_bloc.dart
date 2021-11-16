import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/auth/auth_cubit.dart';
import 'package:sosconnect/blocs/register/register_event.dart';
import 'package:sosconnect/blocs/register/register_state.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/utils/repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Repository repository;
  final AuthCubit authCubit;
  RegisterBloc({required this.repository, required this.authCubit})
      : super(RegisterState());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterUserNameChanged) {
      yield state.copyWith(userName: event.userName);
    } else if (event is RegisterPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is RegisterConfirmPasswordChanged) {
      yield state.copyWith(confirmPassword: event.confirmPassword);
    } else if (event is RegisterSubmitted) {
      yield state.copyWith(submissionStatus: Submitting());

      try {
        await repository.register(
            state.userName, state.password, state.confirmPassword);
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    }
  }
}
