import 'package:intl/intl.dart';
import 'package:sosconnect/blocs/submission_status.dart';

class CreateProfileState {
  final String lastName;
  final String firstName;
  final bool gender;
  final String dateOfBirth;
  final String country;
  final String province;
  final String district;
  final String ward;
  final String street;
  final String email;
  final String phoneNumber;

  final SubmissionStatus submissionStatus;

  CreateProfileState({
    this.lastName = '',
    this.firstName = '',
    this.gender = true,
    this.dateOfBirth = '',
    this.country = '',
    this.province = '',
    this.district = '',
    this.ward = '',
    this.street = '',
    this.email = '',
    this.phoneNumber = '',
    this.submissionStatus = const InitialStatus(),
  });

  CreateProfileState copyWith(
      {String? lastName,
      String? firstName,
      bool? gender,
      String? dateOfBirth,
      String? country,
      String? province,
      String? district,
      String? ward,
      String? street,
      String? email,
      String? phoneNumber,
      SubmissionStatus? submissionStatus}) {
    return CreateProfileState(
        lastName: lastName ?? this.lastName,
        firstName: firstName ?? this.firstName,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        country: country ?? this.country,
        province: province ?? this.province,
        district: district ?? this.district,
        ward: ward ?? this.ward,
        street: street ?? this.street,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
