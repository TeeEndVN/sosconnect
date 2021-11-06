import 'package:flutter/material.dart';
import 'package:sosconnect/utils/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sosconnect/utils/custom_exception.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
            TextButton(
              child: const Text('Đăng kí'),
              onPressed: () async {
                try {
                  var response = await ApiService.register(
                      _userNameController.text, _passwordController.text);
                  if (response == true) {
                    Fluttertoast.showToast(
                        msg: "Đăng kí thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                    Navigator.pop(context);
                  }
                } on CustomException catch (e) {
                  Fluttertoast.showToast(
                      msg: e.cause,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
