import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/home/screen_home.dart';

import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenTransaction extends StatelessWidget {
  ScreenTransaction({Key? key}) : super(key: key);

  Map<String, double> _dataMap = {};
  //Map<String, double> dataMap = {"Travel": 100};

  bool flag = false;
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  final transactionControl = Get.put(transactionController());

  void initState() {
    transactionControl.refreshList();
    categoryControl.refreshUI();
    transactionControl.animatedContainer();
  }

  final categoryControl = Get.put(categoryController());

  @override
  Widget build(BuildContext context) {
    initState();

    final Size size = MediaQuery.of(context).size;
    final double chartHeight = size.height * 0.27;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Material(
                elevation: 20,
                shadowColor: const Color(0xFF3366FF),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: app_color.widget,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFF3366FF),
                        Color(0xFF00CCFF),
                      ],
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 30,
                          child: Obx(
                            () {
                              var totalIncome;
                              if (transactionControl
                                  .totalTransactionList.isEmpty) {
                                totalIncome = 0;
                              } else {
                                totalIncome = transactionControl
                                    .totalTransactionList.first;
                              }

                              return Text(
                                '₹ ${(totalIncome).toString()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFffffff),
                                  letterSpacing: 1,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Total Income',
                          style: TextStyle(
                            //color: app_color.textWhite,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Material(
                elevation: 20,
                shadowColor: Colors.orange,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: app_color.widget,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.red,
                        Colors.orange
                      ], // red to yellow
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 30,
                          child: Obx((() {
                            var totalExpense;
                            if (transactionControl
                                .totalTransactionList.isEmpty) {
                              totalExpense = 0;
                            } else {
                              totalExpense =
                                  transactionControl.totalTransactionList.last;
                            }
                            return Text(
                              '₹ ${(totalExpense).toString()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFffffff),
                                letterSpacing: 1,
                              ),
                            );
                          })),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Total Expense',
                          style: TextStyle(
                            //color: app_color.textWhite,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<transactionController>(
          init: transactionController(),
          builder: (controller) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: size.width,
              alignment: Alignment.topCenter,
              height: controller.closeTopContainer ? 0 : chartHeight,
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                child: Card(
                    color: Color(0xf01f2420),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                    shadowColor: Colors.black,
                    child: SizedBox(
                      width: 350,
                      height: 200,
                      child: Obx((() {
                        final newMap = transactionControl.mylistNotifier;

                        if (newMap == null || newMap.isEmpty) {
                          return Center(
                              child: Column(
                            children: [
                              Image.asset(
                                'assets/image/piechart.png',
                                height: 160,
                              ),
                              Text(
                                'No transactions yet',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                            ],
                          ));
                        }
                        return SfCircularChart(
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              textStyle: TextStyle(color: Colors.white)),
                          tooltipBehavior: _tooltipBehavior,
                          series: <CircularSeries>[
                            PieSeries<Customer, String>(
                              dataSource: newMap,
                              xValueMapper: (Customer data, _) => data.typeName,
                              yValueMapper: (Customer data, _) => data.amount,
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelIntersectAction:
                                      LabelIntersectAction.shift,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  connectorLineSettings: ConnectorLineSettings(
                                      type: ConnectorType.curve,
                                      length: '15%')),
                              enableTooltip: true,
                            )
                          ],
                        );
                      })),
                    )),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Obx((() => ListView.separated(
               // shrinkWrap: true,
                controller: transactionControl.scrollController,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemBuilder: (ctx, index) {
                  final _value =
                      transactionControl.filteredTransactionList[index];
                  print(_value);
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Slidable(
                      //closeOnScroll: true,
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            spacing: 10,
                            onPressed: (ctx) {
                              transactionControl.deleteTransaction(_value.id!);
                            },
                            icon: Icons.delete,
                            label: 'Delete',
                            backgroundColor: const Color(0xFFFE4A49),
                            //foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 80,
                        child: Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Text(
                                parseDate(_value.date),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.cyan),
                              ),
                            ),
                            title: Text(
                              '₹ ${_value.amount}',
                              style: TextStyle(
                                color: _value.type == CategoryType.expense
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            subtitle: Text(
                                '${_value.category.name}\n${_value.purpose}'),
                            trailing: _value.type == CategoryType.expense
                                ? const Icon(
                                    Icons.trending_down_sharp,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.trending_up_sharp,
                                    color: Colors.green,
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
                itemCount:
                    transactionControl.filteredTransactionList.length)))),
      ],
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n ${_splitedDate.first}';
    //return '${date.day}\n${date.month}';
  }
}
