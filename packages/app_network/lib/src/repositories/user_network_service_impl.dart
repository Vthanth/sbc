import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_models/models.dart';
import 'package:app_network/app_network.dart';
import 'package:app_network/src/client/base_network_service.dart';
import 'package:app_services/services.dart';

class UserNetworkServiceImpl extends BaseNetworkService implements UserNetworkService {
  UserNetworkServiceImpl(AppClient client, NetworkConfigBase config) : super(client, config.apiEndPoint);

  String _extractErrorMessage(dynamic error) {
    try {
      if (error is String) {
        final jsonData = jsonDecode(error);
        return jsonData['message'] ?? error;
      } else if (error is Exception) {
        final errorString = error.toString();
        if (errorString.contains('{')) {
          final jsonData = jsonDecode(errorString.replaceAll('Exception: ', ''));
          return jsonData['message'] ?? errorString;
        }
        return errorString;
      }
      return error.toString();
    } catch (e) {
      return error.toString();
    }
  }

  @override
  Future<LoginResponse?> loginUserAndGetBearerToken({
    required String email,
    required String password,
    required String deviceUuid,
  }) async {
    final requestUrl = '${host}login';

    Map<String, dynamic> params = {"email": email, "password": password, "uid": deviceUuid};

    try {
      final response = await client.post(requestUrl, body: params, encodeJson: false);
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        if (body['token'] != null) {
          final isApprovalRequired = (body['approval_required'] as String).toLowerCase() == 'yes';
          final role = body['role'] as String?;
          return LoginResponse(token: body['token'], isApprovalRequired: isApprovalRequired, role: role);
        } else {
          throw body['message'];
        }
      } else {
        throw response.body;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> logout({required String bearerToken}) async {
    final requestUrl = '${host}logout';

    try {
      final response = await client.post(
        requestUrl,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(" =======ERROR -> $e");
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<User?> getUser({required String bearerToken}) async {
    final requestUrl = '${host}profile';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return User.fromJson(body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service + $e");
    }
  }

  @override
  Future<List<Ticket>> getTickets({required String bearerToken}) async {
    final requestUrl = '${host}tickets';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return (body["tickets"] as List<dynamic>).map((e) => Ticket.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      final errorMessage = _extractErrorMessage(e);
      throw errorMessage;
    }
  }

  @override
  Future<List<Ticket>> getCompletedTickets({required String bearerToken}) async {
    final requestUrl = '${host}recentcompletedtickets';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return (body["tickets"] as List<dynamic>).map((e) => Ticket.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while calling the network service - get recentcompletedtickets");
    }
  }

  @override
  Future<void> startDeliveryTicket({
    required String bearerToken,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  }) async {
    final requestUrl = '${host}tickets/$ticketUuid';

    final currentTime = DateTime.now().toIso8601String().split('.').first;

    final parameters = {'type': 'delivery', 'start': currentTime, 'data': jsonEncode(deliveryChallanData.toJson())};

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> endDeliveryTicket({
    required String bearerToken,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  }) async {
    final requestUrl = '${host}tickets/$ticketUuid';

    final currentTime = DateTime.now().toIso8601String().split('.').first;

    final parameters = {
      'type': 'delivery',
      'end': currentTime,
      'data': jsonEncode(deliveryChallanData.toJson()),
      'log': deliveryChallanData.log,
    };

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> startServiceTicket({
    required String bearerToken,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  }) async {
    final requestUrl = '${host}tickets/$ticketUuid';

    final currentTime = DateTime.now().toIso8601String().split('.').first;

    Map<String, dynamic> parameters = {
      'type': 'service',
      'start': currentTime,
      'data': jsonEncode(serviceChallanData.toJson()),
    };

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );

      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> endServiceTicket({
    required String bearerToken,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  }) async {
    final requestUrl = '${host}tickets/$ticketUuid';

    final currentTime = DateTime.now().toIso8601String().split('.').first;

    final parameters = {
      'type': 'service',
      'end': currentTime,
      'data': jsonEncode(serviceChallanData.toJson()),
      'log': serviceChallanData.log,
    };

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<User?> updateProfileData({
    required String name,
    required String email,
    required String phoneNumber,
    required String bearerToken,
  }) async {
    final requestUrl = '${host}update-profile';

    var parameters = {'name': name, 'email': email, 'phone_number': phoneNumber};

    try {
      final response = await client.put(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return User.fromJson(body["data"]);
      } else {
        throw Exception(response.body);
      }
    } catch (e, s) {
      print(" =======ERROR -> $e");
      print(" =======STACK TRACE -> $s");
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<User?> updateProfilePhotos({
    required String bearerToken,
    required String userId,
    required File? profileImage,
    required File? qrCodeImage,
  }) async {
    final requestUrl = '${host}upload-photos';

    final profileImageBase64 = profileImage != null ? base64Encode(profileImage.readAsBytesSync()) : null;
    final qrCodeImageBase64 = qrCodeImage != null ? base64Encode(qrCodeImage.readAsBytesSync()) : null;

    var parameters = {"user_id": userId};

    if (profileImageBase64 != null) {
      parameters['profile_photo'] = "data:image/jpeg;base64,$profileImageBase64";
    }

    if (qrCodeImageBase64 != null) {
      parameters['sign_photo'] = "data:image/jpeg;base64,$qrCodeImageBase64";
    }

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);

        if (body['user_id'] != null) {
          body['id'] = body['user_id'];
        }
        return User.fromJson(body);
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<Uint8List?> getQRCode({required String bearerToken}) async {
    final requestUrl = '${host}qrcode';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final responseBody = response.body;
        try {
          final jsonResponse = jsonDecode(responseBody);
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('qr_code')) {
            final qrCodeString = jsonResponse['qr_code'] as String;
            if (qrCodeString.startsWith('data:image/')) {
              final base64Data = qrCodeString.split(',')[1];
              final bytes = base64Decode(base64Data);
              return bytes;
            } else {
              // If it's not a data URL, try to decode as raw base64
              final bytes = base64Decode(qrCodeString);
              return bytes;
            }
          } else {
            throw Exception('QR code field not found in response');
          }
        } catch (jsonError) {
          return response.bodyBytes;
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<bool> isUserAuthenticated({required String bearerToken}) async {
    final requestUrl = '${host}approval-status';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});

      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return body['approved'] as bool? ?? false;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> uploadMultipleTicketImages({
    required String ticketUuid,
    required List<File> images,
    required String bearerToken,
  }) async {
    final requestUrl = '${host}tickets/upload-images';

    Map<String, dynamic> parameters = {"ticket_uuid": ticketUuid};
    var imagesBase64Array = <String>[];
    for (var image in images) {
      final imageBase64 = base64Encode(image.readAsBytesSync());
      imagesBase64Array.add("data:image/jpeg;base64,$imageBase64");
    }

    parameters['images'] = imagesBase64Array;

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: true,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        print(" =======RESPONSE BODY -> $body");
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e, s) {
      print(" =======ERROR -> $e");
      print(" =======STACK TRACE -> $s");
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<List<ChallanService>> getUserChallanServices({required String bearerToken}) async {
    final requestUrl = '${host}services';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return (body["data"] as List<dynamic>).map((e) => ChallanService.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      final errorMessage = _extractErrorMessage(e);
      throw errorMessage;
    }
  }

  @override
  Future<ChallanServiceDetail> getChallanServiceDetail({
    required String bearerToken,
    required String serviceUuid,
  }) async {
    final requestUrl = '${host}services/$serviceUuid';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return ChallanServiceDetail.fromJson(body["data"]);
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      final errorMessage = _extractErrorMessage(e);
      throw errorMessage;
    }
  }

  @override
  Future<ProductQr> getProductDetailsByProductId({required String bearerToken, required String productId}) async {
    final requestUrl = 'https://erp.sbccindia.com/api/v1/product_details/$productId';

    print(" =======REQUEST URL -> $requestUrl");

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        print(" =======RESPONSE BODY -> $body");
        if (body['data'] != null) {
          return ProductQr.fromJson(body["data"]);
        } else {
          throw Exception('Invalid response format or order not found');
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      final errorMessage = _extractErrorMessage(e);
      throw errorMessage;
    }
  }
  @override
  Future<List<Expense>> getExpenses({required String bearerToken}) async {
    final requestUrl = '${host}expenses';
    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        final List<dynamic> dataList = body["data"];
        return dataList.map((e) => Expense.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  @override
  Future<void> createExpense({
    required String bearerToken,
    required String date,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    final requestUrl = '${host}expenses';

    String? imageBase64;
    if (imageFile != null) {
      // Image picker se aayi file ko Base64 string banata hai
      imageBase64 = "data:image/jpeg;base64,${base64Encode(imageFile.readAsBytesSync())}";
    }

    final body = {
      "expense_date": date,
      "amount": amount,
      "details": details,
      "paid_by": paidBy,
      "receipt_image": imageBase64, // API key 'receipt_image' match karni chahiye
    };

    final response = await client.post(
      requestUrl,
      body: body,
      headers: {"Authorization": "Bearer $bearerToken"},
      encodeJson: false,
    );
    if (!isSuccessful(response.statusCode)) throw Exception(response.body);
  }

  @override
  Future<void> updateExpense({
    required String bearerToken,
    required int id,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    final requestUrl = '${host}expenses/$id';

    String? imageBase64;
    if (imageFile != null) {
      imageBase64 = "data:image/jpeg;base64,${base64Encode(imageFile.readAsBytesSync())}";
    }

    final body = {
      "amount": amount,
      "details": details,
      "paid_by": paidBy,
      "receipt_image": imageBase64,
    };

    final response = await client.put(
      requestUrl,
      body: body,
      headers: {"Authorization": "Bearer $bearerToken"},
      encodeJson: false,
    );
    if (!isSuccessful(response.statusCode)) throw Exception(response.body);
  }
}
