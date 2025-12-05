import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';

part 'home_page.store.g.dart';

class HomePageStore = _HomePageStore with _$HomePageStore;

abstract class _HomePageStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  Result<List<Ticket>> orders = Result.none();

  @observable
  String currentRole = '';

  @observable
  bool isLoading = false;

  @action
  Future<void> loadOrders() async {
    orders = Result.loading();
    try {
      final tickets = await _userRepository.getTickets();
      orders = Result(tickets);
    } catch (e) {
      orders = Result.error(error: e, message: e.toString());
    }
  }
}
