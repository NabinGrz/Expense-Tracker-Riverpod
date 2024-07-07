import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseEntity {
  final String? name;
  final int? amount;
  final String? category;
  final bool? isCash;

  ExpenseEntity({
    this.name,
    this.amount,
    this.category,
    this.isCash,
  });

  ExpenseEntity copyWith(
      {String? name, int? amount, String? category, bool? isCash}) {
    return ExpenseEntity(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isCash: isCash ?? this.isCash,
    );
  }

  static ExpenseEntity initial() {
    return ExpenseEntity(
      name: null,
      amount: null,
      category: null,
      isCash: null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'category': category,
      'isCash': isCash,
    };
  }

  factory ExpenseEntity.fromMap(Map<String, dynamic> map) {
    return ExpenseEntity(
      name: map['name'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      isCash: map['isCash'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseEntity.fromJson(String source) =>
      ExpenseEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
