import 'package:get/get.dart';
import 'package:kota/apiServices/auth_api_services.dart';
import 'package:kota/model/guest_model.dart';
import 'package:kota/model/login_model.dart';
import '../constants/app_constants.dart';

class AuthController extends GetxController {
  Rxn<LoginResponseModel> userModel = Rxn<LoginResponseModel>();
  Rxn<GuestModel> guestModel = Rxn<GuestModel>();
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

  Future<bool> registerAsGuest({
  required String fullName,
  required String mailId,
  required String password,
  required String confirmPassword,
  required String phoneNumber,
}) async {
  try {
    final result = await _authService.register(
      fullName: fullName,
      mailId: mailId,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
    );

    if (result.status == true) {
      guestModel.value = result;

      // ✅ Set userModel to indicate it's a guest
      userModel.value = LoginResponseModel(
        status: true,
        message: "Guest login",
        id: AppConstants.guest,
      );

      Get.snackbar("Registration Success", result.message ?? 'Success');
      return true;
    } else {
      Get.snackbar("Registration Failed", result.message ?? 'Failed');
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