import 'dart:io';
import 'dart:typed_data';

import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';

class UserRepositoryImpl implements UserRepository {
  final UserNetworkService _userNetworkService;
  final InstantLocalPersistenceService _instantLocalPersistenceService;

  UserRepositoryImpl(this._userNetworkService, this._instantLocalPersistenceService);

  @override
  Future<LoginResponse?> loginUserAndSaveBearerToken({required String email, required String password}) async {
    final deviceUuid = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_DEVICE_UUID);
    if (deviceUuid == null) {
      return null;
    }
    final loginResponse = await _userNetworkService.loginUserAndGetBearerToken(
      email: email,
      password: password,
      deviceUuid: deviceUuid,
    );
    if (loginResponse == null) {
      return null;
    }
    await _instantLocalPersistenceService.setString(SHARED_PREFERENCE_KEY_BEARER_TOKEN, loginResponse.token);
    final role = loginResponse.role;
    if (role != null && role.trim().isNotEmpty) {
      await _instantLocalPersistenceService.setString(SHARED_PREFERENCE_KEY_USER_ROLE, role);
    } else {
      await _instantLocalPersistenceService.remove(SHARED_PREFERENCE_KEY_USER_ROLE);
    }
    return loginResponse;
  }

  @override
  Future<void> logoutUser({required String bearerToken}) async {
    await _userNetworkService.logout(bearerToken: bearerToken);
  }

  @override
  Future<User?> getUser() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    final user = await _userNetworkService.getUser(bearerToken: bearerToken);
    if (user != null) {
      await _instantLocalPersistenceService.setString(SHARED_PREFERENCE_KEY_USER_NAME, user.name ?? '');
      await _instantLocalPersistenceService.setString(SHARED_PREFERENCE_KEY_USER_EMAIL, user.email ?? '');
    }
    return user;
  }

  @override
  Future<List<Ticket>> getTickets() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return [];
    }
    return _userNetworkService.getTickets(bearerToken: bearerToken);
  }

  @override
  Future<List<Ticket>> getCompletedTickets() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return [];
    }
    return _userNetworkService.getCompletedTickets(bearerToken: bearerToken);
  }

  @override
  Future<void> startDeliveryTicket({
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  }) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    return _userNetworkService.startDeliveryTicket(
      bearerToken: bearerToken,
      ticketUuid: ticketUuid,
      deliveryChallanData: deliveryChallanData,
    );
  }

  @override
  Future<void> endDeliveryTicket({required String ticketUuid, required DeliveryChallanData deliveryChallanData}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    return _userNetworkService.endDeliveryTicket(
      bearerToken: bearerToken,
      ticketUuid: ticketUuid,
      deliveryChallanData: deliveryChallanData,
    );
  }

  @override
  Future<void> startServiceTicket({required String ticketUuid, required ServiceChallanData serviceChallanData}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    return _userNetworkService.startServiceTicket(
      bearerToken: bearerToken,
      ticketUuid: ticketUuid,
      serviceChallanData: serviceChallanData,
    );
  }

  @override
  Future<void> endServiceTicket({required String ticketUuid, required ServiceChallanData serviceChallanData}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    await _userNetworkService.endServiceTicket(
      ticketUuid: ticketUuid,
      serviceChallanData: serviceChallanData,
      bearerToken: bearerToken,
    );
  }

  @override
  Future<User?> updateProfileData({required String name, required String email, required String phoneNumber}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    return _userNetworkService.updateProfileData(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      bearerToken: bearerToken,
    );
  }

  @override
  Future<User?> updateProfilePhotos({
    required String userId,
    required File? profileImage,
    required File? qrCodeImage,
  }) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    return _userNetworkService.updateProfilePhotos(
      userId: userId,
      profileImage: profileImage,
      qrCodeImage: qrCodeImage,
      bearerToken: bearerToken,
    );
  }

  @override
  Future<Uint8List?> getQRCode() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    return _userNetworkService.getQRCode(bearerToken: bearerToken);
  }

  @override
  Future<bool> isUserAuthenticated() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return false;
    }
    return _userNetworkService.isUserAuthenticated(bearerToken: bearerToken);
  }

  @override
  Future<void> uploadMultipleTicketImages({required String ticketUuid, required List<File> images}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    return _userNetworkService.uploadMultipleTicketImages(
      ticketUuid: ticketUuid,
      images: images,
      bearerToken: bearerToken,
    );
  }

  @override
  Future<List<ChallanService>> getUserChallanServices() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return [];
    }
    return _userNetworkService.getUserChallanServices(bearerToken: bearerToken);
  }

  @override
  Future<ChallanServiceDetail> getChallanServiceDetail({required String serviceUuid}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      throw Exception('Bearer token not found');
    }
    return _userNetworkService.getChallanServiceDetail(bearerToken: bearerToken, serviceUuid: serviceUuid);
  }

  @override
  Future<ProductQr> getProductDetailsByProductId({required String productId}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      throw Exception('Bearer token not found');
    }
    return _userNetworkService.getProductDetailsByProductId(bearerToken: bearerToken, productId: productId);
  }

  @override
  Future<List<Expense>> getExpenses() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return [];
    }
    return _userNetworkService.getExpenses(bearerToken: bearerToken);
  }

  @override
  Future<void> createExpense({
    required String date,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      throw Exception('Bearer token not found');
    }
    return _userNetworkService.createExpense(
      bearerToken: bearerToken,
      date: date,
      amount: amount,
      details: details,
      paidBy: paidBy,
      imageFile: imageFile,
    );
  }

  @override
  Future<void> updateExpense({
    required int id,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      throw Exception('Bearer token not found');
    }
    return _userNetworkService.updateExpense(
      bearerToken: bearerToken,
      id: id,
      amount: amount,
      details: details,
      paidBy: paidBy,
      imageFile: imageFile,
    );
  }
}
