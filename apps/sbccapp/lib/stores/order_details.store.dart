import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/helper/geolocator_helper.dart';

part 'order_details.store.g.dart';

/// Get current time in IST (Indian Standard Time, UTC+5:30)
DateTime _getISTTime() {
  final utcNow = DateTime.now().toUtc();
  // IST is UTC+5:30 (5 hours and 30 minutes)
  return utcNow.add(const Duration(hours: 5, minutes: 30));
}

class OrderDetailsStore = _OrderDetailsStore with _$OrderDetailsStore;

abstract class _OrderDetailsStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  bool isUpdatingTicket = false;

  @observable
  Result<Ticket> ticket = Result.none();

  @action
  Future<void> loadTicketDetails(String ticketUuid) async {
    ticket = Result.loading();
    try {
      final tickets = await _userRepository.getTickets();
      final ticketDetails = tickets.firstWhere((t) => t.uuid == ticketUuid);
      ticket = Result(ticketDetails);
    } catch (e) {
      ticket = Result.error(error: e);
    }
  }

  @action
  Future<void> startDeliveryTicket({required BuildContext context, required String ticketUuid}) async {
    isUpdatingTicket = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final deliveryChallanData = DeliveryChallanData(
        startDateTime: _getISTTime(),
        startLocationLat: position.latitude,
        startLocationLong: position.longitude,
        startLocationName: position.address,
      );
      await _userRepository.startDeliveryTicket(ticketUuid: ticketUuid, deliveryChallanData: deliveryChallanData);
      await loadTicketDetails(ticketUuid);
    } catch (e) {
      // Handle error
    } finally {
      isUpdatingTicket = false;
    }
  }

  @action
  Future<void> startServiceTicket({required BuildContext context, required String ticketUuid}) async {
    isUpdatingTicket = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final serviceChallanData = ServiceChallanData(
        startDateTime: _getISTTime(),
        startLocationLat: position.latitude,
        startLocationLong: position.longitude,
        startLocationName: position.address,
        contactPersonName: 'customer',
      );
      await _userRepository.startServiceTicket(ticketUuid: ticketUuid, serviceChallanData: serviceChallanData);
      await loadTicketDetails(ticketUuid);
    } catch (e) {
      // Handle error
    } finally {
      isUpdatingTicket = false;
    }
  }

  @action
  Future<void> endDeliveryTicket({
    required BuildContext context,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  }) async {
    isUpdatingTicket = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final deliveryChallanDataUpdated = deliveryChallanData.copyWith(
        endDateTime: DateTime.now(),
        endLocationLat: position.latitude,
        endLocationLong: position.longitude,
        endLocationName: position.address,
        deliveredBy: "ABC",
      );
      await _userRepository.endDeliveryTicket(ticketUuid: ticketUuid, deliveryChallanData: deliveryChallanDataUpdated);
      await loadTicketDetails(ticketUuid);
    } catch (e) {
      // Handle error
    } finally {
      isUpdatingTicket = false;
    }
  }

  @action
  Future<void> endServiceTicket({
    required BuildContext context,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  }) async {
    isUpdatingTicket = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final serviceChallanDataUpdated = serviceChallanData.copyWith(
        endDateTime: DateTime.now(),
        endLocationLat: position.latitude,
        endLocationLong: position.longitude,
        endLocationName: position.address,
      );
      await _userRepository.endServiceTicket(ticketUuid: ticketUuid, serviceChallanData: serviceChallanDataUpdated);
      await loadTicketDetails(ticketUuid);
    } catch (e) {
      // Handle error
    } finally {
      isUpdatingTicket = false;
    }
  }
}
