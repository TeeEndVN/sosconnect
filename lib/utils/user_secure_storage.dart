import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final storage = FlutterSecureStorage();
  static Future writeAccessToken(String accessToken) async =>
      await storage.write(key: 'accessToken', value: accessToken);
  static Future<String?> readAccessToken() async =>
      await storage.read(key: 'accessToken');
  static Future deleteAccessToken() async =>
      await storage.delete(key: 'accessToken');
  static Future writeRefreshToken(String refreshToken) async =>
      await storage.write(key: 'refreshToken', value: refreshToken);
  static Future<String?> readRefreshToken() async =>
      await storage.read(key: 'refreshToken');
  static Future deleteRefreshToken() async =>
      await storage.delete(key: 'refreshToken');
}
