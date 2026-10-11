import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/dados/banco.dart';
import 'package:chronos_home/main.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('abre na tela inicial com os atalhos das provas', (tester) async {
    final banco = Banco(NativeDatabase.memory());
    addTearDown(banco.close);

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco)));
    await tester.pumpAndSettle();

    expect(find.text('Chronos Home'), findsOneWidget);
    expect(find.text('Bipar'), findsOneWidget);
    expect(find.text('Banco criptografado'), findsOneWidget);
    expect(find.text('Animação'), findsOneWidget);
  });

  test('o banco grava e conta as leituras', () async {
    final banco = Banco(NativeDatabase.memory());
    addTearDown(banco.close);

    await banco.registrarLeitura('7891234567895', 'ean13');
    await banco.registrarLeitura('7891234567895', 'ean13');

    expect(await banco.contarLeituras(), 2);
    final ultimas = await banco.observarUltimas().first;
    expect(ultimas.first.codigo, '7891234567895');
  });

  test('o sqlite3 do projeto é o SQLCipher', () async {
    final banco = Banco(NativeDatabase.memory());
    addTearDown(banco.close);

    expect(await banco.versaoDoSqlcipher(), isNotNull);
  });
}
