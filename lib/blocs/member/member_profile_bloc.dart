import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/member/member_profile_event.dart';
import 'package:sosconnect/blocs/member/member_profile_state.dart';
import 'package:sosconnect/blocs/search/search_event.dart';
import 'package:sosconnect/blocs/search/search_state.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/utils/repository.dart';

class MemberProfileBloc extends Bloc<MemberProfileEvent, MemberProfileState> {
  final Repository repository;
  final String userName;
  MemberProfileBloc({required this.repository, required this.userName})
      : super(MemberProfileState(userName: userName)) {
    add(MemberProfileInitialized());
  }

  @override
  Stream<MemberProfileState> mapEventToState(MemberProfileEvent event) async* {
    if (event is MemberProfileInitialized) {
      yield state.copyWith(submissionStatus: Submitting());

      try {
        Profile? profile = await repository.profile(state.userName);
        add(MemberProfileReceived(profile: profile));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is MemberProfileReceived) {
      yield state.copyWith(profile: event.profile);
    }
  }
}
