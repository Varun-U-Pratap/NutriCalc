import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutricalc/providers/profile_provider.dart';
import 'package:nutricalc/screens/dashboard_screen.dart';
import '../models/user_profile.dart';
import '../widgets/custom_input_field.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final bool isAddingNewProfile;
  const OnboardingScreen({super.key, this.isAddingNewProfile = false});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Sex _selectedSex = Sex.male;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderate;
  Goal _selectedGoal = Goal.maintain;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _createProfileAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      final userProfile = UserProfile(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        sex: _selectedSex,
        activityLevel: _selectedActivityLevel,
        goal: _selectedGoal,
      );

      final notifier = ref.read(profileListProvider.notifier);
      final success = await notifier.addProfile(userProfile);

      if (!mounted) return;

      if (success) {
        ref.read(activeProfileProvider.notifier).setActiveProfile(userProfile.name);
        
        if (widget.isAddingNewProfile) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A profile with this name already exists.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we are just adding a new profile, show the form directly and skip the carousel.
    if (widget.isAddingNewProfile) {
      return _buildFormPage(context);
    }

    // Otherwise, build the full onboarding carousel experience.
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildInfoSlide(
                context: context,
                imagePath: 'assets/logo/icon.png', // Make sure you have a logo asset
                title: "Welcome to NutriCalc",
                description: "Your personal guide to understanding and achieving your nutrition goals.",
              ),
              _buildInfoSlide(
                context: context,
                imagePath: 'assets/logo/icon.png',
                title: "Track with Precision",
                description: "Log your meals, calculate your needs, and visualize your progress all in one place.",
              ),
              _buildFormPage(context),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicators
                Row(
                  children: List.generate(3, (index) => _buildIndicator(index == _currentPage)),
                ),
                // Navigation Button
                FloatingActionButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      _createProfileAndNavigate();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Icon(_currentPage == 2 ? Icons.check : Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildInfoSlide({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Image.asset(imagePath, height: 80),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPage(BuildContext context) {
    final theme = Theme.of(context);
    // The form is wrapped in a Scaffold to be a self-contained screen
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddingNewProfile ? "Create New Profile" : "Let's Get Started"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 100.0), // Add padding for FAB
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tell us about yourself",
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomInputField(controller: _nameController, labelText: "Profile Name", hintText: "e.g., Ram", isNumeric: false),
              const SizedBox(height: 16),
              CustomInputField(controller: _ageController, labelText: "Age", hintText: "e.g., 19"),
              const SizedBox(height: 16),
              CustomInputField(controller: _weightController, labelText: "Weight (kg)", hintText: "e.g., 60"),
              const SizedBox(height: 16),
              CustomInputField(controller: _heightController, labelText: "Height (cm)", hintText: "e.g., 170"),
              const SizedBox(height: 24),
              _buildSectionTitle("Biological Sex", theme),
              SegmentedButton<Sex>(
                segments: const [
                  ButtonSegment(value: Sex.male, label: Text("Male"), icon: Icon(Icons.male)),
                  ButtonSegment(value: Sex.female, label: Text("Female"), icon: Icon(Icons.female)),
                ],
                selected: {_selectedSex},
                onSelectionChanged: (s) => setState(() => _selectedSex = s.first),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Activity Level", theme),
              _buildDropdown<ActivityLevel>(
                value: _selectedActivityLevel,
                items: ActivityLevel.values,
                onChanged: (v) => setState(() => _selectedActivityLevel = v!),
                itemLabels: activityLevelLabels,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Your Goal", theme),
              _buildDropdown<Goal>(
                value: _selectedGoal,
                items: Goal.values,
                onChanged: (v) => setState(() => _selectedGoal = v!),
                itemLabels: goalLabels,
              ),
              // The main save button is outside this scroll view when in the carousel
              if (widget.isAddingNewProfile) ...[
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createProfileAndNavigate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text("Save Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
  );

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required Map<T, String> itemLabels,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((T item) => DropdownMenuItem<T>(value: item, child: Text(itemLabels[item]!))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
