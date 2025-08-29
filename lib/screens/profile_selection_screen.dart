// lib/screens/profile_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/screens/dashboard_screen.dart';
import 'package:nutricalc/screens/onboarding_screen.dart';
import 'package:nutricalc/widgets/animated_list_item.dart';

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profileListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Select Profile"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: profilesAsync.when(
          data: (profiles) {
            if (profiles.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No profiles found."),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                    }, 
                    child: const Text("Create a Profile"),
                  )
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Who's calculating?",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ...profiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      var profile = entry.value;
                      return AnimatedListItem(
                        index: index,
                        child: _ProfileAvatar(
                          name: profile.name,
                          onTap: () {
                            ref.read(activeProfileProvider.notifier).setActiveProfile(profile.name);
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const DashboardScreen(),
                                transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                              )
                            );
                          },
                          onDelete: () async {
                            HapticFeedback.heavyImpact();
                            final wasActive = ref.read(activeProfileProvider).value?.name == profile.name;
                            await ref.read(profileListProvider.notifier).deleteProfile(profile.name);
                            
                            // --- FIX IS HERE: Check if context is still valid ---
                            if (!context.mounted) return;
                            // ----------------------------------------------------

                            if (wasActive) {
                              await ref.read(activeProfileProvider.notifier).clearActiveProfile();
                            }
                          },
                        ),
                      );
                    }).toList(),
                    AnimatedListItem(
                      index: profiles.length,
                      child: _AddProfileAvatar(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OnboardingScreen(isAddingNewProfile: true)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProfileAvatar({required this.name, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[300]),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            )
          ],
        )
      ],
    );
  }
}

class _AddProfileAvatar extends StatelessWidget {
  final VoidCallback onTap;
  const _AddProfileAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            child: Icon(Icons.add, size: 40, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        const SizedBox(height: 10),
        Text("Add Profile", style: Theme.of(context).textTheme.titleMedium)
      ],
    );
  }
}
