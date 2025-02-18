import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> transactions = [];
  final Map<String, Color> categoryColors = {};
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
  super.initState();
  _initSharedPreferences().then((value) => _loadTransactions());
}

Future<void> _initSharedPreferences() async {
  _prefs = await SharedPreferences.getInstance();
  _loadTransactions();
  _loadCategoryColors();
}

Future<void> _loadCategoryColors() async {
  final categoryColorsJson = _prefs.getString('categoryColors');
  if (categoryColorsJson != null) {
    final categoryColorsMap = jsonDecode(categoryColorsJson) as Map<String, dynamic>;
    setState(() {
      categoryColors.clear();
      categoryColors.addAll(categoryColorsMap.map((key, value) {
        return MapEntry(key, Color(int.parse(value)));
      }));
    });
  }
}

Future<void> _saveCategoryColors() async {
  final categoryColorsJson = jsonEncode(categoryColors.map((key, value) {
    return MapEntry(key, value.value.toRadixString(16));
  }));
  await _prefs.setString('categoryColors', categoryColorsJson);
}

Future<void> _loadTransactions() async {
  final transactionsJson = _prefs.getString('transactions');
  if (transactionsJson != null) {
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;
    setState(() {
      transactions.clear();
      transactions.addAll(transactionsList.map((transaction) {
        return {
          'name': transaction['name'],
          'category': transaction['category'],
          'amount': transaction['amount'].toDouble(),
        };
      }));
    });
  }
}

Future<void> _saveTransactions() async {
  final transactionsJson = jsonEncode(transactions);
  await _prefs.setString('transactions', transactionsJson);
}

  @override
  void dispose() {
    _itemController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  //calculate category totals
  Map<String, double> _getCategoryTotals() {
    Map<String, double> totals = {};
    for (var transaction in transactions) {
      String category = transaction['category'];
      double amount = transaction['amount'];
      if (totals.containsKey(category)) {
        totals[category] = totals[category]! + amount;
      } else {
        totals[category] = amount;
      }
    }
    return totals;
  }

  //generate random color for categories
  Color _getCategoryColor(String category) {
    String lowercaseCategory = category.toLowerCase();
    if (!categoryColors.containsKey(lowercaseCategory)) {
      categoryColors[lowercaseCategory] =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
        _saveCategoryColors();
    }
    return categoryColors[lowercaseCategory]!;
  }

  void _addTransaction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  transactions.add({
                    'name': _itemController.text,
                    'category': _categoryController.text,
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                  });
                  _itemController.clear();
                  _categoryController.clear();
                  _amountController.clear();
                });
                _saveTransactions();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _resetAnalysis() {
    setState(() {
      transactions.clear();
      categoryColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _getCategoryTotals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //pie Chart for Category Breakdown
            const Text(
              'Category Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((entry) {
                    return PieChartSectionData(
                      color: _getCategoryColor(entry.key),
                      value: entry.value,
                      title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),

            //list of Transactions
            const Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions available.'))
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: Icon(Icons.monetization_on,
                              color: _getCategoryColor(transaction['category'])),
                          title: Text(
                              '${transaction['name']} (${transaction['category']})'),
                          trailing: Text(
                              '-\$${transaction['amount'].toStringAsFixed(2)}'),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addTransaction,
                  child: const Text('Add Transaction'),
                ),
                ElevatedButton(
                  onPressed: _resetAnalysis,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
