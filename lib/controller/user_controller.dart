import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/user_api_services.dart';
import 'package:kota/model/profile_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';

class UserController extends GetxController {
  final _apiService = UserApiService();

  var user = Rxn<User>();
  var isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  var error = ''.obs;

  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Original snapshot to compare for changes
  late User _originalUser;
  var isChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();

    // Listen for changes
    firstNameController.addListener(_checkForChanges);
    lastNameController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
  }

  void setProfileImage(File imageFile) {
  selectedImage.value = imageFile;
}

void clearFields(){
  selectedImage.value = null;
}

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _apiService.fetchUserProfile();
      user.value = response;
      _originalUser = response;

      // Populate controllers
      firstNameController.text = response.firstName!;
      lastNameController.text = response.lastName!;
      phoneController.text = response.primaryNumber!;
      emailController.text = response.email!;

      isChanged.value = false;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
  isLoading.value = true;
  error.value = '';

  try {
    await _apiService.updateProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      primaryNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      image: selectedImage.value, // nullable File?
    );

    // Re-fetch updated profile
    await loadUserProfile();

    // Optionally, clear the temp image after update
    selectedImage.value = null;

    // Show success feedback
    CustomSnackbars.success( "Your profile has been successfully updated.","Profile updated");

    // Navigate away or update view
    Get.back(); 
  } catch (e) {
    error.value = e.toString();
    CustomSnackbars.oops(e.toString(),"Update failed");
  } finally {
    isLoading.value = false;
  }
}

  void _checkForChanges() {
    isChanged.value =
        firstNameController.text != _originalUser.firstName ||
        lastNameController.text != _originalUser.lastName ||
        phoneController.text != _originalUser.primaryNumber ||
        emailController.text != _originalUser.email;
  }

  // Future<void> updateProfile() async {
  //   // Update logic goes here
  //   final updatedUser = _originalUser.copyWith(
  //     firstName: firstNameController.text,
  //     lastName: lastNameController.text,
  //     primaryNumber: phoneController.text,
  //     email: emailController.text,
  //   );

  //   // Simulate update
  //   user.value = updatedUser;
  //   _originalUser = updatedUser;
  //   isChanged.value = false;
  //   CustomSnackbars.success("Profile updated", "");
  // }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
