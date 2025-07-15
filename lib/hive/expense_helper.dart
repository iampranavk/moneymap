import 'package:hive/hive.dart';
import 'package:moneymap/model/expense.dart';
import 'package:intl/intl.dart';
import 'package:moneymap/model/grouped_expense.dart';

class ExpenseHelper {
  static const String _boxName = 'expenses_box';

  /// Open the Hive box (should be called during app startup)
  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Expense>(_boxName);
    }
  }

  /// Add a new expense
  static Future<void> addExpense(Expense expense) async {
    final box = Hive.box<Expense>(_boxName);
    await box.add(expense);
  }

  /// Get all expenses on a specific date
  // static List<Expense> getExpensesByDate(String date) {
  //   // date should be in "YYYY-MM-DD" format, e.g., "2025-07-14"
  //   final box = Hive.box<Expense>(_boxName);
  //   return box.values.where((e) => e.createdAt.startsWith(date)).toList();
  // }

  static GroupedExpense getExpensesByDate(String date) {
    // date format: "YYYY-MM-DD"
    final box = Hive.box<Expense>(_boxName);

    // Filter expenses matching the date
    final filteredExpenses = box.values
        .where((e) => e.createdAt.startsWith(date))
        .toList();

    // Sort newest first
    filteredExpenses.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt) ?? DateTime(2000);
      final bDate = DateTime.tryParse(b.createdAt) ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });

    // Calculate total
    final total = filteredExpenses.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );

    // Format the date for display (e.g., "14 Jul 2025")
    final parsedDate = DateTime.tryParse(date);
    final formatted = parsedDate != null
        ? DateFormat('dd MMM yyyy').format(parsedDate)
        : date;

    return GroupedExpense(
      date: formatted,
      expenses: filteredExpenses,
      total: total,
    );
  }

  static List<GroupedExpense> getExpensesGroupedByMonth() {
    final box = Hive.box<Expense>(_boxName);
    final List<Expense> allExpenses = box.values.toList();

    final Map<String, List<Expense>> grouped = {};
    final formatter = DateFormat('MMM yyyy'); // or 'MMMM yyyy' for full names

    for (var expense in allExpenses) {
      if (expense.createdAt.isEmpty) continue;

      final dateTime = DateTime.tryParse(expense.createdAt);
      if (dateTime == null) continue;

      final formattedMonth = formatter.format(dateTime);

      grouped.putIfAbsent(formattedMonth, () => []).add(expense);
    }

    final groupedList = grouped.entries.map((entry) {
      entry.value.sort((a, b) {
        final aDate = DateTime.tryParse(a.createdAt) ?? DateTime(2000);
        final bDate = DateTime.tryParse(b.createdAt) ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });

      final total = entry.value.fold<double>(
        0.0,
        (sum, item) => sum + item.amount,
      );

      return GroupedExpense(
        date: entry.key,
        expenses: entry.value,
        total: total,
      );
    }).toList();

    // Sort by newest month first
    groupedList.sort(
      (a, b) => DateFormat(
        'MMM yyyy',
      ).parse(b.date).compareTo(DateFormat('MMM yyyy').parse(a.date)),
    );

    return groupedList;
  }

  // static List<GroupedExpense> getExpensesGroupedByDate() {
  //   final box = Hive.box<Expense>(_boxName);
  //   final List<Expense> allExpenses = box.values.toList();

  //   final Map<String, List<Expense>> grouped = {};
  //   final formatter = DateFormat('dd/MM/yyyy');

  //   for (var expense in allExpenses) {
  //     if (expense.createdAt == null) continue;

  //     final dateTime = DateTime.tryParse(expense.createdAt!);
  //     if (dateTime == null) continue;

  //     final formattedDate = formatter.format(dateTime);

  //     grouped.putIfAbsent(formattedDate, () => []).add(expense);
  //   }

  //   final groupedList = grouped.entries.map((entry) {
  //     return GroupedExpense(date: entry.key, expenses: entry.value);
  //   }).toList();

  //   groupedList.sort(
  //     (a, b) => DateFormat(
  //       'dd/MM/yyyy',
  //     ).parse(b.date).compareTo(DateFormat('dd/MM/yyyy').parse(a.date)),
  //   );

  //   return groupedList;
  // }
}
