import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';

part 'challan_info_page.store.g.dart';

class ChallanInfoPageStore = _ChallanInfoPageStore with _$ChallanInfoPageStore;

abstract class _ChallanInfoPageStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  Result<List<ChallanService>> challanServices = Result.none();

  @observable
  Result<ChallanServiceDetail> challanServiceDetail = Result.none();

  @action
  Future<void> loadChallanServices() async {
    challanServices = Result.loading();
    try {
      final services = await _userRepository.getUserChallanServices();
      challanServices = Result(services);
    } catch (e) {
      challanServices = Result.error(error: e);
    }
  }

  @action
  Future<void> loadChallanServiceDetail(String serviceUuid) async {
    challanServiceDetail = Result.loading();
    try {
      final detail = await _userRepository.getChallanServiceDetail(serviceUuid: serviceUuid);
      challanServiceDetail = Result(detail);
    } catch (e) {
      challanServiceDetail = Result.error(error: e);
    }
  }

  @action
  void onChallanServiceTap(ChallanService challanService) {
    // print('Challan Service tapped: ${challanService.serviceUuid}');
    // print('Customer: ${challanService.customerName}');
    // print('Product: ${challanService.productModelNo} - ${challanService.productSerialNo}');
    // print('Subject: ${challanService.ticketSubject}');
  }
}
