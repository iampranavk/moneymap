import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymap/model/expense.dart';
import 'package:moneymap/util/currency_formatter.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final String symbol;
  const ExpenseItem({super.key, required this.expense, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatCurrency(expense.amount, symbol),
                style: GoogleFonts.manrope(
                  textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.red[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy hh:mm a').format(
                  DateTime.parse(expense.createdAt.toString()).toLocal(),
                ),
                style: GoogleFonts.manrope(
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          if (expense.note != null) const SizedBox(height: 10),
          if (expense.note != null)
            Text(
              expense.note.toString(),
              style: GoogleFonts.manrope(
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
