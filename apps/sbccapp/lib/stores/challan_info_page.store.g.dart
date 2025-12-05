// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challan_info_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChallanInfoPageStore on _ChallanInfoPageStore, Store {
  late final _$challanServicesAtom = Atom(
    name: '_ChallanInfoPageStore.challanServices',
    context: context,
  );

  @override
  Result<List<ChallanService>> get challanServices {
    _$challanServicesAtom.reportRead();
    return super.challanServices;
  }

  @override
  set challanServices(Result<List<ChallanService>> value) {
    _$challanServicesAtom.reportWrite(value, super.challanServices, () {
      super.challanServices = value;
    });
  }

  late final _$challanServiceDetailAtom = Atom(
    name: '_ChallanInfoPageStore.challanServiceDetail',
    context: context,
  );

  @override
  Result<ChallanServiceDetail> get challanServiceDetail {
    _$challanServiceDetailAtom.reportRead();
    return super.challanServiceDetail;
  }

  @override
  set challanServiceDetail(Result<ChallanServiceDetail> value) {
    _$challanServiceDetailAtom.reportWrite(
      value,
      super.challanServiceDetail,
      () {
        super.challanServiceDetail = value;
      },
    );
  }

  late final _$loadChallanServicesAsyncAction = AsyncAction(
    '_ChallanInfoPageStore.loadChallanServices',
    context: context,
  );

  @override
  Future<void> loadChallanServices() {
    return _$loadChallanServicesAsyncAction.run(
      () => super.loadChallanServices(),
    );
  }

  late final _$loadChallanServiceDetailAsyncAction = AsyncAction(
    '_ChallanInfoPageStore.loadChallanServiceDetail',
    context: context,
  );

  @override
  Future<void> loadChallanServiceDetail(String serviceUuid) {
    return _$loadChallanServiceDetailAsyncAction.run(
      () => super.loadChallanServiceDetail(serviceUuid),
    );
  }

  late final _$_ChallanInfoPageStoreActionController = ActionController(
    name: '_ChallanInfoPageStore',
    context: context,
  );

  @override
  void onChallanServiceTap(ChallanService challanService) {
    final _$actionInfo = _$_ChallanInfoPageStoreActionController.startAction(
      name: '_ChallanInfoPageStore.onChallanServiceTap',
    );
    try {
      return super.onChallanServiceTap(challanService);
    } finally {
      _$_ChallanInfoPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
challanServices: ${challanServices},
challanServiceDetail: ${challanServiceDetail}
    ''';
  }
}
