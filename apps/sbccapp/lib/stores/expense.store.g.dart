// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExpenseStore on _ExpenseStore, Store {
  late final _$expensesAtom = Atom(
    name: '_ExpenseStore.expenses',
    context: context,
  );

  @override
  Result<List<Expense>> get expenses {
    _$expensesAtom.reportRead();
    return super.expenses;
  }

  @override
  set expenses(Result<List<Expense>> value) {
    _$expensesAtom.reportWrite(value, super.expenses, () {
      super.expenses = value;
    });
  }

  late final _$fetchExpensesAsyncAction = AsyncAction(
    '_ExpenseStore.fetchExpenses',
    context: context,
  );

  @override
  Future<void> fetchExpenses() {
    return _$fetchExpensesAsyncAction.run(() => super.fetchExpenses());
  }

  late final _$createExpenseAsyncAction = AsyncAction(
    '_ExpenseStore.createExpense',
    context: context,
  );

  @override
  Future<void> createExpense({
    required String date,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) {
    return _$createExpenseAsyncAction.run(
      () => super.createExpense(
        date: date,
        amount: amount,
        details: details,
        paidBy: paidBy,
        imageFile: imageFile,
      ),
    );
  }

  late final _$updateExpenseAsyncAction = AsyncAction(
    '_ExpenseStore.updateExpense',
    context: context,
  );

  @override
  Future<void> updateExpense({
    required int id,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) {
    return _$updateExpenseAsyncAction.run(
      () => super.updateExpense(
        id: id,
        amount: amount,
        details: details,
        paidBy: paidBy,
        imageFile: imageFile,
      ),
    );
  }

  @override
  String toString() {
    return '''
expenses: ${expenses}
    ''';
  }
}
