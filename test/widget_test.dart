import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/widgets/gradient_button.dart';
import 'package:focusflow/core/widgets/glass_card.dart';

void main() {
  testWidgets('GradientButton renders and triggers tap callback',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GradientButton(
              label: 'Start Deep Work',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Start Deep Work'), findsOneWidget);
    await tester.tap(find.text('Start Deep Work'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('GlassCard renders child with blur effects',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassCard(
              child: Text('Glassmorphic Sanctuary'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Glassmorphic Sanctuary'), findsOneWidget);
  });

  test('AppTheme defines Light, Dark, and AMOLED palettes', () {
    expect(AppTheme.lightTheme.brightness, Brightness.light);
    expect(AppTheme.darkTheme.brightness, Brightness.dark);
    expect(AppTheme.amoledTheme.scaffoldBackgroundColor, const Color(0xFF000000));
  });
}
