import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/dados/banco.dart';
import 'package:chronos_home/dados/estatisticas.dart';

void main() {
  final agora = DateTime(2026, 10, 12, 10);

  Produto produto(String nome) =>
      Produto(id: nome, nome: nome, estoqueMinimo: 0, criadoEm: DateTime(2026, 1, 1));

  MovimentoDoProduto mov(String nome, AcaoMovimento acao, DateTime quando) =>
      MovimentoDoProduto(acao: acao, quando: quando, produto: produto(nome));

  test('período: o mês atual e os anteriores, a partir do dia 1', () {
    expect(Estatisticas(const [], agora: agora, meses: 3).primeiroMes, DateTime(2026, 8));
    expect(Estatisticas(const [], agora: agora, meses: 12).primeiroMes, DateTime(2025, 11));
  });

  test('totais e desperdício contam só o período', () {
    final e = Estatisticas([
      mov('Leite', AcaoMovimento.entrada, DateTime(2026, 7, 31)), // fora (antes de agosto)
      mov('Leite', AcaoMovimento.entrada, DateTime(2026, 8, 1)),
      mov('Leite', AcaoMovimento.entrada, DateTime(2026, 9, 5)),
      mov('Leite', AcaoMovimento.abrir, DateTime(2026, 9, 6)),
      mov('Leite', AcaoMovimento.acabou, DateTime(2026, 9, 9)),
      mov('Leite', AcaoMovimento.acabou, DateTime(2026, 10, 1)),
      mov('Leite', AcaoMovimento.acabou, DateTime(2026, 10, 2)),
      mov('Iogurte', AcaoMovimento.descartar, DateTime(2026, 10, 3)),
    ], agora: agora, meses: 3);

    expect(e.entraram, 2);
    expect(e.consumidos, 3);
    expect(e.descartados, 1);
    expect(e.desperdicio, 0.25);
    expect(e.vazio, isFalse);
  });

  test('por mês: um item por mês, com zero nos meses sem nada', () {
    final e = Estatisticas([
      mov('Leite', AcaoMovimento.acabou, DateTime(2026, 8, 20)),
      mov('Leite', AcaoMovimento.acabou, DateTime(2026, 10, 1)),
      mov('Pão', AcaoMovimento.descartar, DateTime(2026, 10, 2)),
    ], agora: agora, meses: 3);

    expect(e.porMes.map((m) => (m.inicio, m.consumidos, m.descartados)), [
      (DateTime(2026, 8), 1, 0),
      (DateTime(2026, 9), 0, 0),
      (DateTime(2026, 10), 1, 1),
    ]);
  });

  test('rankings: do maior para o menor, no máximo 5, com a parte desperdiçada', () {
    final historico = [
      for (var i = 0; i < 4; i++) mov('Leite', AcaoMovimento.acabou, DateTime(2026, 10, 1)),
      for (var i = 0; i < 2; i++) mov('Café', AcaoMovimento.acabou, DateTime(2026, 10, 1)),
      for (final nome in ['A', 'B', 'C', 'D']) mov(nome, AcaoMovimento.acabou, DateTime(2026, 10, 1)),
      mov('Iogurte', AcaoMovimento.descartar, DateTime(2026, 10, 2)),
      mov('Iogurte', AcaoMovimento.descartar, DateTime(2026, 10, 3)),
      mov('Iogurte', AcaoMovimento.acabou, DateTime(2026, 10, 4)),
      mov('Leite', AcaoMovimento.descartar, DateTime(2026, 10, 5)),
    ];

    final e = Estatisticas(historico, agora: agora, meses: 6);

    expect(e.maisConsumidos.map((r) => (r.produto.nome, r.quantidade)),
        [('Leite', 4), ('Café', 2), ('A', 1), ('B', 1), ('C', 1)]);
    expect(e.maisDesperdicados.map((r) => (r.produto.nome, r.quantidade)), [('Iogurte', 2), ('Leite', 1)]);
    expect(e.maisDesperdicados.first.parteDesperdicada, closeTo(2 / 3, 0.001));
    expect(e.maisDesperdicados.last.parteDesperdicada, closeTo(1 / 5, 0.001));
  });

  test('sem histórico: vazio e sem dividir por zero', () {
    final e = Estatisticas(const [], agora: agora, meses: 6);
    expect(e.vazio, isTrue);
    expect(e.desperdicio, 0);
    expect(e.porMes, hasLength(6));
    expect(e.maisConsumidos, isEmpty);
  });
}
