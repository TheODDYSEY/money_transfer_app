// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:money_transfer_app/main.dart';

void main() {
  testWidgets('SwiftPay app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MoneyTransferApp());

    // Verify that the login page loads with SwiftPay title.
    expect(find.text('SwiftPay'), findsOneWidget);
    expect(find.text('Send money instantly, securely'), findsOneWidget);

    // Verify that login form elements exist.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
