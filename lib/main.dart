import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';
import 'package:sosconnect/navigators/app_navigator.dart';
import 'package:sosconnect/utils/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
          create: (context) => Repository(),
          child: BlocProvider(
            create: (context) => SessionCubit(context.read<Repository>()),
            child: AppNavigator(),
          )),
    );
  }
}
