import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/user_request/user_request_bloc.dart';
import 'package:sosconnect/blocs/user_request/user_request_event.dart';
import 'package:sosconnect/blocs/user_request/user_request_state.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sosconnect/widgets/support_widget.dart';

class UserRequestWidget extends StatefulWidget {
  const UserRequestWidget({Key? key}) : super(key: key);

  @override
  _UserRequestWidgetState createState() => _UserRequestWidgetState();
}

class _UserRequestWidgetState extends State<UserRequestWidget> {
  final _requestTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserRequestBloc(
        repository: context.read<Repository>(),
      ),
      child: Scaffold(
        appBar: _userRequestBar(),
        body: _userRequestPage(),
      ),
    );
  }

  PreferredSize _userRequestBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: BlocBuilder<UserRequestBloc, UserRequestState>(
            builder: (context, state) {
          return AppBar(
            title: const Text('Yêu cầu hỗ trợ của bạn'),
          );
        }));
  }

  Widget _userRequestPage() {
    return BlocBuilder<UserRequestBloc, UserRequestState>(
        builder: (context, state) {
      return SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [_requestsList()],
          ),
        ),
      ));
    });
  }

  Widget _requestsList() {
    return BlocBuilder<UserRequestBloc, UserRequestState>(
        builder: (context, state) {
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
                              )),
                          Spacer(),
                          Icon(Icons.verified,
                              color: state.requests![index].isApprove
                                  ? Colors.green
                                  : Colors.grey),
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportWidget(
                                          currentUser: state.currentUser!,
                                          request: state.requests![index])));
                            },
                            child: const Text(
                              'Xem các hỗ trợ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          if (state.currentUser ==
                              state.requests![index].userName)
                            GestureDetector(
                              onTap: () {
                                final _provider =
                                    BlocProvider.of<UserRequestBloc>(context);
                                _requestTextEditingController.text =
                                    state.requests![index].content;
                                showMaterialModalBottomSheet(
                                    context: context,
                                    useRootNavigator: false,
                                    builder: (context) => BlocProvider.value(
                                        value: _provider,
                                        child: SingleChildScrollView(
                                          controller:
                                              ModalScrollController.of(context),
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
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Nhập nội dung thay đổi..."),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 20.0),
                                                      height: 40.0,
                                                      width: 200.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        color: Colors.blue,
                                                        elevation: 10.0,
                                                        shadowColor:
                                                            Colors.white70,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            _provider.add(UserPostUpdated(
                                                                requestId: state
                                                                    .requests![
                                                                        index]
                                                                    .requestId,
                                                                content:
                                                                    _requestTextEditingController
                                                                        .text));
                                                            _requestTextEditingController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Cập nhật',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 20.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 20.0),
                                                      height: 40.0,
                                                      width: 200.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        color: Colors.blue,
                                                        elevation: 10.0,
                                                        shadowColor:
                                                            Colors.white70,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            _requestTextEditingController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 20.0,
                                                              color:
                                                                  Colors.white,
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
                              child: const Text(
                                'Sửa',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          if (state.currentUser ==
                              state.requests![index].userName)
                            GestureDetector(
                              onTap: () {
                                context.read<UserRequestBloc>().add(
                                    UserRequestSelected(
                                        selectedRequest:
                                            state.requests![index]));
                                showDialog(
                                    context: context,
                                    useRootNavigator: false,
                                    builder: (_) => _deleteDialog(context));
                              },
                              child: const Text(
                                'Xóa',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  Widget _deleteDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: const Text('Bạn có muốn xóa yêu cầu hỗ trợ này'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            context.read<UserRequestBloc>().add(UserPostDeleted());
            print('ok');
            Navigator.pop(context);
          },
          child: const Text('Đồng ý'),
        ),
      ],
    );
  }
}
