// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/home/screen_home.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _purposeTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _amountTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      print(_selectedDateTemp.toString());
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null
                          ? 'Select Date'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      // _selectedDate.toString(),
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategorytype,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.income;
                              _categoryID = null;
                            });
                          },
                          activeColor: Colors.cyan,
                        ),
                        Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategorytype,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.expense;
                              _categoryID = null;
                            });
                          },
                          activeColor: Colors.cyan,
                        ),
                        Text('Expense'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                    hint: Text('Select Category'),
                    value: _categoryID,
                    items: (_selectedCategorytype == CategoryType.income
                            ? CategoryDB().incomeCategoryListListener
                            : CategoryDB().expenseCategoryListListener)
                        .value
                        .map((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: () {
                          _selectedCategoryModel = e;
                        },
                      );
                    }).toList(),
                    //  const [
                    //   DropdownMenuItem(
                    //     child: Text('Category 1'),
                    //     value: 1,
                    //   ),
                    //   DropdownMenuItem(
                    //     child: Text('Category 2'),
                    //     value: 2,
                    //   ),
                    //   DropdownMenuItem(
                    //     child: Text('Category 3'),
                    //     value: 3,
                    //   ),
                    //   DropdownMenuItem(
                    //     child: Text('Category 4'),
                    //     value: 4,
                    //   ),
                    // ],
                    onChanged: (selectedValue) {
                      print(selectedValue);
                      setState(() {
                        _categoryID = selectedValue;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan),
                    onPressed: () {
                      addTransaction();
                    },
                    child: Text('Submit')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    // ScreenHome();
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();

    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Category Added SuccesFully!'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
