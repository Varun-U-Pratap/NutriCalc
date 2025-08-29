// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/providers/theme_provider.dart';
import 'package:nutricalc/screens/api_keys_screen.dart';
import 'package:nutricalc/screens/developer_info_screen.dart';
import 'package:nutricalc/utils/custom_page_route.dart'; // Import for consistent transitions

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // --- NEW: Method to show the password dialog ---
  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Password required to edit keys",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                // Hardcoded password for simplicity.
                if (passwordController.text == "vuatrsuanv") {
                  Navigator.pop(context); // Close the dialog
                  // Navigate to the API keys screen on success
                  Navigator.push(context, CustomPageRoute(page: const ApiKeysScreen()));
                } else {
                  Navigator.pop(context); // Close the dialog
                  // Show an error message on failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Incorrect password."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: currentTheme == ThemeMode.dark,
            onChanged: (isDarkMode) {
              ref.read(themeProvider.notifier).toggleTheme(isDarkMode);
            },
            secondary: Icon(
              currentTheme == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key_outlined),
            title: const Text("Edit API Keys"),
            subtitle: const Text("Manage keys for external services"),
            onTap: () {
              // --- FIX IS HERE: Show the password dialog instead of navigating directly ---
              _showPasswordDialog(context);
              // -------------------------------------------------------------------------
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About NutriCalc"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AboutDialog(
                  applicationName: 'NutriCalc',
                  applicationVersion: '2.0.0',
                  applicationLegalese: '© 2024 NutriCalc',
                  applicationIcon: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image(image: AssetImage('assets/logo/icon.png'), height: 40),
                  ),
                  children: [
                    SizedBox(height: 16),
                    Text('A personalized nutrition planning app built for the Skill Lab Mini Project.'),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("About the Developers"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeveloperInfoScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
