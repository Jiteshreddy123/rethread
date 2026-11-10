import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethread/app.dart';

void main() {
  testWidgets('ReThread Phase 2 initial smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ReThreadApp(),
      ),
    );

    // Initial route is /splash which displays ReThread brand name
    expect(find.text('ReThread'), findsOneWidget);
    expect(find.text('Give unused things another life.'), findsOneWidget);
  });
}
