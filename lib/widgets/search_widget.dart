import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/search/search_bloc.dart';
import 'package:sosconnect/blocs/search/search_event.dart';
import 'package:sosconnect/blocs/search/search_state.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/utils/repository.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<Group> group = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
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
        child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          return AppBar(
            title: Row(
              children: [
                Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) => context
                            .read<SearchBloc>()
                            .add(SearchQueryChanged(query: value)),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: 10.0, left: 10.0),
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Tìm kiếm nhóm...',
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
                  context.read<SearchBloc>().add(SearchSubmitted());
                },
              )
            ],
          );
        }));
  }

  _groupList() {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state.groups?.isEmpty ?? true) {
        return const Center(
          child: Text("Không tìm thấy nhóm",
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
            itemCount: state.groups!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                    title: Text(state.groups![index].name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      state.groups![index].description,
                    ),
                  ),
                  Divider(),
                ],
              );
            });
      }
    });
  }
}
