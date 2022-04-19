// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/home/screen_home.dart';

class ScreenAddTransaction extends StatelessWidget {
  static const routeName = 'add-transaction';
  ScreenAddTransaction({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final categoryControl = Get.put(categoryController());
  final transactionControl = Get.put(transactionController());

  
  CategoryModel? _selectedCategoryModel;

  final stateControl = Get.put(stateController());


  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

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
            child: Form(
              key: _formKey,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Purpose';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Valid Amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        final selectedDateTemp = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        stateControl.dateChange(selectedDateTemp!);
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: GetBuilder<stateController>(
                        builder: (controller) {
                          return Text(controller.myDate == null
                                  ? 'Select Date'
                                  : DateFormat('dd/MM/yyyy')
                                      .format(controller.myDate!)
                              // _selectedDate.toString(),
                              );
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<stateController>(
                    init: stateController(),
                    builder: (controller) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: CategoryType.income,
                                groupValue: controller.selectedCategorytype,
                                onChanged: (newValue) {
                                  stateControl
                                      .categoryRadio(CategoryType.income);

                                  controller.selectedCategorytype =
                                      CategoryType.income;
                                  controller.categoryID = null;
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
                                groupValue: controller.selectedCategorytype,
                                onChanged: (newValue) {
                                  stateControl
                                      .categoryRadio(CategoryType.expense);
                                  // setState(() {
                                  controller.selectedCategorytype =
                                      stateControl.selectedCategorytype;
                                  controller.categoryID = null;
                                  // });
                                },
                                activeColor: Colors.cyan,
                              ),
                              Text('Expense'),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<stateController>(
                    init: stateController(),
                    builder: (controller) {
                      return DropdownButton<String>(
                          hint: Text('Select Category'),
                          value: controller.categoryID,
                          items: (controller.selectedCategorytype ==
                                      CategoryType.income
                                  ? categoryControl.incomeCategoryList
                                  : categoryControl.expenseCategoryList)
                              .map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                              onTap: () {
                                _selectedCategoryModel = e;
                              },
                            );
                          }).toList(),
                          onChanged: (selectedValue) {
                            //setState(() {
                            controller.categoryIDchange(selectedValue!);
                            controller.categoryID = selectedValue;
                            // });
                          });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.cyan),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addTransaction();
                        }
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
    if (stateControl.categoryID == null) {
      return;
    }
    if (stateControl.myDate == null) {
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
      date: stateControl.myDate!,
      type: stateControl.selectedCategorytype!,
      category: _selectedCategoryModel!,
    );

    await transactionControl.addTransaction(_model);
    // ScreenHome();
    //Navigator.of(context).pop();
    Get.back();
    transactionControl.refreshList();

    // final snackBar = SnackBar(
    //   duration: Duration(seconds: 3),
    //   content: Text('Transaction Added SuccesFully!'),
    //   backgroundColor: Colors.green,
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Get.snackbar(
      "Hey",
      "Transaction Added SuccesFully!",
      backgroundColor: Color.fromARGB(255, 57, 133, 60),
    );
  }
}

class stateController extends GetxController {
  DateTime? myDate;
  CategoryType? selectedCategorytype;
  String? categoryID;

  void dateChange(DateTime newDate) {
    myDate = newDate;
    update();
  }

  void categoryRadio(CategoryType? selectedType) {
    selectedCategorytype = selectedType;
    update();
  }

  void categoryIDchange(String categoryId) {
    categoryID = categoryId;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedCategorytype = CategoryType.income;
  }
}
