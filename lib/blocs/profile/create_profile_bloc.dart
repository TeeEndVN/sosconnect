import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/profile/create_profile_state.dart';
import 'package:sosconnect/blocs/profile/profile_event.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/utils/repository.dart';

class CreateProfileBloc extends Bloc<ProfileEvent, CreateProfileState> {
  final Repository repository;
  final SessionCubit sessionCubit;
  CreateProfileBloc({required this.repository, required this.sessionCubit})
      : super(CreateProfileState());

  @override
  Stream<CreateProfileState> mapEventToState(ProfileEvent event) async* {
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
    } else if (event is ProfileEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is ProfilePhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);
    } else if (event is SaveProfileChanges) {
      yield state.copyWith(submissionStatus: Submitting());
      try {
        await repository.addProfile(
            state.lastName,
            state.firstName,
            state.gender,
            state.dateOfBirth,
            state.country,
            state.province,
            state.district,
            state.ward,
            state.street,
            state.email,
            state.phoneNumber);
        yield state.copyWith(submissionStatus: Success());
        sessionCubit.showSession();
      } on Exception catch (e) {
        yield state.copyWith(submissionStatus: Failed(exception: e));
      }
    }
  }
}
