import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/home/screen_home.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenTransaction extends StatefulWidget {
  ScreenTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  Map<String, double> _dataMap = {};
  //Map<String, double> dataMap = {"Travel": 100};
  ScrollController scrollController = ScrollController();

  bool closeTopContainer = false;
  // DateTimeRange? dateRange;

  late TooltipBehavior _tooltipBehavior;

  String? _selectedStartDate;
  String? _selectedEndDate;

  String? _shrdStartDate;
  String? _shrdEndDate;

  // Future pickDateRange(BuildContext context) async {
  //   final initialDateRange = DateTimeRange(
  //     start: DateTime.now(),
  //     end: DateTime.now().add(Duration(hours: 24 * 3)),
  //   );
  //   final newDateRange = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(DateTime.now().year - 5),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //     initialDateRange: dateRange ?? initialDateRange,
  //   );

  //   if (newDateRange == null) return;
  //   //print(newDateRange.start);
  //   dateRange = newDateRange;
  //   _selectedStartDate = DateFormat('dd/MM/yyyy').format(dateRange!.start);
  //   _selectedEndDate = DateFormat('dd/MM/yyyy').format(dateRange!.end);

  //   //print(dateRange);
  //   if (dateRange != null) {
  //     getShrdDate();
  //   }
  // }

  // getShrdDate() async {
  //   final _sharedPrefs = await SharedPreferences.getInstance();

  //   final endDate = _sharedPrefs.setString('end', _selectedEndDate!);
  //   final startDate = _sharedPrefs.setString('start', _selectedStartDate!);

  //   print('end${_selectedEndDate}');
  //   print(endDate.toString());

  //   // _selectedStartDate = DateFormat('dd/MM/yyyy').format(dateRange!.start);
  //   // _selectedEndDate = DateFormat('dd/MM/yyyy').format(dateRange!.end);
  //   _shrdEndDate = _sharedPrefs.get('end') as String?;
  //   _shrdStartDate = _sharedPrefs.get('start') as String?;
  //   print('set ${_shrdEndDate}');
  // }

  //bool dateRangePerformed = false;

  // String getFrom() {
  //   if (dateRange == null) {
  //     return 'From';
  //   } else {
  //     return DateFormat('dd/MM/yyyy').format(dateRange!.start);
  //   }
  // }

  // String getUntil() {
  //   if (dateRange == null) {
  //     return 'Until';
  //   } else {
  //     // print('dateRange${(dateRange!.start)}');
  //     return DateFormat('dd/MM/yyyy').format(dateRange!.end);
  //   }
  // }

  // final _dateController = TextEditingController(
  //     text: DateFormat('MMM dd, yyyy').format(DateTime.now()));
  //final _dateController = TextEditingController();
  //final _endController = TextEditingController();
  //final _startController = TextEditingController();
  //List<String> listDate = [];
  //int flag = 0;

  /* .............pieChart list to map.............. */

  // Future pieData() async {
  //   List<TransactionModel> data =
  //       await TransactionDB.instance.getAllTransactions();

  //   final Map<String, double> result = Map.fromIterable(data,
  //       key: (v) => v.category.name, value: (v) => v.amount);
  //   //_dataMap = result;

  //   if (result.isEmpty) {
  //     return;
  //   }
  //   print(data.toList());
  //   setState(() {
  //     _dataMap = result;
  //   });
  //   print('pieData');
  // }

/* .............Total of Income and Expense.............. */
  // getTotalAmount() async {
  //   List<TransactionModel> entireData =
  //       await TransactionDB.instance.getAllTransactions();
  //   double _income = 0;
  //   double _expense = 0;
  //   for (TransactionModel data in entireData) {
  //     if (data.type == CategoryType.income) {
  //       _income += data.amount;
  //     } else {
  //       _expense += data.amount;
  //     }
  //     print('get total');
  //   }
  //   setState(() {
  //     totalIncome = _income;
  //     totalExpense = _expense;
  //   });
  //   TransactionDB.instance.refresh();
  // }

  //\\\\\\\\\\\\\\\\\filter with Date range\\\\\\\\\\\\\\\\
  // getfiltered()async{

  // }

  @override
  void initState() {
    // TODO: implement initState
    TransactionDB.instance.refresh();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    // pieData();

    //getTotalAmount();
    //TransactionDB.instance.filterRange(dateRange!.start, getUntil());
    scrollController.addListener(() {
      setState(() {
        // dataMap = pieData() as Map<String, double>;
        closeTopContainer = scrollController.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    TransactionDB.instance.pieData();
    // pieData();
    // getTotalAmount();
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
                        //Color(0xff00c9af),
                        Color(0xFF3366FF),
                        //Color(0xff2ad054),
                        Color(0xFF00CCFF)
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
                        Container(
                          height: 20,
                          child: ValueListenableBuilder(
                            valueListenable: TransactionDB
                                .instance.incomeTransactionListNotifier,
                            builder:
                                (BuildContext ctx, totalIncome, Widget? _) {
                              if (totalIncome == null)
                                return Container(
                                  child: const Text(
                                    '₹ 0',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                );
                              return SingleChildScrollView(
                                child: totalIncome == null
                                    ? const Text('₹ 0')
                                    : Text(
                                        '₹ ${(totalIncome).toString()}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFffffff),
                                          letterSpacing: 1,
                                        ),
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
                        //Color(0xffce009c),
                        //Color(0xffec0303),
                        //Color(0xFFFFFFFF),
                        //Color(0xffee2f2f),
                        //Color(0xfff36d6d)
                        Colors.red, Colors.orange
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
                        // Text(
                        //   'Spent',
                        //   style: TextStyle(
                        //     //color: app_color.textWhite,
                        //     letterSpacing: 1,
                        //   ),
                        // ),
                        ValueListenableBuilder(
                          valueListenable: TransactionDB
                              .instance.expenseTransactionListNotifier,
                          builder: (BuildContext ctx, expense, Widget? _) {
                            //if (expense==null)
                            // return Text(
                            //   '₹ 0',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //     color: Color(0xFFffffff),
                            //     letterSpacing: 1,
                            //   ),
                            // );
                            return expense == null
                                ? const Text('₹ 0')
                                : Text(
                                    '₹ ${(expense).toString()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1,
                                    ),
                                  );
                          },
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          width: size.width,
          alignment: Alignment.topCenter,
          height: closeTopContainer ? 0 : chartHeight,
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: Card(
                color: const Color(0xf01f2420),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                shadowColor: Colors.black,
                child: SizedBox(
                  width: 350,
                  height: 200,
                  child:
                      // TransactionDB.instance.pieMapNotifier.value == null ||
                      //         TransactionDB.instance.pieMapNotifier.value.isEmpty
                      //     ? const Center(
                      //         child: Text(
                      //         'Set Range To See Pie Chart',
                      //         style: TextStyle(color: Colors.grey),
                      //       ))
                      //     :
                      ValueListenableBuilder(
                    valueListenable: TransactionDB.instance.mylistNotifier,
                    builder:
                        (BuildContext ctx, List<Customer> newMap, Widget? _) {
                      if (newMap == null || newMap.isEmpty) {
                        return const Center(
                            child: Text(
                          'Set Range To See Pie Chart',
                          style: TextStyle(color: Colors.grey),
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
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            enableTooltip: true,
                          )
                        ],
                      );
                    },
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: ValueListenableBuilder(
                valueListenable:
                    TransactionDB.instance.filteredTransactionListNotifier,
                builder: (BuildContext ctx, List<TransactionModel> newList,
                    Widget? _) {
                  return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      itemBuilder: (ctx, index) {
                        final _value = newList[index];
                        return Card(
                          // shadowColor: _value.type == CategoryType.expense
                          //     ? Colors.red
                          //     : Colors.lightGreenAccent.shade700,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(
                            //     width: 2,
                            //     color: _value.type == CategoryType.expense
                            //         ? Colors.red
                            //         : Colors.lightGreenAccent.shade700),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // margin: EdgeInsets.only(left: 10, right: 10),
                          elevation: 1,
                          child: Slidable(
                            //closeOnScroll: true,
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  spacing: 10,
                                  onPressed: (ctx) {
                                    // print('slidable delete');
                                    // print(_value.id);
                                    setState(() {
                                      TransactionDB.instance
                                          .deleteTransaction(_value.id!);
                                      TransactionDB.instance.refresh();
                                    });
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
                                      style:
                                          const TextStyle(color: Colors.cyan),
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
                                  subtitle: Text(_value.category.name),
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
                      itemCount: newList.length);
                })),
      ],
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n ${_splitedDate.first}';
    //return '${date.day}\n${date.month}';
  }

  // Future<void> filterange() async {
  //   // final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  //   // final filterList = _db.valuesBetween(startKey: startKey, endKey: endKey);

  //   final _list = await TransactionDB.instance.getAllTransactions();
  //   //  _list.sort((startKey, endKey) => endKey.date.compareTo(startKey.date));
  //   var list1;
  //   for (int i = 0; i < _list.length - 1; i++) {
  //     for (var j = 1; j < _list.length; j++) {
  //       if (_list[i] == _list[j]) {
  //         list1[i] = _list[i];
  //         print(_list[i]);
  //       }
  //       print(_list.toString());
  //     }
  //   }
  // }
}
