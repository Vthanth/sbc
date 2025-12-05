import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';

part 'product_details.store.g.dart';

class ProductDetailsStore = _ProductDetailsStore with _$ProductDetailsStore;

abstract class _ProductDetailsStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  Result<ProductQr> productQr = Result.none();

  @action
  Future<void> loadProductDetailsByProductId(String productId) async {
    productQr = Result.loading();
    try {
      final ticketDetails = await _userRepository.getProductDetailsByProductId(productId: productId);
      productQr = Result(ticketDetails);
    } catch (e) {
      productQr = Result.error(error: e);
    }
  }
}
