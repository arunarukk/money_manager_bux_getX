import 'dart:ui';
import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/category/screen_category.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Money Manager',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('add transaction');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            //print('add category');
            // showcategoryAddPopup(context);
          }
        },
        child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 400),
          closedBuilder: (_, openContainer) {
            return const Center(
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 32.0,
              ),
            );
          },
          openColor: Colors.white,
          closedElevation: 50.0,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          closedColor: Colors.cyan,
          openBuilder: (_, closeContainer) {
            if (selectedIndexNotifier.value == 0) {
              print('add transaction');
              //Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
              return ScreenAddTransaction();
            } else {
              print('add category');
              // final _sample = CategoryModel(
              //   id: DateTime.now().microsecondsSinceEpoch.toString(),
              //   name: 'Travel',
              //   type: CategoryType.expense,
              // );
              // CategoryDB().insertCategory(_sample);
              return AddCategory();
            }
          },
        ),
        //Icon(Icons.add,),
      ),
    );
  }
}
