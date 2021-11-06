import 'package:flutter/material.dart';
import 'package:sosconnect/pages/index.dart';
import 'package:sosconnect/pages/register.dart';
import 'package:sosconnect/utils/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sosconnect/utils/custom_exception.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Form(
        child: Column(
          children: [
            TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                controller: _userNameController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Tên đăng nhập',
                )),
            TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Mật khẩu',
                ),
                obscureText: true),
            ElevatedButton(
              child: const Text('Đăng nhập'),
              onPressed: () async {
                try {
                  var response = await ApiService.login(
                      _userNameController.text, _passwordController.text);
                  if (response == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Index()));
                  }
                } on CustomException {
                  Fluttertoast.showToast(
                      msg: "Đăng nhập thất bại",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER);
                }
              },
            ),
            Row(
              children: [
                const Text('Chưa có tài khoản? '),
                TextButton(
                  child: const Text('Đăng kí'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
