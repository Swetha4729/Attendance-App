class AuthService {
  static Future<String> getToken() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return "dummy-token";
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
