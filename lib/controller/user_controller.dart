import 'package:get/get.dart';
import 'package:kota/apiServices/user_api_services.dart';
import 'package:kota/model/profile_model.dart';

class UserController extends GetxController {
  final _apiService = UserApiService();

  var user = Rxn<User>();
  var isLoading = false.obs;
  var error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // Automatically call the API on controller init
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _apiService.fetchUserProfile();
      user.value = response; 
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
