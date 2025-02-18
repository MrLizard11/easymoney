import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/savings.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  List<Savings> savingsGoals = [];
  late SharedPreferences _prefs;

  // Controllers for input fields
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _currentBalanceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences().then((value) => _loadSavingsData());
  }

  Future<void> _initSharedPreferences() async {
  _prefs = await SharedPreferences.getInstance();
}

  @override
  void dispose() {
    _categoryController.dispose();
    _targetAmountController.dispose();
    _periodController.dispose();
    _currentBalanceController.dispose();
    super.dispose();
  }

  Future<void> _loadSavingsData() async {
    final savingsJson = _prefs.getString('savings');
    if (savingsJson != null) {
      final jsonData = json.decode(savingsJson);
      setState(() {
        savingsGoals = (jsonData['savings'] as List)
            .map((item) => Savings.fromJson(item))
            .toList();
      });
    }
  }

  Future<void> _saveSavingsData() async {
    final jsonData = {
      'savings': savingsGoals.map((goal) => goal.toJson()).toList()
    };
    await _prefs.setString('savings', json.encode(jsonData));
  }

  void _createNewSavingsGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Savings Goal'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _targetAmountController,
                  decoration: InputDecoration(labelText: 'Target Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _periodController,
                  decoration: InputDecoration(labelText: 'Period (months)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _currentBalanceController,
                  decoration: InputDecoration(labelText: 'Current Balance'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                double targetAmount =
                    double.parse(_targetAmountController.text);
                double currentBalance =
                    double.parse(_currentBalanceController.text);
                int period = int.parse(_periodController.text);
                double monthlyAmount = (targetAmount - currentBalance) / period;

                setState(() {
                  savingsGoals.add(Savings(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: 'user1',
                    category: _categoryController.text,
                    targetAmount: targetAmount,
                    period: _periodController.text,
                    amount: monthlyAmount,
                    currentBalance: currentBalance,
                  ));
                });
                _saveSavingsData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editSavingsGoal(int index) {
    final goal = savingsGoals[index];
    _categoryController.text = goal.category;
    _targetAmountController.text = goal.targetAmount.toString();
    _periodController.text = goal.period;
    _currentBalanceController.text = goal.currentBalance.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Savings Goal'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _targetAmountController,
                  decoration: InputDecoration(labelText: 'Target Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _periodController,
                  decoration: InputDecoration(labelText: 'Period (months)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _currentBalanceController,
                  decoration: InputDecoration(labelText: 'Current Balance'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                double targetAmount =
                    double.parse(_targetAmountController.text);
                double currentBalance =
                    double.parse(_currentBalanceController.text);
                int period = int.parse(_periodController.text);
                double monthlyAmount = (targetAmount - currentBalance) / period;

                setState(() {
                  savingsGoals[index] = Savings(
                    id: goal.id,
                    userId: goal.userId,
                    category: _categoryController.text,
                    targetAmount: targetAmount,
                    period: _periodController.text,
                    amount: monthlyAmount,
                    currentBalance: currentBalance,
                  );
                });
                _saveSavingsData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSavingsGoal(int index) {
    setState(() {
      savingsGoals.removeAt(index);
    });
    _saveSavingsData();
  }

  Widget _buildProgressChart(Savings goal) {
    double progress = goal.currentBalance / goal.targetAmount;
    return SizedBox(
      height: 20,
      width: 1200,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        minHeight: 20,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings Goals'),
      ),
      body: ListView.builder(
        itemCount: savingsGoals.length,
        itemBuilder: (context, index) {
          final goal = savingsGoals[index];
          return Card(
            child: ListTile(
              title: Text(goal.category),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Target: \$${goal.targetAmount.toStringAsFixed(2)}'),
                  Text('Current: \$${goal.currentBalance.toStringAsFixed(2)}'),
                  Text('Monthly: \$${goal.amount.toStringAsFixed(2)}'),
                  _buildProgressChart(goal),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteSavingsGoal(index),
              ),
              onTap: () => _editSavingsGoal(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewSavingsGoal,
        child: Icon(Icons.add),
      ),
    );
  }
}
