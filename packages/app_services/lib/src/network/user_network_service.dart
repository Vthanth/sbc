import 'dart:io';
import 'dart:typed_data';

import 'package:app_models/models.dart';

abstract class UserNetworkService {
  Future<LoginResponse?> loginUserAndGetBearerToken({
    required String email,
    required String password,
    required String deviceUuid,
  });
  Future<void> logout({required String bearerToken});
  Future<User?> getUser({required String bearerToken});
  Future<List<Ticket>> getTickets({required String bearerToken});
  Future<List<Ticket>> getCompletedTickets({required String bearerToken});
  Future<void> startDeliveryTicket({
    required String bearerToken,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  });
  Future<void> endDeliveryTicket({
    required String bearerToken,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  });
  Future<void> startServiceTicket({
    required String bearerToken,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  });
  Future<void> endServiceTicket({
    required String bearerToken,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  });

  Future<User?> updateProfileData({
    required String name,
    required String email,
    required String phoneNumber,
    required String bearerToken,
  });

  Future<User?> updateProfilePhotos({
    required String userId,
    required File? profileImage,
    required File? qrCodeImage,
    required String bearerToken,
  });
  Future<Uint8List?> getQRCode({required String bearerToken});

  Future<bool> isUserAuthenticated({required String bearerToken});

  Future<void> uploadMultipleTicketImages({
    required String ticketUuid,
    required List<File> images,
    required String bearerToken,
  });

  Future<List<ChallanService>> getUserChallanServices({required String bearerToken});

  Future<ChallanServiceDetail> getChallanServiceDetail({required String bearerToken, required String serviceUuid});

  Future<ProductQr> getProductDetailsByProductId({required String bearerToken, required String productId});
}
