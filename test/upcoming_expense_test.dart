import 'package:expense_tracker_flutter/models/upcoming_expense_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpcomingExpense Model Tests', () {
    test('toMap and fromMap should correctly serialize and deserialize', () {
      final expense = UpcomingExpense(
        id: 'test-123',
        docId: 'doc-abc',
        name: 'Internet Bill',
        category: 'bills',
        createdAt: '2026-08-21T16:00:00.000',
        amount: 2500,
        isCash: false,
        note: 'Pay by Friday',
      );

      final map = expense.toMap();
      expect(map['id'], 'test-123');
      expect(map['name'], 'Internet Bill');
      expect(map['amount'], 2500);
      expect(map['isCash'], false);
      expect(map['note'], 'Pay by Friday');

      final deserialized = UpcomingExpense.fromMap(map, 'doc-abc');
      expect(deserialized.id, 'test-123');
      expect(deserialized.docId, 'doc-abc');
      expect(deserialized.name, 'Internet Bill');
      expect(deserialized.category, 'bills');
      expect(deserialized.amount, 2500);
      expect(deserialized.isCash, false);
      expect(deserialized.note, 'Pay by Friday');
    });

    test('fromMap should handle defaults and fallback types gracefully', () {
      final map = <String, dynamic>{
        'name': 'Groceries',
        'amount': '1500', // string amount
      };

      final deserialized = UpcomingExpense.fromMap(map, 'doc-1');
      expect(deserialized.name, 'Groceries');
      expect(deserialized.amount, 1500);
      expect(deserialized.isCash, true);
      expect(deserialized.category, 'others');
      expect(deserialized.docId, 'doc-1');
    });
  });
}
