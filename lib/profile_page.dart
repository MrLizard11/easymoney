import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:easymoney/dashboard_page.dart';

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
          title: Text('Account Settings', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
          title: Text('Privacy & Security', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
          title: Text('Notifications', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment, color: Theme.of(context).colorScheme.primary),
          title: Text('Payment Methods', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
          title: Text('Transaction History', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help, color: Theme.of(context).colorScheme.primary),
          title: Text('Help & Support', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
          title: Text('Logout', style: TextStyle(fontSize: 18)),
          onTap: () {},
        ),
      ],
    );
  }
}
