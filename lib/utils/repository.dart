import 'package:sosconnect/utils/api_service.dart';

class Repository {
  final ApiService apiService = ApiService();

  Future<bool> register(
          String userName, String password, String confirmPassword) =>
      register(userName, password, confirmPassword);

  Future<void> login(String userName, String password) =>
      apiService.login(userName, password);

  Future<void> refresh() => apiService.refresh();

  Future<void> logout() => apiService.logout();
}
