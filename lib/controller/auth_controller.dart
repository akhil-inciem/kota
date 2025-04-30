import 'package:get/get.dart';
import 'package:kota/apiServices/auth_api_services.dart';
import 'package:kota/model/login_model.dart';
import '../constants/app_constants.dart';

class AuthController extends GetxController {
  Rxn<LoginResponseModel> userModel = Rxn<LoginResponseModel>();
  final AuthApiService _authService = AuthApiService();

  bool get isGuest => userModel.value?.id == AppConstants.guest;
  bool get isUser => userModel.value?.id != null;

  Future<bool> loginAsUser(String username, String password) async {
    try {
      final response = await _authService.login(username, password);
      if (response.status) {
        userModel.value = response;
        return true;
      } else {
        Get.snackbar("Login Failed", response.message);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  void loginAsGuest() {
    userModel.value = LoginResponseModel(
      status: true,
      message: "Guest login",
      id: AppConstants.guest,
    );
  }
}