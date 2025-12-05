// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_tickets_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CompletedTicketsPageStore on _CompletedTicketsPageStore, Store {
  late final _$completedTicketsAtom = Atom(
    name: '_CompletedTicketsPageStore.completedTickets',
    context: context,
  );

  @override
  Result<List<Ticket>> get completedTickets {
    _$completedTicketsAtom.reportRead();
    return super.completedTickets;
  }

  @override
  set completedTickets(Result<List<Ticket>> value) {
    _$completedTicketsAtom.reportWrite(value, super.completedTickets, () {
      super.completedTickets = value;
    });
  }

  late final _$loadCompletedTicketsAsyncAction = AsyncAction(
    '_CompletedTicketsPageStore.loadCompletedTickets',
    context: context,
  );

  @override
  Future<void> loadCompletedTickets() {
    return _$loadCompletedTicketsAsyncAction.run(
      () => super.loadCompletedTickets(),
    );
  }

  @override
  String toString() {
    return '''
completedTickets: ${completedTickets}
    ''';
  }
}
