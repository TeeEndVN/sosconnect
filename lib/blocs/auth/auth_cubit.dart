import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';

enum AuthState { login, register, profile }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;
  AuthCubit(this.sessionCubit) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showRegister() => emit(AuthState.register);
  void showCreateProfile() => emit(AuthState.profile);
  void launchSession() => sessionCubit.showSession();
}
