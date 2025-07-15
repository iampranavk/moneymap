import 'package:moneymap/model/expense.dart';

class GroupedExpense {
  final String date;
  final List<Expense> expenses;
  final double total;

  GroupedExpense({
    required this.date,
    required this.expenses,
    required this.total,
  });
}
