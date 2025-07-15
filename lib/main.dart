import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moneymap/hive/expense_helper.dart';
import 'package:moneymap/model/expense.dart';
import 'package:moneymap/shared_preference/shared_preference_helper.dart';
import 'package:moneymap/theme/app_theme.dart';
import 'package:moneymap/ui/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await ExpenseHelper.initBox();
  final defaultSymbol = NumberFormat.currency(locale: Platform.localeName);
  final symbol = NumberFormat.simpleCurrency(name: defaultSymbol.currencyName);
  await SharedPreferencesHelper.setCurrencySymbol(symbol.currencySymbol);
  await SharedPreferencesHelper.setCurrencyCode(defaultSymbol.currencySymbol);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoneyMap',
        theme: moneyMapDarkTheme,
        themeMode: ThemeMode.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
