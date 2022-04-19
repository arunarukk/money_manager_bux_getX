import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screens/category/expense_category_list.dart';
import 'package:money_manager/screens/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final categoryControl = Get.put(categoryController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    categoryControl.refreshUI();
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.cyan,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.cyan,
          tabs: [
            Tab(text: 'INCOME'),
            Tab(text: 'EXPENSE'),
          ],
        ),
        Expanded(
            child: TabBarView(controller: _tabController, children: [
          IncomeCategoryList(),
          ExpenseCategoryList(),
        ]))
      ],
    );
  }
}
