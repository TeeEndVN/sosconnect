import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/group/group_user_event.dart';
import 'package:sosconnect/blocs/group/group_user_state.dart';

import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/member.dart';
import 'package:sosconnect/utils/repository.dart';

class GroupUserBloc extends Bloc<GroupUserEvent, GroupUserState> {
  final Repository repository;
  final Group? group;
  GroupUserBloc({required this.repository, required this.group})
      : super(GroupUserState(group: group)) {
    add(GroupUserInitialized());
  }

  @override
  Stream<GroupUserState> mapEventToState(GroupUserEvent event) async* {
    if (event is GroupUserInitialized) {
      yield state.copyWith(submissionStatus: Submitting());
      try {
        List<Member>? members =
            await repository.groupMembers(state.group!.groupId, '', '', '');
        add(GroupUserListReceived(members: members));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is GroupUserListReceived) {
      yield state.copyWith(members: event.members);
    } else if (event is GroupUserSelected) {
      yield state.copyWith(selectedMember: event.selectedMember);
    } else if (event is GroupUserQueryChanged) {
      yield state.copyWith(query: event.query);
    } else if (event is GroupUserSearchSubmitted) {
      yield state.copyWith(submissionStatus: Submitting());
      try {
        List<Member>? members = await repository.groupMembers(
            state.group!.groupId, state.query, '', '');
        add(GroupUserListReceived(members: members));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    }
  }
}
