import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/member/member_profile_bloc.dart';
import 'package:sosconnect/blocs/member/member_profile_state.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfileWidget extends StatefulWidget {
  final String userName;
  const MemberProfileWidget({Key? key, required this.userName})
      : super(key: key);

  @override
  _MemberProfileWidgetState createState() => _MemberProfileWidgetState();
}

class _MemberProfileWidgetState extends State<MemberProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemberProfileBloc(
          repository: context.read<Repository>(), userName: widget.userName),
      child: Scaffold(
        appBar: _profileBar(),
        body: _profilePage(),
      ),
    );
  }

  PreferredSize _profileBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: BlocBuilder<MemberProfileBloc, MemberProfileState>(
            builder: (context, state) {
          return AppBar(
            title: const Text('Thông tin thành viên'),
          );
        }));
  }

  Widget _profilePage() {
    return BlocBuilder<MemberProfileBloc, MemberProfileState>(
        builder: (context, state) {
      return SafeArea(
          child: Column(
        children: [
          SizedBox(height: 30),
          if (state.profile != null) _avatar(),
          SizedBox(height: 10),
          _userName(),
          SizedBox(height: 30),
          if (state.profile != null) _info()
        ],
      ));
    });
  }

  Widget _avatar() {
    return BlocBuilder<MemberProfileBloc, MemberProfileState>(
        builder: (context, state) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: state.profile!.avatarUrl.isEmpty
            ? null
            : NetworkImage(state.profile!.avatarUrl),
      );
    });
  }

  Widget _userName() {
    return BlocBuilder<MemberProfileBloc, MemberProfileState>(
        builder: (context, state) {
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

  Widget _info() {
    return BlocBuilder<MemberProfileBloc, MemberProfileState>(
        builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  'Tên ',
                  style: GoogleFonts.lato(
                      color: Colors.grey[900],
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: Text(
                  '${state.profile!.lastName} ${state.profile!.firstName}',
                  style: GoogleFonts.lato(
                      color: Colors.grey[600],
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  'Ngày sinh ',
                  style: GoogleFonts.lato(
                      color: Colors.grey[900],
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  state.profile!.dateOfBirth,
                  style: GoogleFonts.lato(
                      color: Colors.grey[600],
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Divider(),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Icon(Icons.person),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Thông tin liên hệ',
                  style: GoogleFonts.lato(
                      color: Colors.grey[700],
                      fontSize: 17,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 54.0),
                child: Icon(Icons.mail, color: Colors.grey[500]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  state.profile!.email,
                  style: GoogleFonts.lato(
                      color: Colors.grey[700],
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 54.0),
                child: Icon(Icons.phone, color: Colors.grey[500]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  state.profile!.phoneNumber,
                  style: GoogleFonts.lato(
                      color: Colors.grey[700],
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 54.0),
                child: Icon(Icons.home_outlined, color: Colors.grey[500]),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      '${state.profile!.street}, ${state.profile!.ward},\n${state.profile!.district}, ${state.profile!.province}, ${state.profile!.country}',
                      style: GoogleFonts.lato(
                          color: Colors.grey[700],
                          fontSize: 14,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      );
    });
  }
}
