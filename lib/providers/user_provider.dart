import 'package:flutter/foundation.dart';
import 'package:hit_api/models/user.dart';
import 'package:hit_api/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService userService = UserService();
  bool isLoading = false;
  List<UserResponse>? _data;
  List<UserResponse>? get data => _data;

  Future<bool> doCreateUser(UserRequest request) async {
    isLoading = true;
    notifyListeners();
    try {
      bool isSuccess = await userService.createUser(request);
      isLoading = false;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> doUpdateUser(UserRequest request, String id) async {
    isLoading = true;
    notifyListeners();
    try {
      bool isSuccess = await userService.updateUser(request, id);
      isLoading = false;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getAllUser() async {
    isLoading = true;
    notifyListeners();
    try {
      _data = await userService.getDataUser();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      await userService.deleteData(id);
      await getAllUser();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
