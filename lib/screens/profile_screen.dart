import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/models/user_profile.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/widgets/custom_input_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  Sex? _selectedSex;
  ActivityLevel? _selectedActivityLevel;
  Goal? _selectedGoal;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(activeProfileProvider).value;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _weightController = TextEditingController(text: profile?.weight.toString() ?? '');
    _heightController = TextEditingController(text: profile?.height.toString() ?? '');
    _selectedSex = profile?.sex;
    _selectedActivityLevel = profile?.activityLevel;
    _selectedGoal = profile?.goal;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    // This logic would need to be updated to handle name changes,
    // which would involve deleting the old profile and adding a new one.
    // For simplicity, we'll assume the name is not editable for now.
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        name: _nameController.text, // Assuming name is not changed
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        sex: _selectedSex!,
        activityLevel: _selectedActivityLevel!,
        goal: _selectedGoal!,
      );
      
      // A more robust implementation would handle name changes.
      // For now, we just re-add the profile which will overwrite it.
      await ref.read(profileListProvider.notifier).deleteProfile(updatedProfile.name);
      await ref.read(profileListProvider.notifier).addProfile(updatedProfile);
      ref.read(activeProfileProvider.notifier).setActiveProfile(updatedProfile.name);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: profileState.when(
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(controller: _nameController, labelText: "Profile Name", hintText: "e.g., John", isNumeric: false, readOnly: true),
                const SizedBox(height: 16),
                CustomInputField(controller: _ageController, labelText: "Age", hintText: "e.g., 25"),
                const SizedBox(height: 16),
                CustomInputField(controller: _weightController, labelText: "Weight (kg)", hintText: "e.g., 70"),
                const SizedBox(height: 16),
                CustomInputField(controller: _heightController, labelText: "Height (cm)", hintText: "e.g., 175"),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text("Could not load profile.")),
      ),
    );
  }
}