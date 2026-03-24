import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:icon_gallery/main.dart';

void main() {
  testWidgets('Gallery renders with all device types',
      (WidgetTester tester) async {
    // Use a tall surface so all grid items are visible.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const IconGalleryApp());
    await tester.pumpAndSettle();

    expect(find.text('Network'), findsOneWidget);
    expect(find.text('Switch'), findsOneWidget);
    expect(find.text('Host'), findsOneWidget);
    expect(find.text('DPU'), findsOneWidget);
    expect(find.text('Router'), findsOneWidget);
    expect(find.text('Firewall'), findsOneWidget);
    expect(find.text('Server'), findsOneWidget);
    expect(find.text('Generic'), findsOneWidget);
    expect(find.text('Unknown'), findsOneWidget);
  });
}
