import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/support/support_bloc.dart';
import 'package:sosconnect/blocs/support/support_event.dart';
import 'package:sosconnect/blocs/support/support_state.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/utils/repository.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SupportWidget extends StatefulWidget {
  final Request? request;
  final String currentUser;
  const SupportWidget(
      {Key? key, required this.request, required this.currentUser})
      : super(key: key);

  @override
  _SupportWidgetState createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<SupportWidget> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        request: widget.request,
        repository: context.read<Repository>(),
      ),
      child: Scaffold(
        appBar: _supportBar(),
        body: _supportPage(),
      ),
    );
  }

  PreferredSize _supportBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child:
            BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
          return AppBar(
            title: const Text('Hỗ trợ'),
          );
        }));
  }

  Widget _supportPage() {
    return BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
      if (state.request!.userName == widget.currentUser) {
        return SafeArea(
            child: Container(
          child: _commentsListView(),
        ));
      } else {
        return SafeArea(
            child: Container(
          child: _commentBox(),
        ));
      }
    });
  }

  Widget _commentsListView() {
    return BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
      if (state.supports?.isEmpty ?? true) {
        return const Center(
          child: Text("Không có hỗ trợ nào",
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
            itemCount: state.supports!.length,
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
                                state.supports![index].username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                          Spacer(),
                          Icon(Icons.verified,
                              color: state.supports![index].isConfirm
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
                        child: Text(state.supports![index].content),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(children: [
                            if ((widget.currentUser ==
                                    widget.request!.userName) &&
                                (state.supports![index].isConfirm == true))
                              GestureDetector(
                                onTap: () {
                                  context.read<SupportBloc>().add(
                                      SupportSelected(
                                          selectedSupport:
                                              state.supports![index]));
                                  showDialog(
                                      context: context,
                                      useRootNavigator: false,
                                      builder: (_) => _confirmDialog(context));
                                },
                                child: const Text(
                                  'Xác nhận',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            if ((widget.currentUser ==
                                    widget.request!.userName) &&
                                (state.supports![index].isConfirm == true))
                              const SizedBox(
                                width: 10.0,
                              ),
                            if (widget.currentUser ==
                                state.supports![index].username)
                              GestureDetector(
                                onTap: () {
                                  final _provider =
                                      BlocProvider.of<SupportBloc>(context);
                                  _commentController.text =
                                      state.supports![index].content;
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      useRootNavigator: false,
                                      builder: (context) => BlocProvider.value(
                                          value: _provider,
                                          child: SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
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
                                                          _commentController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Nhập nội dung thay đổi..."),
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 5),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 20.0),
                                                        height: 40.0,
                                                        width: 200.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.0),
                                                          color: Colors.blue,
                                                          elevation: 10.0,
                                                          shadowColor:
                                                              Colors.white70,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              _provider.add(SupportUpdated(
                                                                  supportId: state
                                                                      .supports![
                                                                          index]
                                                                      .supportId,
                                                                  content:
                                                                      _commentController
                                                                          .text));
                                                              _commentController
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
                                                                color: Colors
                                                                    .white,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.0),
                                                          color: Colors.blue,
                                                          elevation: 10.0,
                                                          shadowColor:
                                                              Colors.white70,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              _commentController
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
                                                                color: Colors
                                                                    .white,
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
                            if (widget.currentUser ==
                                state.supports![index].username)
                              GestureDetector(
                                onTap: () {
                                  context.read<SupportBloc>().add(
                                      SupportSelected(
                                          selectedSupport:
                                              state.supports![index]));
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
                          ])),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  Widget _commentBox() {
    return BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
      return CommentBox(
        userImage: "https://cdn.onlinewebfonts.com/svg/download_184513.png",
        child: _commentsListView(),
        labelText: 'Bạn muốn hỗ trợ gì...',
        withBorder: false,
        errorText: 'Không được để trống',
        sendButtonMethod: () {
          context
              .read<SupportBloc>()
              .add(SupportSubmitted(content: _commentController.text));
          context.read<SupportBloc>().add(SupportInitialized());
          FocusScope.of(context).unfocus();
          _commentController.clear();
        },
        commentController: _commentController,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
      );
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
            context.read<SupportBloc>().add(SupportDeleted());
            print('ok');
            Navigator.pop(context);
          },
          child: const Text('Đồng ý'),
        ),
      ],
    );
  }

  Widget _confirmDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận'),
      content: const Text('Bạn có muốn xác nhận yêu cầu hỗ trợ này'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            context.read<SupportBloc>().add(SupportConfirmed());
            print('ok');
            Navigator.pop(context);
          },
          child: const Text('Đồng ý'),
        ),
      ],
    );
  }
}
