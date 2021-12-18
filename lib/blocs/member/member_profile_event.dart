import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/models/request.dart';

abstract class MemberProfileEvent {}

class MemberProfileInitialized extends MemberProfileEvent {}

class MemberRequestListReceived extends MemberProfileEvent {
  final List<Request>? requests;
  MemberRequestListReceived({required this.requests});
}

class MemberProfileReceived extends MemberProfileEvent {
  final Profile? profile;
  MemberProfileReceived({required this.profile});
}
