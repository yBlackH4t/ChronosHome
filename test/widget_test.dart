import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:chronos_home/dados/banco.dart';
import 'package:chronos_home/main.dart';
import 'package:chronos_home/servicos/open_food_facts.dart';
import 'package:chronos_home/telas/produto_novo.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Banco banco;

  setUp(() => banco = Banco(NativeDatabase.memory()));
  tearDown(() => banco.close());

  OpenFoodFacts semInternet() =>
      OpenFoodFacts(cliente: MockClient((_) async => throw Exception('sem rede')));

  /// Dá tempo para o banco e o Open Food Facts (falso) responderem e redesenha a tela.
  /// Não usa pumpAndSettle porque as rodinhas de carregamento giram sem parar.
  Future<void> esperar(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  /// Desmonta as telas para o drift encerrar as consultas que observam o banco.
  Future<void> encerrar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('estoque vazio mostra a orientação e os botões Compras e Cozinha', (tester) async {
    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);

    expect(find.text('Chronos Home'), findsOneWidget);
    expect(find.textContaining('O estoque está vazio'), findsOneWidget);
    expect(find.text('Compras'), findsOneWidget);
    expect(find.text('Cozinha'), findsOneWidget);
    await encerrar(tester);
  });

  testWidgets('Agora mostra o aberto; Comprar mostra a lista com o número na aba', (tester) async {
    await tester.runAsync(() async {
      final maionese = await banco.cadastrarProduto(nome: 'Maionese', diasValidadeAberto: 5);
      final [u] = await banco.darEntrada(maionese);
      await banco.abrir(u);
      final arroz = await banco.cadastrarProduto(nome: 'Arroz', estoqueMinimo: 2);
      await banco.darEntrada(arroz);
    });

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);

    expect(find.text('Abertos'), findsOneWidget);
    expect(find.text('Aberto hoje · ainda 5 dias'), findsOneWidget);
    expect(find.textContaining('Acabando'), findsOneWidget);

    await tester.tap(find.text('Comprar'));
    await esperar(tester);
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Tem 1 · mínimo 2'), findsOneWidget);
    expect(find.text('Copiar a lista'), findsOneWidget);
    await encerrar(tester);
  });

  testWidgets('Agora mostra o que vence amanhã', (tester) async {
    final amanha = DateTime.now().add(const Duration(days: 1));
    await tester.runAsync(() async {
      final id = await banco.cadastrarProduto(nome: 'Iogurte');
      await banco.darEntrada(id, venceEm: amanha);
    });

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);

    expect(find.textContaining('Vencendo'), findsOneWidget);
    expect(find.textContaining('vence amanhã'), findsOneWidget);
    await encerrar(tester);
  });

  testWidgets('no painel, o + do estoque mínimo põe o produto na lista de compras', (tester) async {
    await tester.runAsync(() async {
      final id = await banco.cadastrarProduto(nome: 'Café');
      await banco.darEntrada(id);
    });

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);
    await tester.tap(find.text('Estoque'));
    await esperar(tester);
    await tester.tap(find.text('Café'));
    await esperar(tester);

    await tester.tap(find.byTooltip('Estoque mínimo: mais'));
    await esperar(tester);
    await tester.tap(find.byTooltip('Estoque mínimo: mais'));
    await esperar(tester);
    await tester.tapAt(const Offset(10, 10)); // fecha o painel
    await esperar(tester);

    await tester.tap(find.text('Comprar'));
    await esperar(tester);
    expect(find.text('Tem 1 · mínimo 2'), findsOneWidget);
    await encerrar(tester);
  });

  testWidgets('tocar no produto abre o painel; Abrir e depois Desfazer', (tester) async {
    late String id;
    await tester.runAsync(() async {
      id = await banco.cadastrarProduto(nome: 'Extrato de tomate');
      await banco.darEntrada(id, quantidade: 2);
    });

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);
    await tester.tap(find.text('Estoque'));
    await esperar(tester);
    await tester.tap(find.text('Extrato de tomate'));
    await esperar(tester);

    // Nada aberto ainda: a sugestão principal é Abrir.
    expect(find.text('2 fechados'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Abrir'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Acabou'), findsOneWidget);

    await tester.tap(find.text('Abrir'));
    await esperar(tester);
    expect(find.text('Extrato de tomate: aberto'), findsOneWidget);
    final abertos = await tester.runAsync(() async =>
        (await banco.unidadesEmCasa(id)).where((u) => u.estado == EstadoUnidade.aberto).length);
    expect(abertos, 1);

    // Com um aberto, a sugestão principal passa a ser Acabou.
    await tester.tap(find.text('Extrato de tomate'));
    await esperar(tester);
    expect(find.widgetWithText(FilledButton, 'Acabou'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // fecha o painel
    await esperar(tester);

    await tester.tap(find.text('Desfazer'));
    await esperar(tester);
    final abertosDepois = await tester.runAsync(() async =>
        (await banco.unidadesEmCasa(id)).where((u) => u.estado == EstadoUnidade.aberto).length);
    expect(abertosDepois, 0);
    await encerrar(tester);
  });

  testWidgets('o estoque lista os produtos com a quantidade em casa', (tester) async {
    await tester.runAsync(() async {
      final id = await banco.cadastrarProduto(nome: 'Maionese', marca: 'Hellmann\'s');
      final [a, _] = await banco.darEntrada(id, quantidade: 2);
      await banco.abrir(a);
    });

    await tester.pumpWidget(ChronosHomeApp(banco: Future.value(banco), openFoodFacts: semInternet()));
    await esperar(tester);
    await tester.tap(find.text('Estoque'));
    await esperar(tester);

    expect(find.text('Maionese'), findsOneWidget);
    expect(find.text('Hellmann\'s · 1 aberto'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await encerrar(tester);
  });

  testWidgets('produto novo vem preenchido pelo Open Food Facts e salva com entrada', (tester) async {
    final off = OpenFoodFacts(
      cliente: MockClient((_) async => http.Response.bytes(
            utf8.encode(jsonEncode({
              'status': 1,
              'product': {'product_name': 'Extrato de tomate', 'brands': 'Elefante, Cargill'},
            })),
            200,
          )),
    );
    ProdutoCadastrado? resultado;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          child: const Text('abrir'),
          onPressed: () async {
            resultado = await Navigator.of(context).push<ProdutoCadastrado>(MaterialPageRoute(
              builder: (_) => TelaProdutoNovo(codigo: '7896036090244', banco: banco, openFoodFacts: off),
            ));
          },
        ),
      ),
    ));
    await tester.tap(find.text('abrir'));
    await esperar(tester);

    expect(find.textContaining('Achei no Open Food Facts'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Extrato de tomate'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Elefante'), findsOneWidget);

    await tester.scrollUntilVisible(find.byTooltip('Mais'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byTooltip('Mais'));
    await tester.pump();
    await tester.tap(find.text('Salvar e dar entrada'));
    await esperar(tester);

    expect(resultado?.produto.nome, 'Extrato de tomate');
    expect(resultado?.unidades, hasLength(2));
    final emCasa = await tester.runAsync(() => banco.quantidadeEmCasa(resultado!.produto.id));
    expect(emCasa, 2);
    await encerrar(tester);
  });

  testWidgets('sem internet, o cadastro avisa e deixa preencher à mão', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TelaProdutoNovo(codigo: '123', banco: banco, openFoodFacts: semInternet()),
    ));
    await esperar(tester);

    expect(find.textContaining('Sem conexão com a internet'), findsOneWidget);
    await tester.tap(find.text('Salvar e dar entrada'));
    await tester.pump();
    expect(find.text('Digite o nome do produto'), findsOneWidget);
    await encerrar(tester);
  });

  test('o sqlite3 do projeto é o SQLCipher', () async {
    expect(await banco.versaoDoSqlcipher(), isNotNull);
  });
}
