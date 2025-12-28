import 'dart:io';

import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';

part 'expense.store.g.dart';

class ExpenseStore = _ExpenseStore with _$ExpenseStore;

abstract class _ExpenseStore with Store {
  final _userRepository = locator<UserRepository>();

  @observable
  Result<List<Expense>> expenses = Result.none();

  @action
  Future<void> fetchExpenses() async {
    expenses = Result.loading();
    try {
      final result = await _userRepository.getExpenses();
      expenses = Result(result);
    } catch (e) {
      expenses = Result.error(error: e, message: e.toString());
    }
  }

  @action
  Future<void> createExpense({
    required String date,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    try {
      await _userRepository.createExpense(
        date: date,
        amount: amount,
        details: details,
        paidBy: paidBy,
        imageFile: imageFile,
      );
      await fetchExpenses();
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> updateExpense({
    required int id,
    required String amount,
    required String details,
    required String paidBy,
    File? imageFile,
  }) async {
    try {
      await _userRepository.updateExpense(
        id: id,
        amount: amount,
        details: details,
        paidBy: paidBy,
        imageFile: imageFile,
      );
      await fetchExpenses();
    } catch (e) {
      rethrow;
    }
  }
}