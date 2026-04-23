import 'package:capytify/features/auth/presentation/screens/auth_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('auth choice screen renders standalone', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthChoiceScreen()));

    expect(find.text('Sign up free'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });
}
