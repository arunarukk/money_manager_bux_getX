import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  ValueNotifier<List<Customer>> newListNotifier = ValueNotifier([]);

  ValueNotifier<List<Customer>> mylistNotifier = ValueNotifier([]);

  ValueNotifier<Map<String, double>> pieMapNotifier = ValueNotifier({});
  List<TransactionModel> _refList = [];
  DateTime? start;
  DateTime? end;

  DateTime? wafistart;
  DateTime? wafiend;

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    List<TransactionModel> _list = [];

    _list = await filterAllTransaction(wafistart, wafiend);
    _list.sort((first, second) => second.date.compareTo(first.date));
    filteredTransactionListNotifier.value.clear();
    filteredTransactionListNotifier.value.addAll(_list);
    filteredTransactionListNotifier.notifyListeners();

    getTotalAmount();
    pieData();
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
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _list = _db.values.toList();
    final List<TransactionModel> _newList = [];
    //print('notifier${_newList}');

    if (startKey != null || endKey != null) {
      start = startKey!;
      end = endKey!;

      for (TransactionModel data in _list) {
        if (data.date.isAfter(startKey) && data.date.isBefore(endKey) ||
            data.date == startKey ||
            data.date == endKey) {
          _newList.add(data);
        }
      }
    }

    //transactionListNotifier.notifyListeners();

    // filteredTransactionListNotifier.value.clear();
    // filteredTransactionListNotifier.value.addAll(_newList);
    // filteredTransactionListNotifier.notifyListeners();
    //filteredListReturn();

    // print('filreturn${_newList.toList()}');
    return _newList;
  }

  // filteredListReturn() async {
  //   if (_newList == null) {
  //     return;
  //   } else {
  //     return _newList;
  //   }
  // }

  Future getTotalAmount() async {
    // List<TransactionModel> entireData = await getAllTransactions();
    List<TransactionModel> entireData =
        await filterAllTransaction(wafistart, wafiend);
    double _income = 0;
    double _expense = 0;
    List<double> totalAmount = [];
    for (TransactionModel data in entireData) {
      if (data.type == CategoryType.income) {
        _income += data.amount;
      } else {
        _expense += data.amount;
      }
      // print('get total');
    }
    totalAmount.add(_income);
    totalAmount.add(_expense);
    //print(totalAmount);
    //totalAllTransactionListNotifier.value.clear();
    incomeTransactionListNotifier.value = totalAmount.first;
    expenseTransactionListNotifier.value = totalAmount.last;
    //totalAllTransactionListNotifier.value.addAll(totalAmount);

    //incomeTransactionListNotifier.notifyListeners();
    //expenseTransactionListNotifier.notifyListeners();
  }

  pieData() async {
    List<TransactionModel> data =
        await filterAllTransaction(wafistart, wafiend);
    Map<String, double> result = Map.fromIterable(data,
        key: (k) => k.category.name, value: (v) => v.amount);

    if (result == null || result.isEmpty) {
      result = {};
    }
    List<Customer> list = [];
    result.forEach((k, v) => list.add(Customer(k, v)));
    // print(list);

    // pieMapNotifier.value.clear();
    pieMapNotifier.value = result;
    newListNotifier.value = list;
    //pieMapNotifier.notifyListeners();
    //print('pie${pieMapNotifier}');
  }

  wafi(DateTime start, DateTime end) {
    wafistart = start;
    wafiend = end;
    refresh();
  }

  sfPieChart() async {
    List<TransactionModel> entireData =
        await filterAllTransaction(wafistart, wafiend);

    bool flag = true;
    List<Customer> mylist = [];
    for (var i = 0; i < entireData.length; i++) {
      flag = true;
      for (var j = 0; j < mylist.length; j++) {
        if (mylist[j].typeName == entireData[i].category.name) {
          mylist[j].amount += entireData[i].amount;
          flag = false;
          break;
        }
      }
      if (flag == true) {
        mylist.add(Customer(entireData[i].category.name, entireData[i].amount));
      }
    }
    mylistNotifier.value = mylist;
    print('pie cus ${mylist.toList()}');
  }
}

class Customer {
  String typeName;
  double amount;
  Customer(this.typeName, this.amount);
  @override
  String toString() {
    return '{ ${this.typeName}, ${this.amount} }';
  }
}
