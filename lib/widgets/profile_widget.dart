import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sosconnect/blocs/profile/profile_bloc.dart';
import 'package:sosconnect/blocs/profile/profile_event.dart';
import 'package:sosconnect/blocs/profile/profile_state.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';
import 'package:sosconnect/utils/repository.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final _dateController = TextEditingController();
  String dropdownValue = 'Nam';
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
      create: (context) => ProfileBloc(
        repository: context.read<Repository>(),
        profile: sessionCubit.selectedProfile ?? sessionCubit.currentProfile,
        isCurrentUser: sessionCubit.isCurrentProfileSelected,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF2F2F7),
        appBar: _appBar(),
        body: _profilePage(),
      ),
    );
  }

  PreferredSize _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return AppBar(
          title: const Text('Thông tin cá nhân'),
          actions: [
            if (state.isCurrentUser)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  context.read<SessionCubit>().signOut();
                },
              ),
          ],
        );
      }),
    );
  }

  Widget _profilePage() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              _avatar(),
              SizedBox(height: 10),
              _userName(),
              SizedBox(height: 30),
              _lastNameTile(),
              _firstNameTile(),
              _genderTile(),
              _dateOfBirthField(),
              _countryTile(),
              _provinceTile(),
              _districtTile(),
              _wardTile(),
              _streetTile(),
              if (state.isCurrentUser) _saveProfileChangesButton(),
            ],
          ),
        ),
      ));
    });
  }

  Widget _avatar() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    });
  }

  Widget _userName() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return RichText(
        text: TextSpan(
            text: state.userName,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20)),
      );
    });
  }

  Widget _lastNameTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.lastName,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Họ',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileLastNameChanged(lastName: value)),
        ),
      );
    });
  }

  Widget _firstNameTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.firstName,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Tên',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileFirstNameChanged(firstName: value)),
        ),
      );
    });
  }

  Widget _genderTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      dropdownValue = state.gender ? 'Nam' : 'Nữ';
      return ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.edit),
          title: DropdownButtonFormField<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Giới tính',
            ),
            items: <String>['Nam', 'Nữ']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (state.isCurrentUser) {
                if (newValue == 'Nam') {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileGenderChanged(gender: true));
                } else {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileGenderChanged(gender: false));
                }
                setState(() {
                  dropdownValue = newValue!;
                });
              }
            },
          ));
    });
  }

  Widget _dateOfBirthField() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      _dateController.text = state.dateOfBirth;
      return ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.calendar_today),
          title: TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Ngày sinh',
            ),
            onTap: () async {
              if (state.isCurrentUser) {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    context.read<ProfileBloc>().add(ProfileDateOfBirthChanged(
                        dateOfBirth: _dateController.text));
                  }
                });
              }
            },
          ));
    });
  }

  Widget _countryTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.country,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Quốc gia',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileCountryChanged(country: value)),
        ),
      );
    });
  }

  Widget _provinceTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.province,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Tỉnh/thành',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileProvinceChanged(province: value)),
        ),
      );
    });
  }

  Widget _districtTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.district,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Quận/huyện',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileDistrictChanged(district: value)),
        ),
      );
    });
  }

  Widget _wardTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.ward,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Phường/xã',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) =>
              context.read<ProfileBloc>().add(ProfileWardChanged(ward: value)),
        ),
      );
    });
  }

  Widget _streetTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.street,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Đường',
          ),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileStreetChanged(street: value)),
        ),
      );
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () {
          context.read<ProfileBloc>().add(SaveProfileChanges());
        },
        child: Text('Lưu thông tin'),
      );
    });
  }
}
