class SavingsGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String category;
  final String createdAt;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'category': category,
      'createdAt': createdAt,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json, String docId) {
    return SavingsGoal(
      id: docId,
      title: json['title'] ?? '',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Other',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
