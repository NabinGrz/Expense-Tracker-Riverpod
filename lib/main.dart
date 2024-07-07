import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/expense/add_new_expense_dialog.dart/add_new_expense_dialog.dart';
import 'package:expense_tracker_flutter/features/home/screen/home_screen.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/utils/expense_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

import 'firebase_options.dart';
import 'shared/provider/sort_by_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Expense> originalExpenseList = [];
  final sortedExpenseSubject = BehaviorSubject<List<Expense>>();

  @override
  void initState() {
    ExpenseQueryHelper.getExpenseAsFuture()?.then(
      (value) {
        final data = value.docs.map(
          (e) {
            return Expense.fromJson(jsonEncode(e.data()));
          },
        ).toList();
        originalExpenseList = List.from(data);
        sortedExpenseSubject.add(data);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Home"),
        trailing: GestureDetector(
            onTap: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => const AddNewExpenseDialog(),
              );
              // ExpenseQueryHelper.createExpense(Expense(
              //     id: const Uuid().v4(),
              //     name: "name",
              //     category: "category",
              //     createAt: DateTime.now().toString(),
              //     updatedAt: DateTime.now().toString(),
              //     amount: 100,
              //     isCash: true));
            },
            child: const Icon(
              Icons.add,
            )),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: sortedExpenseSubject,
              builder: (context, snapshot) {
                final expenses = snapshot.data;
                return Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          ExpenseUtils.sortBy(expenses ?? [], SortBy.lowtohigh);
                          sortedExpenseSubject.add(expenses ?? []);
                        },
                        child: const Text("Low to high")),
                    TextButton(
                        onPressed: () {
                          ExpenseUtils.sortBy(expenses ?? [], SortBy.hightolow);
                          sortedExpenseSubject.add(expenses ?? []);
                        },
                        child: const Text("High to low")),
                    TextButton(
                        onPressed: () {
                          sortedExpenseSubject.add(originalExpenseList);
                        },
                        child: const Text("None")),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: expenses?.length ?? 0,
                      itemBuilder: (context, index) {
                        final expenseData = expenses?[index];
                        return Text(
                            "${expenseData?.name}:${expenseData?.amount}");
                      },
                    ),
                  ],
                );
              },
            ),
            Container(
              color: Colors.red,
              child: StreamBuilder(
                stream:
                    ExpenseQueryHelper.getSelectedDateExpenses(DateTime.now()),
                builder: (context, snapshot) {
                  final expenses = snapshot.data;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: expenses?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(
                          "${expenses?[index].name}:${expenses?[index].amount}");
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.amber,
              child: StreamBuilder(
                stream: ExpenseQueryHelper.getSelectedDateRangeExpenses(
                  DateTime(DateTime.now().year, DateTime.now().month, 1),
                  DateTime(DateTime.now().year, DateTime.now().month, 3),
                ),
                builder: (context, snapshot) {
                  final expenses = snapshot.data;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: expenses?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(
                          "${expenses?[index].name}:${expenses?[index].amount}");
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
