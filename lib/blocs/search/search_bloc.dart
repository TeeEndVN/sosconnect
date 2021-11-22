import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/search/search_event.dart';
import 'package:sosconnect/blocs/search/search_state.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/utils/repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Repository repository;
  SearchBloc({required this.repository}) : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchQueryChanged) {
      yield state.copyWith(query: event.query);
    } else if (event is SearchGroupListReceived) {
      yield state.copyWith(groups: event.groups);
    } else if (event is SearchGroupSelected) {
      yield state.copyWith(selectedGroup: event.selectedGroup);
    } else if (event is SearchSubmitted) {
      yield state.copyWith(submissionStatus: Submitting());

      try {
        List<Group>? groups = await repository.groupList(state.query, '', '');
        add(SearchGroupListReceived(groups: groups));
        yield state.copyWith(submissionStatus: Success());
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    }
  }
}
