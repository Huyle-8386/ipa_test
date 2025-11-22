import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chart_data_model.dart';

/// ChartDataSource fetches transactions and aggregates them into ChartDataModel
class ChartDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChartDataSource({required this.firestore, required this.auth});

  /// Get chart data aggregated by the filter: "Weekly" | "Monthly" | "Yearly"
  Future<List<ChartDataModel>> getChartData(String filter) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final uid = user.uid;

    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .get();

    final docs = snap.docs;

    // Convert to simple list of maps for processing
    final transactions = docs.map((d) {
      final data = d.data();
      final ts = data['dateTime'];
      DateTime dt;
      if (ts is Timestamp)
        dt = ts.toDate();
      else if (ts is DateTime)
        dt = ts;
      else
        dt = DateTime.now();

      final amount = (data['amount'] ?? 0).toDouble();
      final isIncome = (data['isIncome'] ?? false) as bool;

      return {'date': dt, 'amount': amount, 'isIncome': isIncome};
    }).toList();

    if (filter == 'Weekly') {
      return _aggregateWeekly(transactions);
    } else if (filter == 'Monthly') {
      return _aggregateMonthly(transactions);
    } else if (filter == 'Yearly') {
      return _aggregateYearly(transactions);
    }

    // default weekly
    return _aggregateWeekly(transactions);
  }

  List<ChartDataModel> _aggregateWeekly(List<Map<String, dynamic>> txs) {
    // Produce 4-week buckets: current week (Mon-Sun) and 3 previous weeks
    final now = DateTime.now();

    // Find current week Monday start
    DateTime startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
    // For display ensure week covers Monday..Sunday

    final weeks = List.generate(4, (i) {
      final weekStart = startOfCurrentWeek.subtract(
        Duration(days: 7 * (3 - i)),
      );
      final weekEnd = weekStart.add(Duration(days: 6));
      return {'start': weekStart, 'end': weekEnd};
    });

    final result = <ChartDataModel>[];
    for (final w in weeks) {
      double income = 0.0;
      double expense = 0.0;
      for (final t in txs) {
        final d = t['date'] as DateTime;
        if (!d.isBefore(_startOfDay(w['start'] as DateTime)) &&
            !d.isAfter(_endOfDay(w['end'] as DateTime))) {
          final amt = (t['amount'] as double);
          if (t['isIncome'] as bool)
            income += amt;
          else
            expense += amt;
        }
      }
      final label =
          '${_formatDate(w['start'] as DateTime)} - ${_formatDateShort(w['end'] as DateTime)}';
      result.add(ChartDataModel(day: label, income: income, expense: expense));
    }

    return result;
  }

  List<ChartDataModel> _aggregateMonthly(List<Map<String, dynamic>> txs) {
    // Produce columns from Jan..currentMonth (1..now.month) for the current year
    final now = DateTime.now();
    final year = now.year;
    final result = <ChartDataModel>[];

    for (int m = 1; m <= now.month; m++) {
      double income = 0.0;
      double expense = 0.0;
      for (final t in txs) {
        final d = t['date'] as DateTime;
        if (d.year == year && d.month == m) {
          final amt = (t['amount'] as double);
          if (t['isIncome'] as bool)
            income += amt;
          else
            expense += amt;
        }
      }
      result.add(
        ChartDataModel(day: m.toString(), income: income, expense: expense),
      );
    }

    return result;
  }

  List<ChartDataModel> _aggregateYearly(List<Map<String, dynamic>> txs) {
    // Last 4 years including current
    final now = DateTime.now();
    final years = List.generate(4, (i) => now.year - (3 - i));
    final result = <ChartDataModel>[];

    for (final y in years) {
      double income = 0.0;
      double expense = 0.0;
      for (final t in txs) {
        final d = t['date'] as DateTime;
        if (d.year == y) {
          final amt = (t['amount'] as double);
          if (t['isIncome'] as bool)
            income += amt;
          else
            expense += amt;
        }
      }
      result.add(
        ChartDataModel(day: y.toString(), income: income, expense: expense),
      );
    }

    return result;
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}';
  }

  String _formatDateShort(DateTime d) {
    return '${d.day}/${d.month}';
  }
}
