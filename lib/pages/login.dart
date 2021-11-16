import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/auth/auth_cubit.dart';
import 'package:sosconnect/blocs/login/login_bloc.dart';
import 'package:sosconnect/blocs/login/login_event.dart';
import 'package:sosconnect/blocs/login/login_state.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/utils/repository.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
            repository: context.read<Repository>(),
            authCubit: context.read<AuthCubit>()),
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
        key: _formKey,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userNameField(),
              _passwordField(),
              _loginButton(),
              _showRegister()
            ],
          ),
        ));
  }

  Widget _userNameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Tên đăng nhập',
        ),
        validator: (value) =>
            state.isValidUserName ? null : 'Tên đăng nhập không hợp lệ',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginUserNameChanged(userName: value)),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Mật khẩu',
        ),
        obscureText: true,
        validator: (value) =>
            state.isValidPassword ? null : 'Mật khẩu không hợp lệ',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value)),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.submissionStatus is Submitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              child: const Text('Đăng nhập'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              });
    });
  }

  Widget _showRegister() {
    return Row(
      children: [
        const Text('Chưa có tài khoản? '),
        TextButton(
          child: const Text('Đăng kí'),
          onPressed: () => context.read<AuthCubit>().showRegister(),
        )
      ],
    );
  }
}
