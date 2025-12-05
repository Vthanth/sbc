// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductDetailsStore on _ProductDetailsStore, Store {
  late final _$productQrAtom = Atom(
    name: '_ProductDetailsStore.productQr',
    context: context,
  );

  @override
  Result<ProductQr> get productQr {
    _$productQrAtom.reportRead();
    return super.productQr;
  }

  @override
  set productQr(Result<ProductQr> value) {
    _$productQrAtom.reportWrite(value, super.productQr, () {
      super.productQr = value;
    });
  }

  late final _$loadProductDetailsByProductIdAsyncAction = AsyncAction(
    '_ProductDetailsStore.loadProductDetailsByProductId',
    context: context,
  );

  @override
  Future<void> loadProductDetailsByProductId(String productId) {
    return _$loadProductDetailsByProductIdAsyncAction.run(
      () => super.loadProductDetailsByProductId(productId),
    );
  }

  @override
  String toString() {
    return '''
productQr: ${productQr}
    ''';
  }
}
