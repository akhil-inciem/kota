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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  late User _originalUser;

  var isImageChanged = false.obs;
  var isTextChanged = false.obs;
  var isChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(_checkForChanges);
    lastNameController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
  }

  void setProfileImage(File imageFile) {
    selectedImage.value = imageFile;
    isImageChanged.value = true;
    _updateIsChanged();
  }

  void _updateIsChanged() {
    isChanged.value = isTextChanged.value || isImageChanged.value;
  }

  void clearFields() {
    final currentUser = user.value;
    if (currentUser != null) {
      firstNameController.text = currentUser.firstName ?? '';
      lastNameController.text = currentUser.lastName ?? '';
      phoneController.text = currentUser.primaryNumber ?? '';
      emailController.text = currentUser.email ?? '';
    }

    selectedImage.value = null;
    isImageChanged.value = false;
    isTextChanged.value = false;
    _updateIsChanged();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _apiService.fetchUserProfile();
      user.value = response;
      _originalUser = response;

      firstNameController.text = response.firstName!;
      lastNameController.text = response.lastName!;
      phoneController.text = response.primaryNumber!;
      emailController.text = response.email!;

      isImageChanged.value = false;
      isTextChanged.value = false;
      _updateIsChanged();
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
        image: selectedImage.value,
      );
      await loadUserProfile(); // will also reset flags
      selectedImage.value = null;
      CustomSnackbars.success(
        "Your profile has been successfully updated.",
        "Profile updated",
      );
      Get.back();
    } catch (e) {
      error.value = e.toString();
      CustomSnackbars.oops(e.toString(), "Update failed");
    } finally {
      isLoading.value = false;
    }
  }

  void _checkForChanges() {
    isTextChanged.value =
        firstNameController.text != _originalUser.firstName ||
        lastNameController.text != _originalUser.lastName ||
        phoneController.text != _originalUser.primaryNumber ||
        emailController.text != _originalUser.email;
        _updateIsChanged();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
