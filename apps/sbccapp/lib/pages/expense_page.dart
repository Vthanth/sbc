import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/pages/expense_add_page.dart';
import 'package:sbccapp/stores/expense.store.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _store = locator<ExpenseStore>();

  @override
  void initState() {
    _store.fetchExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: AppBar(
        backgroundColor: ThemeColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeColors.primaryBlack),
        title: Text(
          'Expense Claims',
          style: ThemeFonts.text20Bold(textColor: ThemeColors.primaryBlack),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: ThemeColors.primaryBlack),
            onPressed: () => _store.fetchExpenses(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpensePage())),
        backgroundColor: ThemeColors.themeBlue,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: _MainContent(store: _store),
    );
  }
}

class _MainContent extends StatelessWidget {
  final ExpenseStore store;
  const _MainContent({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return store.expenses.maybeWhen(
              (list) => _ExpenseListContent(expenses: list, store: store),
          loading: () => const _LoadingView(),
          error: (error, message) => _ErrorView(error: message ?? error.toString()),
          orElse: () => const SizedBox(),
        );
      },
    );
  }
}

class _ExpenseListContent extends StatelessWidget {
  final List<Expense> expenses;
  final ExpenseStore store;

  const _ExpenseListContent({required this.expenses, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.primarySand,
      child: expenses.isEmpty
          ? const _EmptyStateView()
          : RefreshIndicator(
        onRefresh: store.fetchExpenses,
        color: ThemeColors.themeBlue,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddExpensePage(existingExpense: expense),
                  ),
                ).then((value) {
                  if (value == true) {
                    store.fetchExpenses();
                  }
                });
              },
              child: _ExpenseCard(expense: expense),
            );
          },
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  const _ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 16, color: ThemeColors.themeBlue),
                    const SizedBox(width: 8),
                    Text(
                      "ID: #${expense.id}",
                      style: ThemeFonts.text12Bold(textColor: ThemeColors.themeBlue),
                    ),
                  ],
                ),
                Text(
                  expense.expenseDate?.split('T').first ?? '',
                  style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "₹ ${expense.amount}",
              style: ThemeFonts.text18Bold(textColor: ThemeColors.primaryBlack),
            ),
            const SizedBox(height: 4),
            Text(
              expense.details ?? 'No details provided',
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: expense.isApproved ? Colors.green : ThemeColors.themeYellow,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  expense.isApproved ? "Approved" : "Pending",
                  style: ThemeFonts.text12Bold(
                    textColor: expense.isApproved ? Colors.green : ThemeColors.themeYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue),
        strokeWidth: 3,
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 64, color: ThemeColors.midGrey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text("No expenses found", style: ThemeFonts.text18(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: ThemeColors.notificationRed, size: 48),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center, style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack)),
          ],
        ),
      ),
    );
  }
}