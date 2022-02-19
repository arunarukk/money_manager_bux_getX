import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/transactions/screen_transaction.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> filteredTransactionListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<double>> totalAllTransactionListNotifier =
      ValueNotifier([]);

  ValueNotifier<double> incomeTransactionListNotifier =
      ValueNotifier<double>(0);
  ValueNotifier<double> expenseTransactionListNotifier =
      ValueNotifier<double>(0);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    // print(_list.toList());
    //pieData();
    getTotalAmount();
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);

    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }

  Future<List<TransactionModel>> filterAllTransaction(
      DateTime? startKey, DateTime? endKey) async {
    final _list = await getAllTransactions();
    List<TransactionModel> _newList = [];
    if (startKey != null || endKey != null) {
      for (TransactionModel data in _list) {
        if (data.date.isAfter(startKey!) && data.date.isBefore(endKey!) ||
            data.date == startKey ||
            data.date == endKey) {
          _newList.add(data);
          
        }
      }
    }
    _newList.sort((first, second) => second.date.compareTo(first.date));
    filteredTransactionListNotifier.value.clear();
    filteredTransactionListNotifier.value.addAll(_newList);
    filteredTransactionListNotifier.notifyListeners();

    return _newList;
  }

  Future getTotalAmount() async {
    List<TransactionModel> entireData = await getAllTransactions();
    double _income = 0;
    double _expense = 0;
    List<double> totalAmount = [];
    for (TransactionModel data in entireData) {
      if (data.type == CategoryType.income) {
        _income += data.amount;
      } else {
        _expense += data.amount;
      }
      print('get total');
    }
    totalAmount.add(_income);
    totalAmount.add(_expense);
    //print(totalAmount);
    totalAllTransactionListNotifier.value.clear();
    incomeTransactionListNotifier.value = totalAmount.first;
    expenseTransactionListNotifier.value = totalAmount.last;
    totalAllTransactionListNotifier.value.addAll(totalAmount);
    incomeTransactionListNotifier.notifyListeners();
    expenseTransactionListNotifier.notifyListeners();
  }
  // Future<Map<String, double>> pieData() async {
  //   List<TransactionModel> data = await getAllTransactions();
  //   Map<String, double> result =
  //       Map.fromIterable(data, key: (v) => v.purpose, value: (v) => v.amount);
  //   print(result);
  //   if (result.isEmpty) {
  //     return result;
  //   } else {
  //     return result;
  //   }
  // }
}
