import 'banco.dart';

/// Quantas unidades acabaram (consumo) e quantas foram descartadas (desperdício) num mês.
class Mes {
  const Mes(this.inicio, {this.consumidos = 0, this.descartados = 0});

  /// Dia 1 do mês.
  final DateTime inicio;
  final int consumidos;
  final int descartados;
}

/// Um produto num ranking.
class NoRanking {
  const NoRanking(this.produto, this.quantidade, {this.saidas = 0});

  final Produto produto;
  final int quantidade;

  /// Tudo o que saiu de casa desse produto (consumido + descartado), para a porcentagem.
  final int saidas;

  /// Parte das saídas que foi desperdiçada (0 a 1). Só faz sentido no ranking de desperdício.
  double get parteDesperdicada => saidas == 0 ? 0 : quantidade / saidas;
}

/// As contas dos gráficos, a partir do histórico. Sem banco nem tela, para testar com qualquer data.
class Estatisticas {
  Estatisticas(List<MovimentoDoProduto> historico, {required DateTime agora, required this.meses})
      : primeiroMes = DateTime(agora.year, agora.month - (meses - 1)) {
    _historico = historico.where((m) => !m.quando.isBefore(primeiroMes)).toList();
  }

  /// Quantos meses entram, contando o atual.
  final int meses;

  /// Dia 1 do mês mais antigo do período: é daqui que o histórico precisa ser lido.
  final DateTime primeiroMes;

  late final List<MovimentoDoProduto> _historico;

  /// Quantos itens aparecem em cada ranking.
  static const tamanhoDoRanking = 5;

  int _contar(AcaoMovimento acao) => _historico.where((m) => m.acao == acao).length;

  late final int entraram = _contar(AcaoMovimento.entrada);
  late final int consumidos = _contar(AcaoMovimento.acabou);
  late final int descartados = _contar(AcaoMovimento.descartar);

  bool get vazio => entraram == 0 && consumidos == 0 && descartados == 0;

  /// Parte do que saiu de casa que foi para o lixo (0 a 1).
  double get desperdicio {
    final saidas = consumidos + descartados;
    return saidas == 0 ? 0 : descartados / saidas;
  }

  /// Um item por mês do período, do mais antigo para o atual, com zero nos meses sem nada.
  late final List<Mes> porMes = () {
    final consumo = <DateTime, int>{};
    final lixo = <DateTime, int>{};
    for (final m in _historico) {
      final mes = DateTime(m.quando.year, m.quando.month);
      if (m.acao == AcaoMovimento.acabou) consumo[mes] = (consumo[mes] ?? 0) + 1;
      if (m.acao == AcaoMovimento.descartar) lixo[mes] = (lixo[mes] ?? 0) + 1;
    }
    return [
      for (var i = 0; i < meses; i++)
        () {
          final mes = DateTime(primeiroMes.year, primeiroMes.month + i);
          return Mes(mes, consumidos: consumo[mes] ?? 0, descartados: lixo[mes] ?? 0);
        }(),
    ];
  }();

  /// Os produtos que mais acabaram no período.
  late final List<NoRanking> maisConsumidos = _ranking(AcaoMovimento.acabou);

  /// Os produtos com mais unidades descartadas no período.
  late final List<NoRanking> maisDesperdicados = _ranking(AcaoMovimento.descartar);

  List<NoRanking> _ranking(AcaoMovimento acao) {
    final produtos = <String, Produto>{};
    final contagem = <String, int>{};
    final saidas = <String, int>{};
    for (final m in _historico) {
      final id = m.produto.id;
      produtos[id] = m.produto;
      if (m.acao == acao) contagem[id] = (contagem[id] ?? 0) + 1;
      if (m.acao == AcaoMovimento.acabou || m.acao == AcaoMovimento.descartar) {
        saidas[id] = (saidas[id] ?? 0) + 1;
      }
    }
    final ranking = [
      for (final MapEntry(key: id, value: n) in contagem.entries)
        NoRanking(produtos[id]!, n, saidas: saidas[id] ?? 0),
    ]..sort((a, b) {
        final porQuantidade = b.quantidade.compareTo(a.quantidade);
        return porQuantidade != 0
            ? porQuantidade
            : a.produto.nome.toLowerCase().compareTo(b.produto.nome.toLowerCase());
      });
    return ranking.take(tamanhoDoRanking).toList();
  }
}

/// "out", "nov"... para os eixos.
const nomesDosMeses = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
