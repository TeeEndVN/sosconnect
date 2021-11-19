abstract class ProfileEvent {}

class ProfileLastNameChanged extends ProfileEvent {
  final String lastName;
  ProfileLastNameChanged({required this.lastName});
}

class ProfileFirstNameChanged extends ProfileEvent {
  final String firstName;
  ProfileFirstNameChanged({required this.firstName});
}

class ProfileGenderChanged extends ProfileEvent {
  final bool gender;
  ProfileGenderChanged({required this.gender});
}

class ProfileDateOfBirthChanged extends ProfileEvent {
  final String dateOfBirth;
  ProfileDateOfBirthChanged({required this.dateOfBirth});
}

class ProfileCountryChanged extends ProfileEvent {
  final String country;
  ProfileCountryChanged({required this.country});
}

class ProfileProvinceChanged extends ProfileEvent {
  final String province;
  ProfileProvinceChanged({required this.province});
}

class ProfileDistrictChanged extends ProfileEvent {
  final String district;
  ProfileDistrictChanged({required this.district});
}

class ProfileWardChanged extends ProfileEvent {
  final String ward;
  ProfileWardChanged({required this.ward});
}

class ProfileStreetChanged extends ProfileEvent {
  final String street;
  ProfileStreetChanged({required this.street});
}

class SaveProfileChanges extends ProfileEvent {}
