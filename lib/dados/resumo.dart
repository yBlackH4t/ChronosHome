import 'banco.dart';

/// Situação de um produto aberto em relação ao prazo depois de aberto.
enum Prazo {
  /// O produto não tem prazo cadastrado.
  semPrazo,
  dentro,
  /// Hoje ou amanhã é o último dia.
  acabando,
  passou,
}

/// Um produto com unidade aberta, para a seção "Abertos" do Início.
class Aberto {
  const Aberto({required this.item, required this.dias, required this.prazo, this.diasRestantes});

  final ItemDoEstoque item;

  /// Há quantos dias a unidade mais antiga está aberta (0 = hoje).
  final int dias;
  final Prazo prazo;

  /// Dias até o fim do prazo (negativo = passou). Vazio quando não há prazo.
  final int? diasRestantes;
}

/// Um produto para comprar e quanto falta para chegar ao estoque mínimo.
class ParaComprar {
  const ParaComprar(this.item, this.quantidade);

  final ItemDoEstoque item;
  final int quantidade;
}

/// As contas do Início, separadas do banco e das telas para serem testadas com qualquer data.
class Resumo {
  Resumo(this.estoque, {required DateTime agora}) : _hoje = _soData(agora);

  final List<ItemDoEstoque> estoque;
  final DateTime _hoje;

  /// Produtos com unidade aberta: primeiro os que passaram do prazo, depois os que estão acabando,
  /// e então os demais, do aberto há mais tempo para o mais recente.
  late final List<Aberto> abertos = [
    for (final item in estoque)
      if (item.abertos > 0 && item.abertoDesde != null) _aberto(item),
  ]..sort(_maisUrgentePrimeiro);

  /// Só sobrou o que está aberto: hora de pensar em comprar mais.
  late final List<ItemDoEstoque> acabando = [
    for (final item in estoque)
      if (item.abertos > 0 && item.fechados == 0 && !_naLista(item)) item,
  ];

  /// Produtos abaixo do estoque mínimo, com quanto comprar.
  late final List<ParaComprar> listaDeCompras = [
    for (final item in estoque)
      if (_naLista(item)) ParaComprar(item, item.produto.estoqueMinimo - item.emCasa),
  ];

  /// A lista em texto, para colar no WhatsApp ou num bloco de notas.
  String listaEmTexto() {
    final linhas = [
      for (final p in listaDeCompras)
        '- ${p.quantidade}x ${p.item.produto.nome}${p.item.produto.marca == null ? '' : ' (${p.item.produto.marca})'}',
    ];
    return ['Lista de compras', ...linhas].join('\n');
  }

  static bool _naLista(ItemDoEstoque item) => item.emCasa < item.produto.estoqueMinimo;

  Aberto _aberto(ItemDoEstoque item) {
    final dias = _hoje.difference(_soData(item.abertoDesde!)).inDays;
    final prazo = item.produto.diasValidadeAberto;
    if (prazo == null) return Aberto(item: item, dias: dias, prazo: Prazo.semPrazo);
    final restantes = prazo - dias;
    return Aberto(
      item: item,
      dias: dias,
      diasRestantes: restantes,
      prazo: restantes < 0
          ? Prazo.passou
          : restantes <= 1
              ? Prazo.acabando
              : Prazo.dentro,
    );
  }

  static int _maisUrgentePrimeiro(Aberto a, Aberto b) {
    int peso(Aberto x) => switch (x.prazo) {
          Prazo.passou => 0,
          Prazo.acabando => 1,
          Prazo.dentro || Prazo.semPrazo => 2,
        };
    final porPeso = peso(a).compareTo(peso(b));
    return porPeso != 0 ? porPeso : b.dias.compareTo(a.dias);
  }

  /// Conta dias de calendário: aberto ontem às 23h já é "1 dia" hoje de manhã.
  static DateTime _soData(DateTime d) => DateTime(d.year, d.month, d.day);
}
