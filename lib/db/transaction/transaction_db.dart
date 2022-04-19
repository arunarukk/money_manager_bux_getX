import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

class transactionController extends GetxController {
  List<TransactionModel> transactionList = <TransactionModel>[].obs;
  List<TransactionModel> filteredTransactionList = <TransactionModel>[].obs;

  // List<double> totalAllTransactionList = <double>[].obs;

  List<double> totalTransactionList = <double>[].obs;
  //double expenseTransaction = 0.0.obs as double;

  List<Customer> newListNotifier = <Customer>[].obs;

  List<Customer> mylistNotifier = <Customer>[].obs;

  Map<String, double> pieMapNotifier = <String, double>{}.obs;

  //List<TransactionModel> _refList = [];
  DateTime? start;
  DateTime? end;

  DateTime? wafistart;
  DateTime? wafiend;

  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refreshList() async {
    List<TransactionModel> _list = [];
    if (wafiend == null) {
      _list = await getAllTransactions();
    } else {
      _list = await filterAllTransaction(wafistart, wafiend);
    }

    _list.sort((first, second) => second.date.compareTo(first.date));
    filteredTransactionList.clear();
    filteredTransactionList.addAll(_list);
    update();

    getTotalAmount();
    sfPieChart();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    return _db.values.toList();
  }

  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);

    refreshList();
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

    return _newList;
  }

  Future getTotalAmount() async {
    // List<TransactionModel> entireData = await getAllTransactions();
    List<TransactionModel> entireData = [];
    if (wafiend == null) {
      entireData = await getAllTransactions();
    } else {
      entireData = await filterAllTransaction(wafistart, wafiend);
    }
    // entireData = await filterAllTransaction(wafistart, wafiend);
    double _income = 0;
    double _expense = 0;
    List<double> totalAmount = [];
    for (TransactionModel data in entireData) {
      if (data.type == CategoryType.income) {
        _income += data.amount;
      } else if (data.type == CategoryType.expense) {
        _expense += data.amount;
      }
      // print('get total');
    }

    totalAmount.add(_income);
    totalAmount.add(_expense);
    totalTransactionList.clear();
    totalTransactionList.add(_income);
    totalTransactionList.add(_expense);

    update();
    print(totalTransactionList);
    //incomeTransaction = totalAmount.first;
    // expenseTransaction = totalAmount.last;
  }

  wafi(DateTime start, DateTime end) {
    wafistart = start;
    wafiend = end;
    refreshList();
  }

  sfPieChart() async {
    List<TransactionModel> entireData = [];
    if (wafiend == null) {
      entireData = await getAllTransactions();
    } else {
      entireData = await filterAllTransaction(wafistart, wafiend);
    }

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
    mylistNotifier.clear();
    mylistNotifier.addAll(mylist);
    update();
    //print('pie cus ${mylist.toList()}');
  }

  bool closeTopContainer = false;
  bool openTopContainer = false;
  ScrollController scrollController = ScrollController();
  animatedContainer() {
    scrollController.addListener(() {
      closeTopContainer = scrollController.offset > 50;
      // openTopContainer = scrollController.offset < 50;
      update();
    });
    update();
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
