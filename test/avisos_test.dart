import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/dados/avisos.dart';
import 'package:chronos_home/dados/banco.dart';

void main() {
  ItemDoEstoque item(
    String nome, {
    int fechados = 1,
    int abertos = 0,
    DateTime? venceEm,
    DateTime? abertoDesde,
    int? diasValidadeAberto,
  }) {
    return ItemDoEstoque(
      produto: Produto(
        id: nome,
        nome: nome,
        estoqueMinimo: 0,
        diasValidadeAberto: diasValidadeAberto,
        criadoEm: DateTime(2026, 1, 1),
      ),
      fechados: fechados,
      abertos: abertos,
      venceEm: venceEm,
      abertoDesde: abertoDesde,
    );
  }

  final agora = DateTime(2026, 10, 11, 20); // domingo à noite

  test('validade: aviso na véspera e no dia, às 9h', () {
    final avisos = planejarAvisos([item('Iogurte', venceEm: DateTime(2026, 10, 14))], agora: agora);

    expect(avisos.map((a) => (a.quando, a.titulo)), [
      (DateTime(2026, 10, 13, 9), 'Iogurte vence amanhã'),
      (DateTime(2026, 10, 14, 9), 'Iogurte vence hoje'),
    ]);
    expect(avisos.first.texto, 'Validade: 14/10.');
  });

  test('prazo depois de aberto: aviso no último dia e no dia seguinte', () {
    final avisos = planejarAvisos([
      item('Maionese', fechados: 0, abertos: 1, abertoDesde: DateTime(2026, 10, 10, 22), diasValidadeAberto: 5),
    ], agora: agora);

    expect(avisos.map((a) => (a.quando, a.titulo)), [
      (DateTime(2026, 10, 15, 9), 'Maionese: use hoje'),
      (DateTime(2026, 10, 16, 9), 'Maionese passou do prazo'),
    ]);
  });

  test('não agenda o que já passou, o que está sem prazo nem o que acabou', () {
    final avisos = planejarAvisos([
      // A véspera (hoje às 9h) já passou; fica só o "vence hoje" de amanhã.
      item('Leite', venceEm: DateTime(2026, 10, 12)),
      item('Venceu', venceEm: DateTime(2026, 10, 1)),
      item('Aberto sem prazo', fechados: 0, abertos: 1, abertoDesde: DateTime(2026, 10, 1)),
      item('Acabou', fechados: 0, venceEm: DateTime(2026, 10, 20)),
    ], agora: agora);

    expect(avisos.map((a) => a.titulo), ['Leite vence hoje']);
  });

  test('em ordem de data e limitado aos mais próximos', () {
    final muitos = [
      for (var i = 1; i <= 50; i++) item('P$i', venceEm: DateTime(2026, 10, 12).add(Duration(days: i))),
    ];

    final avisos = planejarAvisos(muitos.reversed.toList(), agora: agora);

    expect(avisos, hasLength(maximoDeAvisos));
    expect(avisos.first.titulo, 'P1 vence amanhã');
    for (var i = 1; i < avisos.length; i++) {
      expect(avisos[i].quando.isBefore(avisos[i - 1].quando), isFalse);
    }
  });
}
