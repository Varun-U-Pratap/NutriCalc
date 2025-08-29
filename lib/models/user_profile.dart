import 'dart:convert';

enum Sex { male, female }
enum Goal { lose, maintain, gain }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

const Map<ActivityLevel, String> activityLevelLabels = {
  ActivityLevel.sedentary: "Sedentary (little to no exercise)",
  ActivityLevel.light: "Lightly Active (1-3 days/week)",
  ActivityLevel.moderate: "Moderately Active (3-5 days/week)",
  ActivityLevel.active: "Active (6-7 days/week)",
  ActivityLevel.veryActive: "Very Active (physical job/daily exercise)",
};

const Map<Goal, String> goalLabels = {
  Goal.lose: "Lose Weight",
  Goal.maintain: "Maintain Weight",
  Goal.gain: "Gain Muscle",
};

class UserProfile {
  final String name;
  final int age;
  final double weight;
  final double height;
  final Sex sex;
  final ActivityLevel activityLevel;
  final Goal goal;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.sex,
    required this.activityLevel,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'sex': sex.toString(),
      'activityLevel': activityLevel.toString(),
      'goal': goal.toString(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      sex: Sex.values.firstWhere((e) => e.toString() == json['sex']),
      activityLevel: ActivityLevel.values.firstWhere((e) => e.toString() == json['activityLevel']),
      goal: Goal.values.firstWhere((e) => e.toString() == json['goal']),
    );
  }
}