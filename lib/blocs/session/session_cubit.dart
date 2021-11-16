import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/session/session_state.dart';
import 'package:sosconnect/utils/repository.dart';

class SessionCubit extends Cubit<SessionState> {
  final Repository repository;

  SessionCubit(this.repository) : super(UnknownSessionState());
  void showAuth() => emit(Unauthenticated());
  void showSession() => emit(Authenticated());
  void signOut() {
    //repository.logout();
    emit(Unauthenticated());
  }
}
