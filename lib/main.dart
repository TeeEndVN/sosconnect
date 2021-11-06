import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/pages/index.dart';
import 'package:sosconnect/pages/login.dart';
import 'package:sosconnect/utils/jwt.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

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
      home: FutureBuilder(
        future: hasToken,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            var _hasToken = snapshot.data;
            if (_hasToken = false) {
              return Login();
            } else {
              if (JwtDecoder.isExpired(Jwt.accessToken)) {
                Fluttertoast.showToast(
                    msg: 'Hết phiên đăng nhập',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              } else
                return Index();
            }
          } else {
            return Login();
          }
          return Login();
        },
      ),
    );
  }

  Future<bool> get hasToken async {
    var jwt = await UserSecureStorage.readAccessToken();
    if (jwt == null) {
      return false;
    } else {
      Jwt.updateToken(jwt);
      return true;
    }
  }
}
