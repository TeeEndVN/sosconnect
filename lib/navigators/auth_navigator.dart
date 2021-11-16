import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/auth/auth_cubit.dart';
import 'package:sosconnect/pages/login.dart';
import 'package:sosconnect/pages/register.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state == AuthState.login) MaterialPage(child: Login()),
          if (state == AuthState.register) MaterialPage(child: Register())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
