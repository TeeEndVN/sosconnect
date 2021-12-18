import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/blocs/session/session_state.dart';
import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

class SessionCubit extends Cubit<SessionState> {
  final Repository repository;

  Profile get currentProfile => (state as Authenticated).profile;
  Profile? get selectedProfile => (state as Authenticated).selectedProfile;
  set selectedProfile(Profile? profile) {
    (state as Authenticated).selectedProfile = profile;
  }

  bool get isCurrentProfileSelected =>
      selectedProfile == null ||
      selectedProfile!.userName == currentProfile.userName;

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
          var userName = await UserSecureStorage.readUserName();
          Profile? profile = await repository.profile(userName);
          if (profile == null) {
            emit(AuthenticatedWithoutProfile());
          } else {
            emit(Authenticated(profile: profile));
          }
        } on Exception {
          emit(Unauthenticated());
        }
      } else {
        var userName = await UserSecureStorage.readUserName();
        Profile? profile = await repository.profile(userName);
        if (profile == null) {
          emit(AuthenticatedWithoutProfile());
        } else {
          emit(Authenticated(profile: profile));
        }
      }
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession() async {
    var userName = await UserSecureStorage.readUserName();
    Profile? profile = await repository.profile(userName);
    if (profile == null) {
      emit(AuthenticatedWithoutProfile());
    } else {
      emit(Authenticated(profile: profile));
    }
  }

  void signOut() async {
    await repository.logout();
    emit(Unauthenticated());
  }
}
