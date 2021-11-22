import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/auth/auth_cubit.dart';
import 'package:sosconnect/blocs/session/session_cubit.dart';
import 'package:sosconnect/blocs/session/session_state.dart';
import 'package:sosconnect/navigators/auth_navigator.dart';
import 'package:sosconnect/pages/create_profile.dart';
import 'package:sosconnect/pages/index.dart';
import 'package:sosconnect/widgets/loading_widget.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state is UnknownSessionState)
            MaterialPage(child: LoadingWidget()),
          if (state is Unauthenticated)
            MaterialPage(
                child: BlocProvider(
              create: (context) => AuthCubit(context.read<SessionCubit>()),
              child: AuthNavigator(),
            )),
          if (state is Authenticated) MaterialPage(child: Index()),
          if (state is AuthenticatedWithoutProfile)
            MaterialPage(child: CreateProfile())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
