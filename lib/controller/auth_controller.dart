import 'package:get/get.dart';
import 'package:kota/apiServices/auth_api_services.dart';
import 'package:kota/model/guest_model.dart';
import 'package:kota/model/login_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  Rxn<LoginResponseModel> userModel = Rxn<LoginResponseModel>();
  Rxn<GuestModel> guestModel = Rxn<GuestModel>();
  final AuthApiService _authService = AuthApiService();
  bool get isGuest => userModel.value?.data.isGuest == 1;
  bool get isUser => userModel.value?.data.isGuest == 0;
  RxString guestId = ''.obs;

  final isExpanded = false.obs;
  final isLoading = false.obs;

  void toggleExpansion() => isExpanded.value = !isExpanded.value;

  void collapse() => isExpanded.value = false;

  void expand() => isExpanded.value = true;

  Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      final isGuest = prefs.getBool('is_guest') ?? false;
      final userId = prefs.getString('user_id') ?? '';
      final role = prefs.getString('role') ?? '';

      userModel.value = LoginResponseModel(
        status: true,
        message: "Restored Session",
        role: role,
        data: UserData(id: userId, isGuest: isGuest ? 1 : 0),
      );
    }
  }

  Future<bool> loginAsUser(String username, String password) async {
    try {
      isLoading.value = true;
      final response = await _authService.login(username, password);
      if (response.status) {
        userModel.value = response;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setBool('is_guest', userModel.value!.data.isGuest == 1);
        await prefs.setString('user_id', userModel.value!.data.id.toString());
        await prefs.setString('role', userModel.value!.role ?? '');

        CustomSnackbars.success("Login Successful", "Welcome to KOTA");
        return true;
      } else {
        CustomSnackbars.warning(
          "We couldn’t log you in. Please check your username and password and try again.",
          "Login Failed",
        );
        return false;
      }
    } catch (e) {
      CustomSnackbars.failure(
        "Something went wrong while trying to log in. Please try again later.",
        "Unexpected Error",
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPasswordUser(String email) async {
    try {
      isLoading.value = true;
      await _authService.resetPasswordUser(email);
      return true; // success
    } catch (e) {
      print("Failed to send mail: $e");
      return false; // failure
    } finally {
      isLoading.value = false;
    }
  }

 Future<bool> sendOtpToGuest(String email) async {
  try {
    isLoading.value = true;

    final response = await _authService.forgotPasswordGuest(email);

    if (response['status'] == true) {
      guestId.value = response['guste_id'].toString(); 
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Failed to send mail: $e");
    return false;
  } finally {
    isLoading.value = false;
  }
}

Future<bool> resetGuestPassword(String password) async {
  try {
    if (guestId.value == '') {
      throw Exception("Guest ID not found");
    }

    isLoading.value = true;

    final result = await _authService.forgotupdateGuestPassword(
      guestId: guestId.value,
      password: password,
    );

    return result;
  } catch (e) {
    print("Reset failed: $e");
    return false;
  } finally {
    isLoading.value = false;
  }
}


  Future<bool> guestResetPassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Replace with your actual API logic
      await _authService.resetGuestPassword(email, oldPassword, newPassword);
      return true;
    } catch (e) {
      print("Guest password reset error: $e");
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
  if (guestId.value == "") {
    print("Guest ID is null");
    return false;
  }

  isLoading.value = true;
  try {
    return await _authService.verifyGuestOtp(guestId.value, otp);
  } finally {
    isLoading.value = false;
  }
}


  Future<bool> logout() async {
    try {
      await _authService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in');
      await prefs.remove('user_id');
      await prefs.remove('is_guest');
      await prefs.remove('role');

      return true;
    } catch (e) {
      print(e);
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
          role: 'Guest Member',
          data: UserData(
            id: guestModel.value!.data!.id!.toString(),
            isGuest: 1,
          ),
        );

        CustomSnackbars.success("Registration Successful", "Welcome to KOTA");
        return true;
      } else {
        CustomSnackbars.warning(
          "Registration Failed",
          result.message ?? 'Failed',
        );
        return false;
      }
    } catch (e) {
      CustomSnackbars.oops(e.toString(), "Oops");
      return false;
    }
  }
}
