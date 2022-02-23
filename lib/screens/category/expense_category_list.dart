import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (ctx, index) {
            final category = newList[index];
            return Card(
              //shadowColor: Colors.red,
              //borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 1,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                      onPressed: () {
                        CategoryDB.instance.deleteCategory(category.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 5,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
