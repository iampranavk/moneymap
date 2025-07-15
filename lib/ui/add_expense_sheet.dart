import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymap/hive/expense_helper.dart';
import 'package:moneymap/model/expense.dart';
import 'package:moneymap/shared_preference/shared_preference_helper.dart';

class AddExpenseSheet extends StatefulWidget {
  final Function() onSave;
  const AddExpenseSheet({super.key, required this.onSave});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String symbol = '';

  @override
  void initState() {
    _getCurrencySymbol();
    super.initState();
  }

  void _getCurrencySymbol() async {
    symbol = await SharedPreferencesHelper.getCurrencySymbol();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_outlined,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Enter amount and an optional note',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    double.tryParse(value.toString()) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefix: Text(symbol),
                prefixStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
                hintText: '0',
                hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Optional note/description
            TextField(
              controller: noteController,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                hintStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final amount = amountController.text.trim();
                    final note = noteController.text.trim();
                    final now = DateTime.now();
                    final newExpense = Expense()
                      ..amount = double.parse(amount.toString())
                      ..note = note.isEmpty ? null : note.toString()
                      ..createdAt = now.toIso8601String();

                    await ExpenseHelper.addExpense(newExpense);
                    if (context.mounted) {
                      widget.onSave();
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
