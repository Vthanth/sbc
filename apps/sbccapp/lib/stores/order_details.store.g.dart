// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderDetailsStore on _OrderDetailsStore, Store {
  late final _$isUpdatingTicketAtom = Atom(
    name: '_OrderDetailsStore.isUpdatingTicket',
    context: context,
  );

  @override
  bool get isUpdatingTicket {
    _$isUpdatingTicketAtom.reportRead();
    return super.isUpdatingTicket;
  }

  @override
  set isUpdatingTicket(bool value) {
    _$isUpdatingTicketAtom.reportWrite(value, super.isUpdatingTicket, () {
      super.isUpdatingTicket = value;
    });
  }

  late final _$ticketAtom = Atom(
    name: '_OrderDetailsStore.ticket',
    context: context,
  );

  @override
  Result<Ticket> get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(Result<Ticket> value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$loadTicketDetailsAsyncAction = AsyncAction(
    '_OrderDetailsStore.loadTicketDetails',
    context: context,
  );

  @override
  Future<void> loadTicketDetails(String ticketUuid) {
    return _$loadTicketDetailsAsyncAction.run(
      () => super.loadTicketDetails(ticketUuid),
    );
  }

  late final _$startDeliveryTicketAsyncAction = AsyncAction(
    '_OrderDetailsStore.startDeliveryTicket',
    context: context,
  );

  @override
  Future<void> startDeliveryTicket({
    required BuildContext context,
    required String ticketUuid,
  }) {
    return _$startDeliveryTicketAsyncAction.run(
      () => super.startDeliveryTicket(context: context, ticketUuid: ticketUuid),
    );
  }

  late final _$startServiceTicketAsyncAction = AsyncAction(
    '_OrderDetailsStore.startServiceTicket',
    context: context,
  );

  @override
  Future<void> startServiceTicket({
    required BuildContext context,
    required String ticketUuid,
  }) {
    return _$startServiceTicketAsyncAction.run(
      () => super.startServiceTicket(context: context, ticketUuid: ticketUuid),
    );
  }

  late final _$endDeliveryTicketAsyncAction = AsyncAction(
    '_OrderDetailsStore.endDeliveryTicket',
    context: context,
  );

  @override
  Future<void> endDeliveryTicket({
    required BuildContext context,
    required String ticketUuid,
    required DeliveryChallanData deliveryChallanData,
  }) {
    return _$endDeliveryTicketAsyncAction.run(
      () => super.endDeliveryTicket(
        context: context,
        ticketUuid: ticketUuid,
        deliveryChallanData: deliveryChallanData,
      ),
    );
  }

  late final _$endServiceTicketAsyncAction = AsyncAction(
    '_OrderDetailsStore.endServiceTicket',
    context: context,
  );

  @override
  Future<void> endServiceTicket({
    required BuildContext context,
    required String ticketUuid,
    required ServiceChallanData serviceChallanData,
  }) {
    return _$endServiceTicketAsyncAction.run(
      () => super.endServiceTicket(
        context: context,
        ticketUuid: ticketUuid,
        serviceChallanData: serviceChallanData,
      ),
    );
  }

  @override
  String toString() {
    return '''
isUpdatingTicket: ${isUpdatingTicket},
ticket: ${ticket}
    ''';
  }
}
