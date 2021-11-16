import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sosconnect/blocs/auth/auth_cubit.dart';
import 'package:sosconnect/blocs/register/register_bloc.dart';
import 'package:sosconnect/blocs/register/register_event.dart';
import 'package:sosconnect/blocs/register/register_state.dart';
import 'package:sosconnect/blocs/submission_status.dart';
import 'package:sosconnect/utils/repository.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterBloc(
            repository: context.read<Repository>(),
            authCubit: context.read<AuthCubit>()),
        child: _registerForm(),
      ),
    );
  }

  Widget _registerForm() {
    return Padding(
      key: _formKey,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userNameField(),
          _passwordField(),
          _confirmPasswordField(),
          _registerButton(),
          _showLogin()
        ],
      )),
    );
  }

  Widget _userNameField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
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
            .read<RegisterBloc>()
            .add(RegisterUserNameChanged(userName: value)),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Mật khẩu',
        ),
        obscureText: true,
        validator: (value) =>
            state.isValidPassword ? null : 'Mật khẩu không hợp lệ',
        onChanged: (value) => context
            .read<RegisterBloc>()
            .add(RegisterPasswordChanged(password: value)),
      );
    });
  }

  Widget _confirmPasswordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Xác nhận mật khẩu',
        ),
        obscureText: true,
        validator: (value) =>
            state.isValidConfirmPassword ? null : 'Mật khẩu không hợp lệ',
        onChanged: (value) => context
            .read<RegisterBloc>()
            .add(RegisterConfirmPasswordChanged(confirmPassword: value)),
      );
    });
  }

  Widget _registerButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return state.submissionStatus is Submitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              child: const Text('Đăng kí'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<RegisterBloc>().add(RegisterSubmitted());
                }
              });
    });
  }

  Widget _showLogin() {
    return Row(
      children: [
        const Text('Đã có tài khoản? '),
        TextButton(
          child: const Text('Đăng nhập'),
          onPressed: () => context.read<AuthCubit>().showLogin(),
        )
      ],
    );
  }
}
