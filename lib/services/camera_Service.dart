class CameraService {
  Future<bool> captureFace() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
