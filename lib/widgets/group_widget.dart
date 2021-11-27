import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/group/group_bloc.dart';
import 'package:sosconnect/blocs/group/group_event.dart';
import 'package:sosconnect/blocs/group/group_state.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GroupWidget extends StatefulWidget {
  final Group? group;
  const GroupWidget({Key? key, required this.group}) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _requestTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(
        group: widget.group,
        repository: context.read<Repository>(),
      ),
      child: Scaffold(
        appBar: _groupBar(),
        body: _groupPage(),
      ),
    );
  }

  PreferredSize _groupBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
          return AppBar(
            title: const Text('Nhóm'),
            actions: [
              if (state.role == false)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final _provider = BlocProvider.of<GroupBloc>(context);
                    showMaterialModalBottomSheet(
                        context: context,
                        useRootNavigator: false,
                        builder: (context) => BlocProvider.value(
                            value: _provider,
                            child: SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                    child: Column(
                                  children: [
                                    TextField(
                                        controller:
                                            _requestTextEditingController,
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Nhập nội dung cần hỗ trợ..."),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 20.0),
                                          height: 40.0,
                                          width: 200.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            color: Colors.blue,
                                            elevation: 10.0,
                                            shadowColor: Colors.white70,
                                            child: MaterialButton(
                                              onPressed: () {
                                                _provider.add(GroupPostSubmitted(
                                                    groupId:
                                                        state.group!.groupId,
                                                    content:
                                                        _requestTextEditingController
                                                            .text));
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Đăng',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, bottom: 20.0),
                                          height: 40.0,
                                          width: 200.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            color: Colors.blue,
                                            elevation: 10.0,
                                            shadowColor: Colors.white70,
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Hủy',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ),
                            )));
                  },
                )
            ],
          );
        }));
  }

  Widget _groupPage() {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      return SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [_groupInfo(), _joinButton(), Divider(), _requestsList()],
          ),
        ),
      ));
    });
  }

  Widget _groupInfo() {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      return SafeArea(
          child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 250.0,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                            Colors.blue,
                            Colors.white,
                          ])),
                    ),
                    Positioned(
                        top: 100,
                        right: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0),
                          child: Text(
                            state.group!.name,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                constraints: BoxConstraints(minHeight: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      "Mô tả",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      state.group!.description,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }

  Widget _joinButton() {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
        height: 40.0,
        width: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.white),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.blue,
          elevation: 10.0,
          shadowColor: Colors.white70,
          child: MaterialButton(
            onPressed: state.role == null
                ? () {
                    showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => _joinDialog(context));
                  }
                : null,
            child: Text(
              state.role == null ? 'Tham gia' : 'Đã tham gia',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _requestsList() {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      if (state.requests?.isEmpty ?? true) {
        return const Center(
          child: Text("Không có yêu cầu nào",
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
            itemCount: state.requests!.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(12.0),
                shadowColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(minHeight: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          )),
                          GestureDetector(
                              onTap: () {},
                              child: Text(
                                state.requests![index].userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(state.requests![index].content),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Xem các hỗ trợ',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  Widget _joinDialog(BuildContext context) {
    return SimpleDialog(
      title: Text('Chọn vai trò trong nhóm'),
      children: [
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.edit),
          title: Text('Người cần hỗ trợ'),
          onTap: () {
            context.read<GroupBloc>().add(GroupRoleChanged(role: false));
            context.read<GroupBloc>().add(GroupJoinSubmitted());
            Navigator.pop(context);
          },
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.edit),
          title: Text('Người hỗ trợ'),
          onTap: () {
            context.read<GroupBloc>().add(GroupRoleChanged(role: true));
            context.read<GroupBloc>().add(GroupJoinSubmitted());
            Navigator.pop(context);
          },
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.edit),
          title: Text('Hủy'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
