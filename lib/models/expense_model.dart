import 'dart:convert';


class Expense {
  final String id;
  String? docId;
  final String name;
  final String category;
  final String createAt;
  final String updatedAt;
  final int amount;
  final bool isCash;

  Expense(
      {required this.id,
      this.docId,
      required this.name,
      required this.category,
      required this.createAt,
      required this.updatedAt,
      required this.amount,
      required this.isCash});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'docId': docId,
      'category': category,
      'createAt': createAt,
      'updatedAt': updatedAt,
      'amount': amount,
      'isCash': isCash,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      docId: map['docId'] as String?,
      name: map['name'] as String,
      category: map['category'] as String,
      createAt: map['createAt'] as String,
      updatedAt: map['updatedAt'] as String,
      amount: map['amount'] as int,
      isCash: map['isCash'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source) as Map<String, dynamic>);
}
