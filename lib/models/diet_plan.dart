class DietPlan {
  final List<DailyPlan> weeklyPlan;

  DietPlan({required this.weeklyPlan});

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    var list = json['weeklyPlan'] as List;
    List<DailyPlan> weeklyPlanList = list.map((i) => DailyPlan.fromJson(i)).toList();
    return DietPlan(weeklyPlan: weeklyPlanList);
  }
}

class DailyPlan {
  final String day;
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  DailyPlan({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      day: json['day'],
      breakfast: Meal.fromJson(json['breakfast']),
      lunch: Meal.fromJson(json['lunch']),
      dinner: Meal.fromJson(json['dinner']),
    );
  }
}

class Meal {
  final String name;
  final String description;

  Meal({required this.name, required this.description});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      description: json['description'],
    );
  }
}
