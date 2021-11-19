import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/models/profile.dart';

class ProfileState {
  final Profile profile;
  final bool isCurrentUser;
  final String lastName;
  final String firstName;
  final bool gender;
  final String dateOfBirth;
  final String country;
  final String province;
  final String district;
  final String ward;
  final String street;

  String get userName => profile.userName;
  final SubmissionStatus submissionStatus;

  ProfileState({
    required this.profile,
    required this.isCurrentUser,
    String? lastName,
    String? firstName,
    bool? gender,
    String? dateOfBirth,
    String? country,
    String? province,
    String? district,
    String? ward,
    String? street,
    this.submissionStatus = const InitialStatus(),
  })  : lastName = lastName ?? profile.lastName,
        firstName = firstName ?? profile.firstName,
        gender = gender ?? profile.gender,
        dateOfBirth = dateOfBirth ?? profile.dateOfBirth,
        country = country ?? profile.country,
        province = province ?? profile.province,
        district = district ?? profile.district,
        ward = ward ?? profile.ward,
        street = street ?? profile.street;

  ProfileState copyWith(
      {Profile? profile,
      bool? isCurrentUser,
      String? lastName,
      String? firstName,
      bool? gender,
      String? dateOfBirth,
      String? country,
      String? province,
      String? district,
      String? ward,
      String? street,
      SubmissionStatus? submissionStatus}) {
    return ProfileState(
        profile: profile ?? this.profile,
        isCurrentUser: isCurrentUser ?? this.isCurrentUser,
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
