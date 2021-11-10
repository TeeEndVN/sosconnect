import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sosconnect/models/group.dart';
import 'package:sosconnect/models/member.dart';
import 'package:sosconnect/models/request.dart';
import 'package:sosconnect/models/profile.dart';
import 'package:sosconnect/models/support.dart';
import 'package:sosconnect/utils/custom_exception.dart';
import 'package:sosconnect/utils/jwt.dart';
import 'package:sosconnect/utils/user_secure_storage.dart';

class ApiService {
  ///1.1 Đăng kí
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

  ///1.3 Đăng nhập
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

  ///1.4 Làm mới token
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

  ///1.5 Đăng xuất
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

  ///1.6 Xem thông tin group
  static Future<Group?> group(int groupId) async {
    var uri = Uri.https('sos-connect-api.herokuapp.com', '/groups/$groupId/');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return Group.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException('Không tải được group');
    }
  }

  ///1.9 Người dùng tham gia group
  static Future<bool> joinGroup(
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

  ///1.10 Danh sách thành viên group
  static Future<List<Member>> groupMembers(
      int groupId, String search, String field, String sort) async {
    Map<String, String> parameters = {
      'search': search,
      'field': field,
      'sort': sort,
    };
    var uri = Uri.https(
        'sos-connect-api.herokuapp.com', '/groups/$groupId/users', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Member>((json) => Member.fromJson(json)).toList();
    } else {
      throw CustomException('Không tải được danh sách');
    }
  }

  ///1.11 Danh sách group
  static Future<List<Group>> groupList(
      String search, String field, String sort) async {
    Map<String, String> parameters = {
      'search': search,
      'field': field,
      'sort': sort,
    };
    var uri =
        Uri.https('sos-connect-api.herokuapp.com', '/groups/', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Group>((json) => Group.fromJson(json)).toList();
    } else {
      throw CustomException('Không tải được danh sách');
    }
  }

  ///1.13 Xem yêu cầu hỗ trợ trong group
  static Future<List<Request>> groupRequests(
      int groupId, String search, String field, String sort) async {
    Map<String, String> parameters = {
      'search': search,
      'field': field,
      'sort': sort,
    };
    var uri = Uri.https('sos-connect-api.herokuapp.com',
        '/groups/$groupId/requests', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Request>((json) => Request.fromJson(json)).toList();
    } else {
      throw CustomException('Không tải được danh sách');
    }
  }

  ///1.14 Tạo yêu cầu hỗ trợ
  static Future<bool> addRequest(int groupId, String content) async {
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

  ///1.16 Tạo profile
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

  ///1.17 Lấy profile
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

  ///1.18 Cập nhật profile
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

  ///1.19 Xóa mềm profile
  static Future<bool> deleteProfile(String userName) async {
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
      throw CustomException("Đã xảy ra lỗi không thể xóa mềm profile");
    }
  }

  ///1.20 Xem các yêu cầu hỗ trợ của người dùng
  static Future<List<Request>> memberRequests(String userName) async {
    var uri = Uri.https(
        'sos-connect-api.herokuapp.com', '/profiles/$userName/requests');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Request>((json) => Request.fromJson(json)).toList();
    } else {
      throw CustomException('Không tải được danh sách');
    }
  }

  ///1.21 Xem yêu cầu hỗ trợ
  static Future<Request?> request(int requestId) async {
    var uri =
        Uri.https('sos-connect-api.herokuapp.com', '/requests/$requestId/');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return Request.fromJson(jsonDecode(response.body));
    } else {
      throw CustomException('Không tải được member');
    }
  }

  ///1.23 Xem danh sách hỗ trợ cho 1 yêu cầu hỗ trợ
  static Future<List<Support>> requestSupports(
      int requestId, String search, String field, String sort) async {
    Map<String, String> parameters = {
      'search': search,
      'field': field,
      'sort': sort,
    };
    var uri = Uri.https('sos-connect-api.herokuapp.com',
        '/requests/$requestId/supports', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Support>((json) => Support.fromJson(json)).toList();
    } else {
      throw CustomException('Không tải được danh sách');
    }
  }

  ///1.24 Tạo hỗ trợ
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

  ///1.25 Chỉnh sửa yêu cầu hổ trợ
  static Future<bool> updateRequest(int requestId, String content) async {
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

  ///1.26 Xóa mềm yêu cầu hổ trợ
  static Future<bool> removeRequest(int requestId) async {
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

  ///1.28 Người yêu cầu hỗ trợ xác nhận đã nhận hỗ trợ
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

  ///1.29 Người hỗ trợ chỉnh sửa nội dung hỗ trợ
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

  ///1.30 người hỗ trợ xóa mềm hỗ trợ
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
}
