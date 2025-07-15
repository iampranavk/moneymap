String formatCurrency(double amount, String symbol) {
  return '$symbol${amount.toStringAsFixed(2)}';
}
