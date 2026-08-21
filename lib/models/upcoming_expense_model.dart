import 'dart:convert';

class UpcomingExpense {
  final String id;
  String? docId;
  final String name;
  final String category;
  final String createdAt;
  final int amount;
  final bool isCash;
  final String? note;

  UpcomingExpense({
    required this.id,
    this.docId,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.amount,
    required this.isCash,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'docId': docId,
      'category': category,
      'createdAt': createdAt,
      'amount': amount,
      'isCash': isCash,
      'note': note,
    };
  }

  factory UpcomingExpense.fromMap(Map<String, dynamic> map, [String? docId]) {
    return UpcomingExpense(
      id: (map['id'] ?? docId ?? '') as String,
      docId: docId ?? map['docId'] as String?,
      name: (map['name'] ?? '') as String,
      category: (map['category'] ?? 'others') as String,
      createdAt: (map['createdAt'] ?? DateTime.now().toIso8601String()) as String,
      amount: (map['amount'] is num)
          ? (map['amount'] as num).toInt()
          : int.tryParse(map['amount']?.toString() ?? '0') ?? 0,
      isCash: (map['isCash'] is bool) ? map['isCash'] as bool : true,
      note: map['note'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpcomingExpense.fromJson(String source, [String? docId]) =>
      UpcomingExpense.fromMap(
          json.decode(source) as Map<String, dynamic>, docId);
}
