class Profile {
  final String userName;
  final String lastName;
  final String firstName;
  final bool gender;
  final String dateOfBirth;
  final String country;
  final String province;
  final String district;
  final String ward;
  final String street;

  Profile({
    required this.userName,
    required this.lastName,
    required this.firstName,
    required this.gender,
    required this.dateOfBirth,
    required this.country,
    required this.province,
    required this.district,
    required this.ward,
    required this.street,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userName: json['username'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      country: json['country'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
      street: json['street'],
    );
  }
}
