class FoodLogEntry {
  final String foodId;
  final String label;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double quantity;
  final DateTime loggedAt;

  FoodLogEntry({
    required this.foodId,
    required this.label,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.quantity = 1.0,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'label': label,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'quantity': quantity,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) => FoodLogEntry(
        foodId: json['foodId'],
        label: json['label'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
        quantity: json['quantity'],
        loggedAt: DateTime.parse(json['loggedAt']),
      );
}