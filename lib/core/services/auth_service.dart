import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final RxBool isAdmin = false.obs;

  static const String _adminPassword = 'admin@damas2025';

  bool loginAsAdmin(String password) {
    if (password.trim() == _adminPassword) {
      isAdmin.value = true;
      return true;
    }
    return false;
  }

  void logout() {
    isAdmin.value = false;
    Get.offAllNamed('/');
  }
}
