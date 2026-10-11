import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/dados/banco.dart';
import 'package:chronos_home/dados/resumo.dart';

void main() {
  final hoje = DateTime(2026, 10, 11, 9);

  ItemDoEstoque item(
    String nome, {
    int fechados = 0,
    int abertos = 0,
    DateTime? abertoDesde,
    int estoqueMinimo = 0,
    int? diasValidadeAberto,
    String? marca,
  }) {
    return ItemDoEstoque(
      produto: Produto(
        id: nome,
        nome: nome,
        marca: marca,
        estoqueMinimo: estoqueMinimo,
        diasValidadeAberto: diasValidadeAberto,
        criadoEm: DateTime(2026, 1, 1),
      ),
      fechados: fechados,
      abertos: abertos,
      abertoDesde: abertoDesde,
    );
  }

  group('abertos', () {
    test('conta dias de calendário, não de 24 horas', () {
      final ontemANoite = item('Leite', abertos: 1, abertoDesde: DateTime(2026, 10, 10, 23));
      final hojeCedo = item('Café', abertos: 1, abertoDesde: DateTime(2026, 10, 11, 6));

      final abertos = Resumo([ontemANoite, hojeCedo], agora: hoje).abertos;

      expect({for (final a in abertos) a.item.produto.nome: a.dias}, {'Leite': 1, 'Café': 0});
    });

    test('classifica pelo prazo depois de aberto', () {
      Prazo prazoDe(int diasAberto, int? prazo) => Resumo([
            item('X', abertos: 1, abertoDesde: hoje.subtract(Duration(days: diasAberto)), diasValidadeAberto: prazo),
          ], agora: hoje)
              .abertos
              .single
              .prazo;

      expect(prazoDe(1, null), Prazo.semPrazo);
      expect(prazoDe(1, 5), Prazo.dentro);
      expect(prazoDe(4, 5), Prazo.acabando); // use até amanhã
      expect(prazoDe(5, 5), Prazo.acabando); // use hoje
      expect(prazoDe(6, 5), Prazo.passou);
    });

    test('mais urgente primeiro: passou, acabando, e então o aberto há mais tempo', () {
      final resumo = Resumo([
        item('Antigo sem prazo', abertos: 1, abertoDesde: hoje.subtract(const Duration(days: 20))),
        item('Recente', abertos: 1, abertoDesde: hoje),
        item('Acabando', abertos: 1, abertoDesde: hoje.subtract(const Duration(days: 2)), diasValidadeAberto: 3),
        item('Passou', abertos: 1, abertoDesde: hoje.subtract(const Duration(days: 9)), diasValidadeAberto: 5),
        item('Fechado', fechados: 2),
      ], agora: hoje);

      expect(resumo.abertos.map((a) => a.item.produto.nome), ['Passou', 'Acabando', 'Antigo sem prazo', 'Recente']);
    });
  });

  group('lista de compras', () {
    test('entra o que está abaixo do mínimo, com quanto falta', () {
      final resumo = Resumo([
        item('Arroz', fechados: 1, estoqueMinimo: 3),
        item('Feijão', fechados: 3, estoqueMinimo: 3),
        item('Café', estoqueMinimo: 2),
        item('Sem mínimo'),
      ], agora: hoje);

      expect({for (final p in resumo.listaDeCompras) p.item.produto.nome: p.quantidade}, {'Arroz': 2, 'Café': 2});
    });

    test('vira texto para colar no WhatsApp', () {
      final resumo = Resumo([
        item('Arroz', fechados: 1, estoqueMinimo: 3, marca: 'Tio João'),
        item('Café', estoqueMinimo: 1),
      ], agora: hoje);

      expect(resumo.listaEmTexto(), 'Lista de compras\n- 2x Arroz (Tio João)\n- 1x Café');
    });
  });

  test('acabando: só sobrou o aberto e ainda não está na lista de compras', () {
    final resumo = Resumo([
      item('Maionese', abertos: 1, abertoDesde: hoje),
      item('Ketchup', abertos: 1, fechados: 1, abertoDesde: hoje),
      item('Mostarda', abertos: 1, abertoDesde: hoje, estoqueMinimo: 2),
    ], agora: hoje);

    expect(resumo.acabando.map((i) => i.produto.nome), ['Maionese']);
    expect(resumo.listaDeCompras.map((p) => p.item.produto.nome), ['Mostarda']);
  });
}
