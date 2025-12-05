import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/utils/mobx_provider.dart';

part 'user.store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store, Disposable {
  final _userRepository = locator<UserRepository>();

  @observable
  bool isLoggedIn = false;

  @observable
  String errorMessage = "";

  @observable
  User? currentUser;

  @observable
  Result<Uint8List> qrCode = Result.none();

  @observable
  String? userRole;

  @readonly
  String? _userName;

  @readonly
  String? _userEmail;

  @readonly
  bool _isApprovalRequired = false;

  _UserStore() {
    loadProfile();
    loadStoredUserRole();
  }

  @action
  Future<void> login({required String email, required String password}) async {
    // Clear previous error
    errorMessage = "";
    isLoggedIn = false;
    
    try {
      final loginResponse = await _userRepository.loginUserAndSaveBearerToken(email: email, password: password);
      if (loginResponse == null) {
        errorMessage = 'Login failed. Please try again.';
        return;
      }
      isLoggedIn = true;
      errorMessage = ""; // Clear error on success
      _isApprovalRequired = loginResponse.isApprovalRequired;
      userRole = _normalizeRole(loginResponse.role) ?? userRole;
      await loadProfile();
    } catch (e) {
      errorMessage = _extractErrorMessage(e);
      isLoggedIn = false;
    }
  }

  String _extractErrorMessage(dynamic error) {
    try {
      String errorString = error.toString();
      
      // Remove "Exception: " prefix if present
      if (errorString.startsWith('Exception: ')) {
        errorString = errorString.substring(11);
      }
      
      // Try to parse as JSON
      if (errorString.trim().startsWith('{')) {
        try {
          final jsonData = jsonDecode(errorString);
          if (jsonData is Map && jsonData.containsKey('message')) {
            return jsonData['message'].toString();
          }
        } catch (e) {
          // If JSON parsing fails, continue with original string
        }
      }
      
      // Check for common error patterns
      if (errorString.contains('Failed host lookup') || 
          errorString.contains('SocketException') ||
          errorString.contains('Network is unreachable')) {
        return 'Network error: Cannot connect to server. Please check your internet connection.';
      }
      
      if (errorString.contains('401') || 
          errorString.contains('Unauthorized') ||
          errorString.toLowerCase().contains('invalid') ||
          errorString.toLowerCase().contains('credential')) {
        return 'Invalid email or password. Please try again.';
      }
      
      // Return the error string as-is if no special handling needed
      return errorString;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @action
  Future<void> loadProfile() async {
    currentUser = await _userRepository.getUser();
    final profileRole = currentUser?.role;
    if (profileRole != null) {
      final normalizedProfileRole = _normalizeRole(profileRole);
      if (normalizedProfileRole != null && (userRole == null || userRole!.isEmpty)) {
        userRole = normalizedProfileRole;
      }
    }
  }

  @action
  Future<void> loadStoredUserRole() async {
    final storedRole = await locator<InstantLocalPersistenceService>().getString(SHARED_PREFERENCE_KEY_USER_ROLE);
    userRole = _normalizeRole(storedRole);
  }

  @action
  Future<String?> loadUserName() async {
    final userName = await locator<InstantLocalPersistenceService>().getString(SHARED_PREFERENCE_KEY_USER_NAME);
    return userName;
  }

  @action
  Future<String?> loadUserEmail() async {
    final userEmail = await locator<InstantLocalPersistenceService>().getString(SHARED_PREFERENCE_KEY_USER_EMAIL);
    return userEmail;
  }

  @action
  Future<void> logout({required String bearerToken}) async {
    await _userRepository.logoutUser(bearerToken: bearerToken);
    isLoggedIn = false;
    currentUser = null;
    qrCode = Result.none();
    userRole = null;
    await locator<InstantLocalPersistenceService>().remove(SHARED_PREFERENCE_KEY_USER_ROLE);
  }

  @action
  Future<void> updateProfileData({required String name, required String email, required String phoneNumber}) async {
    final updatedUser = await _userRepository.updateProfileData(name: name, email: email, phoneNumber: phoneNumber);
    if (updatedUser != null) {
      currentUser = updatedUser;
    }
  }

  @action
  Future<void> updateProfilePhotos({required File? profileImage, required File? signImage}) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final updatedUser = await _userRepository.updateProfilePhotos(
      userId: user.id.toString(),
      profileImage: profileImage,
      qrCodeImage: signImage,
    );
    final updatedUserObj = user.copyWith(
      profilePhotoUrl: updatedUser?.profilePhotoUrl,
      signPhotoUrl: updatedUser?.signPhotoUrl,
    );
    currentUser = updatedUserObj;
  }

  @action
  Future<void> loadQRCode() async {
    qrCode = Result.loading();
    try {
      final qrCodeData = await _userRepository.getQRCode();
      if (qrCodeData != null) {
        qrCode = Result(qrCodeData);
      } else {
        qrCode = Result.error(error: Exception('Failed to load QR code'));
      }
    } catch (e) {
      qrCode = Result.error(error: e);
    }
  }

  @action
  Future<bool> checkUserAuthentication() async {
    final isApproved = await _userRepository.isUserAuthenticated();
    if (isApproved) {
      await _userRepository.getUser();
      loadUserName();
      loadUserEmail();
    }
    return isApproved;
  }

  String? _normalizeRole(String? role) {
    if (role == null) {
      return null;
    }
    final trimmedRole = role.trim();
    if (trimmedRole.isEmpty) {
      return null;
    }
    return trimmedRole;
  }
}
