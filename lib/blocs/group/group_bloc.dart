import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/group/group_event.dart';
import 'package:sosconnect/blocs/group/group_state.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/member.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';
import 'package:collection/collection.dart';

import '../submission_status.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final Repository repository;
  GroupBloc({required Group? group, required this.repository})
      : super(GroupState(group: group)) {
    add(GroupInitialized());
  }

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    if (event is GroupInitialized) {
      bool? role = await getRole();
      add(GroupRoleChanged(role: role));
    } else if (event is GroupRoleChanged) {
      yield state.copyWith(role: event.role);
      if (state.role == false) {
        var userName = await UserSecureStorage.readUserName();
        List<Request>? requests = await repository.groupRequests(
            state.group!.groupId, userName, '', '');
        add(GroupRequestListReceived(requests: requests));
      } else if (state.role == true) {
        List<Request>? requests =
            await repository.groupRequests(state.group!.groupId, '', '', '');
        add(GroupRequestListReceived(requests: requests));
      } else if (state.role == null) {
        add(GroupRequestListReceived(requests: null));
      }
    } else if (event is GroupRequestListReceived) {
      yield state.copyWith(requests: event.requests);
    } else if (event is GroupRequestSelected) {
      yield state.copyWith(selectedRequest: event.selectedRequest);
    } else if (event is GroupJoinSubmitted) {
      try {
        await repository.joinGroup(state.group!.groupId, state.role!, false);
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    }
  }

  Future<bool?> getRole() async {
    var userName = await UserSecureStorage.readUserName();
    List<Member> members =
        await repository.groupMembers(state.group!.groupId, userName, '', '');
    Member? findMember(String? userName) =>
        members.firstWhereOrNull((member) => member.userName == userName);
    if (findMember(userName) == null) {
      return null;
    } else {
      return findMember(userName)!.role;
    }
  }
}
