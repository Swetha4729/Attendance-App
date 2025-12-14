class BiometricService {
  Future<bool> authenticate() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
