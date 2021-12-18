import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/profile/create_profile_bloc.dart';
import 'package:sosconnect/blocs/profile/create_profile_state.dart';
import 'package:sosconnect/blocs/profile/profile_event.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:intl/intl.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  String dropdownValue = 'Nam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CreateProfileBloc(
            repository: context.read<Repository>(),
            sessionCubit: context.read<SessionCubit>()),
        child: _createForm(),
      ),
    );
  }

  Widget _createForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _lastNameField(),
                      _firstNameField(),
                      _genderField(),
                      _dateOfBirthField(),
                      _countryField(),
                      _provinceField(),
                      _districtField(),
                      _wardField(),
                      _streetField(),
                      _emailField(),
                      _phoneNumberField(),
                      _createButton(),
                    ],
                  ),
                ))));
  }

  Widget _lastNameField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Họ',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileLastNameChanged(lastName: value)),
      );
    });
  }

  Widget _firstNameField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Tên',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileFirstNameChanged(firstName: value)),
      );
    });
  }

  Widget _genderField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return DropdownButtonFormField<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Giới tính',
        ),
        items:
            <String>['Nam', 'Nữ'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue == 'Nam') {
            context
                .read<CreateProfileBloc>()
                .add(ProfileGenderChanged(gender: true));
          } else {
            context
                .read<CreateProfileBloc>()
                .add(ProfileGenderChanged(gender: false));
          }
          setState(() {
            dropdownValue = newValue!;
          });
        },
      );
    });
  }

  Widget _dateOfBirthField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Ngày sinh',
        ),
        onTap: () async {
          await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((selectedDate) {
            if (selectedDate != null) {
              _dateController.text =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              context.read<CreateProfileBloc>().add(
                  ProfileDateOfBirthChanged(dateOfBirth: _dateController.text));
            }
          });
        },
      );
    });
  }

  Widget _countryField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Quốc gia',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileCountryChanged(country: value)),
      );
    });
  }

  Widget _provinceField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Tỉnh/thành phố',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileProvinceChanged(province: value)),
      );
    });
  }

  Widget _districtField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Quận/huyện',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileDistrictChanged(district: value)),
      );
    });
  }

  Widget _wardField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Phường/xã',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileWardChanged(ward: value)),
      );
    });
  }

  Widget _streetField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Đường',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileStreetChanged(street: value)),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Email',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfileEmailChanged(email: value)),
      );
    });
  }

  Widget _phoneNumberField() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Số điện thoại',
        ),
        onChanged: (value) => context
            .read<CreateProfileBloc>()
            .add(ProfilePhoneNumberChanged(phoneNumber: value)),
      );
    });
  }

  Widget _createButton() {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
        builder: (context, state) {
      return state.submissionStatus is Submitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              child: const Text('Hoàn tất'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<CreateProfileBloc>().add(SaveProfileChanges());
                }
              });
    });
  }
}
