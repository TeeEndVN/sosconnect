import 'package:sosconnect/utils/api_service.dart';

class Repository {
  final ApiService apiService = ApiService();

  Future<void> register(
          String userName, String password, String confirmPassword) =>
      apiService.register(userName, password, confirmPassword);

  Future<void> login(String userName, String password) =>
      apiService.login(userName, password);

  Future<void> refresh() => apiService.refresh();

  Future<void> logout() => apiService.logout();

  Future<void> group(int groupId) => apiService.group(groupId);

  Future<void> joinGroup(int groupId, bool role, bool isAdminInvite) =>
      apiService.joinGroup(groupId, role, isAdminInvite);

  Future<void> groupMembers(
          int groupId, String search, String field, String sort) =>
      apiService.groupMembers(groupId, search, field, sort);

  Future<void> groupList(String search, String field, String sort) =>
      apiService.groupList(search, field, sort);

  Future<void> groupRequests(
          int groupId, String search, String field, String sort) =>
      apiService.groupRequests(groupId, search, field, sort);

  Future<void> addRequest(int groupId, String content) =>
      apiService.addRequest(groupId, content);

  Future<void> addProfile(
          String lastName,
          String firstName,
          bool gender,
          DateTime dateOfBirth,
          String country,
          String province,
          String district,
          String ward,
          String street) =>
      apiService.addProfile(lastName, firstName, gender, dateOfBirth, country,
          province, district, ward, street);

  Future<void> profile() => apiService.profile();

  Future<void> hasProfile() => apiService.hasProfile();

  Future<void> updateProfile(
          String lastName,
          String firstName,
          bool gender,
          DateTime dateOfBirth,
          String country,
          String province,
          String district,
          String ward,
          String street) =>
      apiService.updateProfile(lastName, firstName, gender, dateOfBirth,
          country, province, district, ward, street);

  Future<void> deleteProfile() => apiService.deleteProfile();

  Future<void> memberRequests() => apiService.memberRequests();

  Future<void> request(int requestId) => apiService.request(requestId);

  Future<void> requestSupports(
          int requestId, String search, String field, String sort) =>
      apiService.requestSupports(requestId, search, field, sort);

  Future<void> createSupport(int requestId, String content) =>
      apiService.createSupport(requestId, content);

  Future<void> updateRequest(int requestId, String content) =>
      apiService.updateRequest(requestId, content);

  Future<void> removeRequest(int requestId) =>
      apiService.removeRequest(requestId);

  Future<void> confirmSupport(int supportId, bool isConfirm) =>
      apiService.confirmSupport(supportId, isConfirm);

  Future<void> editSupport(int supportId, String content) =>
      apiService.editSupport(supportId, content);

  Future<void> removeSupport(int supportId) =>
      apiService.removeSupport(supportId);
}
