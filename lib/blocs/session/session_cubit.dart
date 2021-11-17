import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/blocs/session/session_state.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

class SessionCubit extends Cubit<SessionState> {
  final Repository repository;

  SessionCubit(this.repository) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }
  void attemptAutoLogin() async {
    String accessToken;
    var token = await UserSecureStorage.readAccessToken();
    if (token == null) {
      emit(Unauthenticated());
    } else {
      accessToken = token;
      if (JwtDecoder.isExpired(accessToken)) {
        try {
          repository.refresh();
        } on Exception {
          emit(Unauthenticated());
        }
      } else {
        var userName = await UserSecureStorage.readUserName();
        emit(Authenticated(userName: userName));
      }
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession() async {
    var userName = await UserSecureStorage.readUserName();
    emit(Authenticated(userName: userName));
  }

  void signOut() {
    repository.logout();
    emit(Unauthenticated());
  }
}
