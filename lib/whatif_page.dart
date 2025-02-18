import 'package:flutter/material.dart';

// What-If Page
class WhatIfPage extends StatelessWidget {
  const WhatIfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Text(
            'What-If Scenarios',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Scenario Analysis Section
          Text(
            'Scenario Analysis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What if you saved an extra \$200 each month?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Projected Savings in 5 Years: \$15,000.00',
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Impact of Investment Section
          Text(
            'Impact of Investment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What if you invested \$1,000 in Tesla 5 years ago?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Current Value: \$7,500.00',
                  style: TextStyle(fontSize: 20, color: Colors.green.shade900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Loan Impact Section
          Text(
            'Impact of Loan Repayment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What if you paid an extra \$100 on your loan each month?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Loan Paid Off 1 Year Earlier',
                  style: TextStyle(fontSize: 20, color: Colors.red.shade900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Retirement Planning Section
          Text(
            'Retirement Planning',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What if you contribute \$500 monthly to your retirement account?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Estimated Retirement Savings in 20 Years: \$250,000.00',
                  style: TextStyle(fontSize: 20, color: Colors.orange.shade900),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.orange.shade300,
                  color: Colors.orange.shade900,
                ),
                const SizedBox(height: 10),
                Text(
                  'Progress: 60%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Savings Growth Tips Section
          Text(
            'Savings Growth Tips',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.lightbulb, color: Colors.purple.shade900),
                  title: Text('Increase Contributions Gradually'),
                  subtitle: Text('Add a small percentage to your savings every year.'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.purple.shade900),
                  title: Text('Reduce Unnecessary Expenses'),
                  subtitle: Text('Redirect saved expenses into your savings or investments.'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.trending_up, color: Colors.purple.shade900),
                  title: Text('Take Advantage of Employer Matching'),
                  subtitle: Text('Maximize contributions if your employer offers matching funds.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
