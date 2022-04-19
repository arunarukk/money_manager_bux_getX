import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';



ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

class AddCategory extends StatelessWidget {
  AddCategory({Key? key}) : super(key: key);

final categoryControl = Get.put(categoryController());

  final _formKey = GlobalKey<FormState>();
  final _nameEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Add Category',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 198,
                child: Image.asset('assets/image/expense.jpg'),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nameEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        //labelStyle: TextStyle(color: Colors.black),
                        //hoverColor: Colors.black,
                        // border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Category Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RadioButton(
                          title: 'Income',
                          type: CategoryType.income,
                        ),
                        RadioButton(
                          title: 'Expense',
                          type: CategoryType.expense,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.cyan),
                      onPressed: () {
                        final _name = _nameEditingController.text;

                        if (_formKey.currentState!.validate()) {
                          final _type = selectedCategoryNotifier.value;
                          final _category = CategoryModel(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              name: _name,
                              type: _type);
                          categoryControl.insertCategory(_category);
                          print(_category.toString());
                          Navigator.of(context).pop();
                          // ignore: prefer_const_constructors
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 3),
                            content: const Text('Category Added SuccesFully!'),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  // final CategoryType selectedCategoryType;

  RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  CategoryType? _type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: selectedCategoryNotifier.value,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
                activeColor: Colors.cyan,
              );
            }),
        Text(title),
      ],
    );
  }
}
