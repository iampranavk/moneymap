import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymap/hive/expense_helper.dart';
import 'package:moneymap/model/grouped_expense.dart';
import 'package:moneymap/shared_preference/shared_preference_helper.dart';
import 'package:moneymap/ui/add_expense_sheet.dart';
import 'package:moneymap/ui/history_screen.dart';
import 'package:moneymap/ui/widgets/expense_item.dart';
import 'package:moneymap/util/currency_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GroupedExpense? todaysExpenses;
  final today = DateTime.now();
  String todayString = '', symbol = '';

  @override
  void initState() {
    todayString = today.toIso8601String().split('T').first;
    _loadExpenses();
    super.initState();
  }

  void _loadExpenses() async {
    final expenses = ExpenseHelper.getExpensesByDate(todayString);
    symbol = await SharedPreferencesHelper.getCurrencySymbol();
    setState(() {
      todaysExpenses = expenses;
    });
  }

  void _refreshExpenses() {
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[500],
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddExpenseSheet(onSave: () => _refreshExpenses()),
            ),
          );
        },
        child: Icon(Icons.add_outlined, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'MoneyMap',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0XFF58DEAC),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
              icon: Icon(Icons.history_outlined, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TODAY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (todaysExpenses != null)
                    Text(
                      formatCurrency(todaysExpenses!.total, symbol),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              Divider(height: 30, color: Colors.grey[400], thickness: 0.5),
              if (todaysExpenses == null)
                Center(
                  child: Text(
                    'No expenses found',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[300]),
                  ),
                ),
              if (todaysExpenses != null && todaysExpenses!.expenses.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ExpenseItem(
                      expense: todaysExpenses!.expenses[index],
                      symbol: symbol,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: todaysExpenses!.expenses.length,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
