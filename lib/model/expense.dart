import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  late double amount;

  @HiveField(1)
  String? note;

  @HiveField(2)
  late String createdAt;
}
