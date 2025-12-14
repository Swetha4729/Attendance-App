import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  UserModel? user;

  Future<bool> login(String email, String password, String role) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    user = UserModel(
      id: '1',
      name: 'Demo User',
      role: role,
    );

    isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
