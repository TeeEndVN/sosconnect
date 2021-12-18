import 'package:sosconnect/models/profile.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class AuthenticatedWithoutProfile extends SessionState {}

class Authenticated extends SessionState {
  Profile profile;
  Profile? selectedProfile;
  Authenticated({required this.profile});
}
