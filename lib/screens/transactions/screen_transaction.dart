import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

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
  String _selectedStartDate = 'From';
  String _selectedEndDate = 'Until';
  bool dateRangePerformed = false;

  DateTimeRange? dateRange;

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

  Future pieData() async {
    List<TransactionModel> data =
        await TransactionDB.instance.getAllTransactions();

    final Map<String, double> result = Map.fromIterable(data,
        key: (v) => v.category.name, value: (v) => v.amount);
    //_dataMap = result;

    if (result.isEmpty) {
      return;
    }
    setState(() {
      _dataMap = result;
    });
    print('pieData');
  }

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
    //TransactionDB.instance.refresh();
    super.initState();
    pieData();

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
    // pieData();
    // getTotalAmount();
    final Size size = MediaQuery.of(context).size;
    final double chartHeight = size.height * 0.30;
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(right: 30, left: 30, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Set Range',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              // SizedBox(
              //   width: 150,
              //   child: TextFormField(
              //     textAlign: TextAlign.center,
              //     decoration: const InputDecoration(
              //       border: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       enabledBorder: InputBorder.none,
              //       errorBorder: InputBorder.none,
              //       disabledBorder: InputBorder.none,
              //       contentPadding:
              //           EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              //     ),
              //     readOnly: true,
              //     keyboardType: TextInputType.none,
              //     controller: _dateController,
              //     onTap: () async {
              //       // await showDatePicker(
              //       //   context: context,
              //       //   initialDate: DateTime.now(),
              //       //   firstDate: DateTime(2015),
              //       //   lastDate: DateTime.now(),
              //       // ).then((selectedDate) {
              //       //   if (selectedDate != null) {
              //       //     _dateController.text =
              //       //         DateFormat('MMM dd, yyyy').format(selectedDate);
              //       //     for (int i = 0; i < listDate.length; i++) {
              //       //       if (listDate[i] == _dateController.text) {
              //       //         flag = 1;
              //       //         break;
              //       //       } else {
              //       //         flag = 0;
              //       //       }
              //       //     }
              //       //     setState(() {});
              //       //   }
              //       // });
              //      // pickDateRange(context);
              //     },
              //     style: const TextStyle(fontSize: 15, color: Colors.black),
              //     validator: (String? value) {
              //       if (value!.isEmpty) {
              //         return 'Date is Required';
              //       }
              //       return null;
              //     },
              //     onSaved: (String? value) {},
              //   ),
              // ),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        // ),
                        elevation: 0,
                        primary: Colors.grey[100],
                        // shadowColor: Colors.cyan,
                      ),
                      onPressed: () {
                        pickDateRange(context);
                        // TransactionDB.instance.filterRange(
                        //     (dateRange!.start).toString(),
                        //     (dateRange!.end).toString());
                        // filterange();
                        // setState(() {
                        //   _selectedStartDate = getFrom();
                        //   _selectedEndDate = getUntil();
                        // });
                      },
                      child: Text(
                        _selectedStartDate,
                        style: TextStyle(color: Colors.grey.shade600),
                      )),
                  // Expanded(
                  //   child: TextFormField(
                  //     // controller: _startController,
                  //     decoration: InputDecoration(
                  //         hintText: getFrom(),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(30),
                  //         )),
                  //     // initialValue: getFrom(),
                  //     onTap: () => pickDateRange(context),
                  //   ),
                  // ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 0,
                      //shadowColor: Colors.purple,
                      primary: Colors.grey[100],
                      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      //textStyle:
                      // TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                    ),
                    onPressed: () {
                      pickDateRange(context);
                      // setState(() {
                      //   _selectedStartDate = getFrom();
                      //   _selectedEndDate = getUntil();
                      // });
                    },
                    child: Text(
                      _selectedEndDate,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              // Expanded(
              //   child: TextFormField(
              //     //controller: _endController,
              //     decoration: InputDecoration(
              //         hintText: getUntil(),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(30),
              //         )),
              //     // initialValue: getUntil(),
              //     onTap: () => pickDateRange(context),
              //   ),
              // ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (dateRange != null) {
              setState(() {
                dateRangePerformed = true;
              });
              TransactionDB.instance
                  .filterAllTransaction(dateRange?.start, dateRange?.end);
            }
            print(dateRangePerformed);
          },
          child: Text('Search'),
        ),
        const SizedBox(
          height: 5,
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
                                  child: Text(
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
                                    ? Text('₹ 0')
                                    : Text(
                                        '₹ ${(totalIncome).toString()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFffffff),
                                          letterSpacing: 1,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
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
                              .instance.totalAllTransactionListNotifier,
                          builder: (BuildContext ctx, List<double> newList,
                              Widget? _) {
                            if (newList.isEmpty)
                              return Text(
                                '₹ 0',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFffffff),
                                  letterSpacing: 1,
                                ),
                              );
                            return newList == null
                                ? Text('₹ 0')
                                : Text(
                                    '₹ ${(newList.last).toString()}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1,
                                    ),
                                  );
                          },
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text(
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
          height: 30,
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
                color: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 30,
                shadowColor: Colors.black,
                child: SizedBox(
                  width: 350,
                  height: 200,
                  child: _dataMap.isEmpty
                      ? const Center(
                          child: Text(
                          'Set Range To See Pie Chart',
                          style: TextStyle(color: Colors.grey),
                        ))
                      : PieChart(
                          //emptyColor: Colors.white,
                          dataMap: _dataMap,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 35,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          //colorList: colorList,
                          // initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 35,
                          centerText: "Transaction",
                          centerTextStyle: TextStyle(color: Colors.white),
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                              decimalPlaces: 1,
                              chartValueStyle: TextStyle(color: Colors.black)),
                          // gradientList: ---To add gradient colors---
                          // emptyColorGradient: ---Empty Color gradient---
                        ),
                )),
          ),
        ),
        Expanded(
            child: ValueListenableBuilder(
                valueListenable: TransactionDB.instance.transactionListNotifier,
                builder: (BuildContext ctx, List<TransactionModel> newList,
                    Widget? _) {
                  return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      itemBuilder: (ctx, index) {
                        final _value = newList[index];
                        return Card(
                          shadowColor: _value.type == CategoryType.expense
                              ? Colors.red
                              : Colors.lightGreenAccent.shade700,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(
                            //     width: 2,
                            //     color: _value.type == CategoryType.expense
                            //         ? Colors.red
                            //         : Colors.lightGreenAccent.shade700),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // margin: EdgeInsets.only(left: 10, right: 10),
                          elevation: 20,
                          child: Slidable(
                            //closeOnScroll: true,
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  spacing: 10,
                                  onPressed: (ctx) {
                                    // print('slidable delete');
                                    // print(_value.id);
                                    TransactionDB.instance
                                        .deleteTransaction(_value.id!);
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
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                  ),
                                  title: Text(
                                    'RS ${_value.amount}',
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
                          height: 10,
                        );
                      },
                      itemCount: newList.length);
                })),
      ],
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;
    //print(newDateRange.start);

    setState(() {
      dateRange = newDateRange;
      _selectedStartDate = dateRange == null
          ? 'From'
          : DateFormat('dd/MM/yyyy').format(dateRange!.start);
      _selectedEndDate = dateRange == null
          ? 'Until'
          : DateFormat('dd/MM/yyyy').format(dateRange!.end);
    });
    //print(dateRange);
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
