import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offcast/app.dart';

void main() {
  testWidgets('App renders placeholder screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: OffcastApp(),
      ),
    );

    // Verify that the title 'Offcast' is found.
    expect(find.text('Offcast'), findsOneWidget);
  });
}
