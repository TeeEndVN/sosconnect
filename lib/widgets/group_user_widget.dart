import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/group/group_user_bloc.dart';
import 'package:sosconnect/blocs/group/group_user_event.dart';
import 'package:sosconnect/blocs/group/group_user_state.dart';
import 'package:sosconnect/blocs/search/search_bloc.dart';
import 'package:sosconnect/blocs/search/search_event.dart';
import 'package:sosconnect/blocs/search/search_state.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:sosconnect/widgets/group_widget.dart';
import 'package:sosconnect/widgets/member_profile_widget.dart';

class GroupUserWidget extends StatefulWidget {
  final Group? group;
  const GroupUserWidget({Key? key, required this.group}) : super(key: key);

  @override
  _GroupUserWidgetState createState() => _GroupUserWidgetState();
}

class _GroupUserWidgetState extends State<GroupUserWidget> {
  List<Group> group = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupUserBloc(
        group: widget.group,
        repository: context.read<Repository>(),
      ),
      child: Scaffold(
        appBar: _searchBar(),
        body: _groupList(),
      ),
    );
  }

  PreferredSize _searchBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: BlocBuilder<GroupUserBloc, GroupUserState>(
            builder: (context, state) {
          return AppBar(
            title: Row(
              children: [
                Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width - 140,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 20,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) => context
                            .read<GroupUserBloc>()
                            .add(GroupUserQueryChanged(query: value)),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: 10.0, left: 10.0),
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Tìm kiếm thành viên...',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  context.read<GroupUserBloc>().add(GroupUserSearchSubmitted());
                },
              )
            ],
          );
        }));
  }

  _groupList() {
    return BlocBuilder<GroupUserBloc, GroupUserState>(
        builder: (context, state) {
      if (state.members?.isEmpty ?? true) {
        return const Center(
          child: Text("Không tìm thấy thành viên",
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
            itemCount: state.members!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      constraints: const BoxConstraints(minHeight: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MemberProfileWidget(
                                            userName:
                                                state.members![index].userName,
                                          )));
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            leading: const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person),
                            ),
                            title: Text(state.members![index].userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: state.members![index].role
                                ? const Text('Người hỗ trợ')
                                : const Text('Người cần hỗ trợ'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      }
    });
  }
}
