// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expense_tracker_flutter/features/upcoming_expenses/widgets/add_edit_upcoming_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('AddEditUpcomingDialog renders title and fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AddEditUpcomingDialog(),
          ),
        ),
      ),
    );

    expect(find.text('Add Upcoming Note'), findsOneWidget);
    expect(find.text('Expense Name / What for?'), findsOneWidget);
    expect(find.text('Estimated Amount (Rs)'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Bank'), findsOneWidget);
  });
}
