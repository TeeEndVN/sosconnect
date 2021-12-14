import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/blocs/support/support_event.dart';
import 'package:sosconnect/blocs/support/support_state.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/models/support.dart';
import 'package:sosconnect/utils/repository.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final Repository repository;
  final Request? request;
  SupportBloc({required this.repository, required this.request})
      : super(SupportState(request: request)) {
    add(SupportInitialized());
  }

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is SupportInitialized) {
      yield state.copyWith(submissionStatus: Submitting());
      try {
        List<Support>? supports = await repository.requestSupports(
            state.request!.requestId, "", "", "desc");
        add(SupportListReceived(supports: supports));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is SupportListReceived) {
      yield state.copyWith(supports: event.supports);
    } else if (event is SupportSelected) {
      yield state.copyWith(selectedSupport: event.selectedSupport);
    } else if (event is SupportSubmitted) {
      yield state.copyWith(submissionStatus: Submitting());

      try {
        await repository.createSupport(state.request!.requestId, event.content);
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    } else if (event is SupportUpdated) {
      await repository.editSupport(event.supportId, event.content);
      add(SupportInitialized());
    } else if (event is SupportDeleted) {
      try {
        await repository.removeSupport(state.selectedSupport!.supportId);
        add(SupportInitialized());
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
        print(e);
      }
    }
  }
}
