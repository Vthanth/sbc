import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/pages/widgets/ticket_card.dart';
import 'package:sbccapp/stores/completed_tickets_page.store.dart';

class LoggedTicketsPage extends StatefulWidget {
  const LoggedTicketsPage({super.key});

  @override
  State<LoggedTicketsPage> createState() => _LoggedTicketsPageState();
}

class _LoggedTicketsPageState extends State<LoggedTicketsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _store = locator<CompletedTicketsPageStore>();

  @override
  void initState() {
    _store.loadCompletedTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tickets'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      drawer: SideDrawer(isHomeSelected: false),
      body: Observer(
        builder: (_) {
          return _store.completedTickets.maybeWhen(
            (list) {
              if (list.isEmpty) {
                return const Center(child: Text('No logged tickets found'));
              }
              return RefreshIndicator(
                onRefresh: _store.loadCompletedTickets,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: list[index]);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
