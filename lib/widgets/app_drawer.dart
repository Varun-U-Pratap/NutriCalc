import 'package:flutter/material.dart';
import 'package:nutricalc/screens/chat_screen.dart';
import 'package:nutricalc/screens/daily_log_screen.dart';
import 'package:nutricalc/screens/profile_selection_screen.dart';
import 'package:nutricalc/screens/profile_screen.dart';
import 'package:nutricalc/screens/reports_screen.dart';
import 'package:nutricalc/screens/settings_screen.dart';
import 'package:nutricalc/utils/custom_page_route.dart'; // Import the new route

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/icon.png',
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'NutriCalc',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          // --- FIX IS HERE: All navigations now use CustomPageRoute ---
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text('Calix Assistant'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, CustomPageRoute(page: const ChatScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Reports & History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, CustomPageRoute(page: const ReportsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Daily Log'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, CustomPageRoute(page: const DailyLogScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, CustomPageRoute(page: const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, CustomPageRoute(page: const SettingsScreen()));
            },
          ),
          // -----------------------------------------------------------------
          const Divider(),
          ListTile(
            leading: const Icon(Icons.switch_account_outlined),
            title: const Text('Switch Profile'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                CustomPageRoute(page: const ProfileSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
