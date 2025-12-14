class WifiService {
  Future<bool> isConnectedToCollegeWifi() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<String> getWifiName() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return "COLLEGE_WIFI";
  }
}
