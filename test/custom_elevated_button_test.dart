import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/common_widgets/custom_elevated_button.dart';

void main() {
  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CustomElevatedButton(
          child: Text('test'),
          onPressed: () => pressed = true,
        ),
      ),
    );
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.text('test'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
