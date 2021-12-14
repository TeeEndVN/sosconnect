import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/blocs/user_request/user_request_event.dart';
import 'package:sosconnect/blocs/user_request/user_request_state.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

class UserRequestBloc extends Bloc<UserRequestEvent, UserRequestState> {
  final Repository repository;
  UserRequestBloc({
    required this.repository,
  }) : super(UserRequestState()) {
    add(UserRequestInitialized());
  }

  @override
  Stream<UserRequestState> mapEventToState(UserRequestEvent event) async* {
    if (event is UserRequestInitialized) {
      var userName = await UserSecureStorage.readUserName();
      yield state.copyWith(currentUser: userName);
      yield state.copyWith(submissionStatus: Submitting());
      try {
        List<Request>? requests = await repository.memberRequests();
        add(UserRequestListReceived(requests: requests));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is UserRequestListReceived) {
      yield state.copyWith(requests: event.requests);
    } else if (event is UserRequestSelected) {
      yield state.copyWith(selectedRequest: event.selectedRequest);
    } else if (event is UserRequestSubmitted) {
      yield state.copyWith(submissionStatus: Submitting());
      try {
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is UserPostUpdated) {
      await repository.updateRequest(event.requestId, event.content);
      add(UserRequestInitialized());
    }  else if (event is UserPostDeleted) {
      try {
        await repository.removeRequest(state.selectedRequest!.requestId);
        add(UserRequestInitialized());
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
        print(e);
      }
    }
  }
}
