import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/utils/custom_exception.dart';
import 'package:sosconnect/utils/jwt.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

class ApiService {
  static Future<bool> login(String userName, String password) async {
    var uri =
        Uri.parse('https://sos-connect-auth.herokuapp.com/tokens/$userName/');
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'password': password,
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String accessToken = json['accessToken'];
      await UserSecureStorage.writeAccessToken(accessToken);
      String refreshToken = json['refreshToken'];
      await UserSecureStorage.writeRefreshToken(refreshToken);
      return true;
    } else {
      throw CustomException("Đăng nhập không thành công");
    }
  }

  static Future<bool> register(String userName, String password) async {
    var uri = Uri.parse('https://sos-connect-auth.herokuapp.com/accounts/');
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'username': userName,
          'password': password,
        }));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException("Tên đăng nhập đã tồn tại");
    } else {
      throw CustomException("Đã xảy ra lỗi");
    }
  }

  static Future<void> refresh(String userName) async {
    var uri =
        Uri.parse('https://sos-connect-auth.herokuapp.com/tokens/$userName/');
    var refreshToken = await UserSecureStorage.readRefreshToken();
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String?>{
          'refreshToken': refreshToken,
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String accessToken = json['accessToken'];
      await UserSecureStorage.writeAccessToken(accessToken);
      Jwt.updateToken(accessToken);
    }
  }

  static Future<bool> logout(String userName) async {
    var uri = Uri.https('sos-connect-auth.herokuapp.com', '/tokens/$userName/');
    var accessToken = Jwt.accessToken;
    var response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      await UserSecureStorage.deleteAccessToken();
      await UserSecureStorage.deleteRefreshToken();
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi");
    }
  }

  static Future<Profile?> profile(String userName) async {
    var uri =
        Uri.https('sos-connect-api.herokuapp.com', '/profiles/$userName/');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException('Không tải được profile');
    }
  }

  static Future<bool> hasProfile(String userName) async {
    var uri =
        Uri.https('sos-connect-api.herokuapp.com', '/profiles/$userName/');
    var response = await http.get(uri);
    if (response.statusCode == 400) {
      return true;
    }
    return false;
  }

  static Future<bool> addProfile(
      String lastName,
      String firstName,
      bool gender,
      DateTime dateOfBirth,
      String country,
      String province,
      String district,
      String ward,
      String street) async {
    var uri = Uri.parse('https://sos-connect-api.herokuapp.com/profiles');
    var accessToken = Jwt.accessToken;
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'last_name': lastName,
          'first_name': firstName,
          'gender': gender ? '1' : '0',
          'date_of_birth': dateOfBirth.toIso8601String(),
          'country': country,
          'province': province,
          'district': district,
          'ward': ward,
          'street': street,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi");
    }
  }

  static Future<bool> updateProfile(
      String lastName,
      String firstName,
      bool gender,
      DateTime dateOfBirth,
      String country,
      String province,
      String district,
      String ward,
      String street) async {
    var accessToken = Jwt.accessToken;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    var userName = decodedToken['username'];
    var uri =
        Uri.https('sos-connect-api.herokuapp.com', '/profiles/$userName/');
    var response = await http.put(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'last_name': lastName,
          'first_name': firstName,
          'gender': gender ? '1' : '0',
          'date_of_birth': dateOfBirth.toIso8601String(),
          'country': country,
          'province': province,
          'district': district,
          'ward': ward,
          'street': street,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi");
    }
  }
}
