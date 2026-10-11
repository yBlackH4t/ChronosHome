import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/main.dart';

void main() {
  testWidgets('abre na tela inicial com o nome do app', (tester) async {
    await tester.pumpWidget(const ChronosHomeApp());

    expect(find.text('Chronos Home'), findsOneWidget);
    expect(find.text('Estoque da casa'), findsOneWidget);
  });
}
