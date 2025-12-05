import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';

part 'completed_tickets_page.store.g.dart';

class CompletedTicketsPageStore = _CompletedTicketsPageStore with _$CompletedTicketsPageStore;

abstract class _CompletedTicketsPageStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  Result<List<Ticket>> completedTickets = Result.none();

  @action
  Future<void> loadCompletedTickets() async {
    completedTickets = Result.loading();
    try {
      final tickets = await _userRepository.getCompletedTickets();
      completedTickets = Result(tickets);
    } catch (e) {
      completedTickets = Result.error(error: e);
    }
  }
}
