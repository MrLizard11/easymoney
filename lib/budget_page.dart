import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<Map<String, dynamic>> budgets = [];
  Map<String, Color> categoryColors = {};

  //controllers for input fields
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _itemController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Load budgets from SharedPreferences
  Future<void> _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    String? budgetsJson = prefs.getString('budgets');
    String? colorsJson = prefs.getString('categoryColors');
    if (budgetsJson != null) {
      setState(() {
      budgets = List<Map<String, dynamic>>.from(
          json.decode(budgetsJson).map((x) => Map<String, dynamic>.from(x)));
      });
    }
    if (colorsJson != null) {
      Map<String, dynamic> colorMap = json.decode(colorsJson);
      categoryColors = colorMap.map((key, value) => MapEntry(key, Color(value)));
    }
  }

  Future<void> _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    String budgetsJson = json.encode(budgets);
    await prefs.setString('budgets', budgetsJson);

    Map<String, int> colorValues =
        categoryColors.map((key, value) => MapEntry(key, value.value));
    String colorsJson = json.encode(colorValues);
    await prefs.setString('categoryColors', colorsJson);
  }

  void _createNewBudget() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Transactions"),
          content: TextField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter income amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_incomeController.text.isEmpty) {
                  // Show an error message if the income field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid income amount')),
                  );
                } else {
                  double income = double.tryParse(_incomeController.text) ?? 0.0;
                  setState(() {
                    budgets.add({
                      'income': income,
                      'items': [],
                    });
                  });
                  _saveBudgets(); // Save after adding a new budget
                  _incomeController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // add item to a budget
  void _addItem(int budgetIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  final newItem = {
                    'name': _itemController.text,
                    'category': _categoryController.text,
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                  };
                  budgets[budgetIndex]['items'].add(newItem);
                  _saveBudgets(); //save after adding an item
                  _itemController.clear();
                  _categoryController.clear();
                  _amountController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Add Item'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // delete a budget
  void _deleteBudget(int index) {
    setState(() {
      budgets.removeAt(index);
      _saveBudgets(); 
    });
  }

  //calculate the total amount in each category
  Map<String, double> _getCategoryTotals(int budgetIndex) {
    Map<String, double> categoryTotals = {};
    double totalExpenses = 0;
    for (var item in budgets[budgetIndex]['items']) {
      String category = item['category'];
      double amount = item['amount'];
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
      totalExpenses += amount;
    }

    //calculate remaining money
    double income = budgets[budgetIndex]['income'];
    double remainingMoney = income - totalExpenses;
    if (remainingMoney > 0) {
      categoryTotals['Remaining Money'] = remainingMoney;
    }

    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //create New Budget Button
            ElevatedButton(
              onPressed: _createNewBudget,
              child: const Text('Create'),
            ),
            const SizedBox(height: 20),

            //list of Budgets
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];

                  Map<String, double> categoryTotals =
                      _getCategoryTotals(index);

                  //pie chart data
                  List<PieChartSectionData> pieSections =
                      categoryTotals.entries.map((entry) {
                    Color color = entry.key == 'Remaining Money'
                        ? Colors.green
                        : _getCategoryColor(entry.key);
                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      title: entry.key == 'Remaining Money'
                          ? 'Remaining\n\$${entry.value.toStringAsFixed(2)}'
                          : '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
                      radius: 50,
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }).toList();

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //income
                              Text(
                                'Income: \$${budget['income'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //delete Button
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteBudget(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          //pie Chart
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: pieSections,
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //add Item Button
                          ElevatedButton(
                            onPressed: () => _addItem(index),
                            child: const Text('Add Item'),
                          ),
                          const SizedBox(height: 10),

                          //list of items
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: budget['items'].map<Widget>((item) {
                              return ListTile(
                                leading: Icon(Icons.monetization_on,
                                    color: Colors.red),
                                title: Text(
                                    item['category'] + ": " + item['name']),
                                trailing: Text(
                                    '-\$${item['amount'].toStringAsFixed(2)}'),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // get category color for pie chart
  Color _getCategoryColor(String category) {
    String lowercaseCategory = category.toLowerCase();
    if (!categoryColors.containsKey(lowercaseCategory)) {
      // Generate a random color for the new category
      categoryColors[lowercaseCategory] =
          Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0);
    }
    return categoryColors[lowercaseCategory]!;
  }
}
