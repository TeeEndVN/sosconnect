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

  final SubmissionStatus submissionStatus;

  CreateProfileState({
    this.lastName = '',
    this.firstName = '',
    this.gender = false,
    String? dateOfBirth,
    this.country = '',
    this.province = '',
    this.district = '',
    this.ward = '',
    this.street = '',
    this.submissionStatus = const InitialStatus(),
  }) : dateOfBirth = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
        submissionStatus: submissionStatus ?? this.submissionStatus);
  }
}
