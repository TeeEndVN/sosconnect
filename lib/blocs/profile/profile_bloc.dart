import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/profile/profile_event.dart';
import 'package:sosconnect/blocs/profile/profile_state.dart';
import 'package:sosconnect/models/profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required Profile profile, required bool isCurrentUser})
      : super(ProfileState(profile: profile, isCurrentUser: isCurrentUser));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileLastNameChanged) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is ProfileFirstNameChanged) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is ProfileGenderChanged) {
      yield state.copyWith(gender: event.gender);
    } else if (event is ProfileDateOfBirthChanged) {
      yield state.copyWith(dateOfBirth: event.dateOfBirth);
    } else if (event is ProfileCountryChanged) {
      yield state.copyWith(country: event.country);
    } else if (event is ProfileProvinceChanged) {
      yield state.copyWith(province: event.province);
    } else if (event is ProfileDistrictChanged) {
      yield state.copyWith(district: event.district);
    } else if (event is ProfileWardChanged) {
      yield state.copyWith(ward: event.ward);
    } else if (event is ProfileStreetChanged) {
      yield state.copyWith(street: event.street);
    } else if (event is SaveProfileChanges) {}
  }
}
