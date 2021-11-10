import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/request.dart';
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

  // 1.14. API tạo yêu cầu hỗ trợ
  static Future<bool> addRqSupport(int groupId, String content) async {
    var uri = Uri.parse(
        'https://sos-connect-api.herokuapp.com/groups/$groupId/requests');
    var accessToken = Jwt.accessToken;
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'content': content,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi tạo yêu cầu hỗ trợ");
    }
  }

  //1.25. API chỉnh sửa yêu cầu hổ trợ
  static Future<bool> updateRqSupport(int requestId, String content) async {
    var uri = Uri.https(
        'https://sos-connect-api.herokuapp.com', '/groups/$requestId/requests');
    var accessToken = Jwt.accessToken;
    var response = await http.put(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'content': content,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi chỉnh sửa yêu cầu hỗ trợ");
    }
  }

  //1.26. API xóa mềm yêu cầu hổ trợ
  static Future<bool> removeRqSupport(int requestId) async {
    var uri = Uri.https(
        'https://sos-connect-api.herokuapp.com', '/groups/$requestId/requests');
    var accessToken = Jwt.accessToken;
    var response = await http.delete(
      uri,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi không thể xóa mềm yêu cầu hỗ trợ");
    }
  }

  // 1.28.API người yêu cầu hỗ trợ xác nhận đã nhận hỗ trợ
  static Future<bool> confirmSupport(int supportId, bool isConfirm) async {
    var uri = Uri.https(
        'https://sos-connect-api.herokuapp.com', '/supports/$supportId');
    var accessToken = Jwt.accessToken;
    var response = await http.put(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'is_confirmed': isConfirm ? '1' : '0',
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi không thể xác nhận đã nhận hỗ trợ");
    }
  }

  //1.24.API tạo hỗ trợ
  static Future<bool> createSupport(int requestId, String content) async {
    var uri = Uri.parse(
        'https://sos-connect-api.herokuapp.com/requests/$requestId/supports');
    var accessToken = Jwt.accessToken;
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'content': content,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi tạo hỗ trợ");
    }
  }

  //1.29. API người hỗ trợ chỉnh sửa nội dung hỗ trợ
  static Future<bool> editSupport(int supportId, String content) async {
    var uri = Uri.https(
        'https://sos-connect-api.herokuapp.com', '/supports/$supportId');
    var accessToken = Jwt.accessToken;
    var response = await http.put(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'content': content,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi chỉnh sửa nội dung hỗ trợ");
    }
  }

  // 1.30.API người hỗ trợ xóa mềm hỗ trợ
  static Future<bool> removeSupport(int supportId) async {
    var uri = Uri.https(
        'https://sos-connect-api.herokuapp.com', '/supports/$supportId');
    var accessToken = Jwt.accessToken;
    var response = await http.delete(
      uri,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi không thể xóa mềm trong hỗ trợ");
    }
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

  // 1.19.API xóa mềm profile
  static Future<bool> softDeleteProfile(String userName) async {
    var uri = Uri.https(
        ' https://sos-connect-api.herokuapp.com', '/profiles/$userName');
    var accessToken = Jwt.accessToken;
    var response = await http.delete(
      uri,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi không thể xóa mềm Profiles");
    }
  }

  //1.9.API người dùng tham gia group
  static Future<bool> memberGroup(
      int groupId, bool role, bool isAdminInvite) async {
    var uri = Uri.parse(
        'https://sos-connect-api.herokuapp.com/groups/$groupId/users');
    var accessToken = Jwt.accessToken;
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'as_role': role ? '1' : '0',
          'is_admin_invited': isAdminInvite ? '1' : '0',
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw CustomException("Đã xảy ra lỗi người dùng tham gia group");
    }
  }
}
