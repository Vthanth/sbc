import 'dart:io';
import 'dart:typed_data';

import 'package:app_models/models.dart';

abstract class UserRepository {
  Future<LoginResponse?> loginUserAndSaveBearerToken({required String email, required String password});
  Future<void> logoutUser({required String bearerToken});
  Future<User?> getUser();
  Future<List<Ticket>> getTickets();
  Future<List<Ticket>> getCompletedTickets();
  Future<void> startDeliveryTicket({required String ticketUuid, required DeliveryChallanData deliveryChallanData});
  Future<void> endDeliveryTicket({required String ticketUuid, required DeliveryChallanData deliveryChallanData});
  Future<void> startServiceTicket({required String ticketUuid, required ServiceChallanData serviceChallanData});
  Future<void> endServiceTicket({required String ticketUuid, required ServiceChallanData serviceChallanData});
  Future<User?> updateProfileData({required String name, required String email, required String phoneNumber});
  Future<User?> updateProfilePhotos({required String userId, required File? profileImage, required File? qrCodeImage});
  Future<Uint8List?> getQRCode();
  Future<bool> isUserAuthenticated();
  Future<void> uploadMultipleTicketImages({required String ticketUuid, required List<File> images});
  Future<List<ChallanService>> getUserChallanServices();
  Future<ChallanServiceDetail> getChallanServiceDetail({required String serviceUuid});
  Future<ProductQr> getProductDetailsByProductId({required String productId});
}
