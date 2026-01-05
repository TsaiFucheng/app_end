import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_end/app.dart';
import 'package:app_end/services/storage_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 設定 SharedPreferences mock
    SharedPreferences.setMockInitialValues({});

    // 初始化 StorageService
    final storage = StorageService();
    await storage.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(HabitHeroApp(storage: storage));

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app renders (navigation bar should exist)
    expect(find.text('首頁'), findsOneWidget);
  });
}
