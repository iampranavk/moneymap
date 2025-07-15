import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymap/hive/expense_helper.dart';
import 'package:moneymap/model/grouped_expense.dart';
import 'package:moneymap/shared_preference/shared_preference_helper.dart';
import 'package:moneymap/ui/widgets/expense_item.dart';
import 'package:moneymap/util/currency_formatter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<GroupedExpense> groupedExpenses = [];
  String symbol = '';

  void _loadExpensesHistory() async {
    final expenses = ExpenseHelper.getExpensesGroupedByMonth();
    symbol = await SharedPreferencesHelper.getCurrencySymbol();
    setState(() {
      groupedExpenses = expenses;
    });
  }

  @override
  void initState() {
    _loadExpensesHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_outlined, color: Colors.grey[600], size: 28),
        ),
        centerTitle: false,
        title: Text(
          'History',
          style: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Expenses',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthAndTotalStrip(
                        month: groupedExpenses[i].date,
                        amount: groupedExpenses[i].total,
                        symbol: symbol,
                      ),
                      if (groupedExpenses[i].expenses.isEmpty)
                        Text(
                          'No expenses found',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[300]),
                        ),
                      if (groupedExpenses[i].expenses.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, j) => ExpenseItem(
                              expense: groupedExpenses[i].expenses[j],
                              symbol: symbol,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 2),
                            itemCount: groupedExpenses[i].expenses.length,
                          ),
                        ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 20,
                  thickness: 0.7,
                ),
                itemCount: groupedExpenses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthAndTotalStrip extends StatelessWidget {
  final String month, symbol;
  final double amount;
  const MonthAndTotalStrip({
    super.key,
    required this.month,
    required this.amount,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              month,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey[300],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              formatCurrency(amount, symbol),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
