import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _currencySymbolKey = 'currency_symbol';
  static const _currencyCodeKey =
      'currency_code'; // optional, if you want it later

  // Save the currency symbol (e.g., ₹, $, €)
  static Future<void> setCurrencySymbol(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencySymbolKey, symbol);
  }

  // Get the currency symbol (default ₹)
  static Future<String> getCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencySymbolKey) ?? '₹';
  }

  // (Optional) Save currency code like 'INR', 'USD'
  static Future<void> setCurrencyCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyCodeKey, code);
  }

  // (Optional) Get currency code
  static Future<String?> getCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyCodeKey);
  }
}
