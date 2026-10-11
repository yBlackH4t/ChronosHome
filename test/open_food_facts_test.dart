import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:chronos_home/servicos/open_food_facts.dart';

void main() {
  http.Response json(Object corpo, [int status = 200]) =>
      http.Response.bytes(utf8.encode(jsonEncode(corpo)), status);

  test('pede o código certo, com User-Agent, e lê nome, marca, categoria e foto', () async {
    late http.Request pedido;
    final off = OpenFoodFacts(
      cliente: MockClient((p) async {
        pedido = p;
        return json({
          'status': 1,
          'product': {
            'product_name': 'Mayonnaise',
            'product_name_pt': 'Maionese',
            'brands': "Hellmann's, Unilever",
            'categories': 'Condimentos, Molhos, Maioneses',
            'image_front_small_url': 'https://images.openfoodfacts.org/x.jpg',
          },
        });
      }),
    );

    final p = await off.buscar('7891150027848');

    expect(pedido.url.path, '/api/v2/product/7891150027848.json');
    expect(pedido.headers['User-Agent'], contains('ChronosHome'));
    expect(p?.nome, 'Maionese');
    expect(p?.marca, "Hellmann's");
    expect(p?.categoria, 'Maioneses');
    expect(p?.foto, 'https://images.openfoodfacts.org/x.jpg');
  });

  test('sem nome em português, usa o nome geral', () async {
    final off = OpenFoodFacts(
      cliente: MockClient((_) async => json({'status': 1, 'product': {'product_name': 'Café'}})),
    );
    expect((await off.buscar('1'))?.nome, 'Café');
  });

  test('código desconhecido devolve null', () async {
    final off404 = OpenFoodFacts(cliente: MockClient((_) async => json({'status': 0}, 404)));
    final offStatus0 = OpenFoodFacts(cliente: MockClient((_) async => json({'status': 0})));
    final offSemNome = OpenFoodFacts(
      cliente: MockClient((_) async => json({'status': 1, 'product': {'brands': 'X'}})),
    );

    expect(await off404.buscar('1'), isNull);
    expect(await offStatus0.buscar('1'), isNull);
    expect(await offSemNome.buscar('1'), isNull);
  });

  test('sem internet ou com erro no servidor, lança FalhaNaConsulta', () async {
    final semRede = OpenFoodFacts(cliente: MockClient((_) async => throw Exception('sem rede')));
    final erro500 = OpenFoodFacts(cliente: MockClient((_) async => http.Response('', 500)));

    expect(() => semRede.buscar('1'), throwsA(isA<FalhaNaConsulta>()));
    expect(() => erro500.buscar('1'), throwsA(isA<FalhaNaConsulta>()));
  });
}
