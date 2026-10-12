import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../dados/banco.dart';
import '../dados/estatisticas.dart';

/// Cores das duas séries (paleta categórica validada para daltonismo, nas versões clara e escura).
/// O texto nunca usa essas cores: elas só marcam as barras e a legenda.
class _Cores {
  const _Cores(this.consumo, this.desperdicio);

  final Color consumo;
  final Color desperdicio;

  static _Cores de(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const _Cores(Color(0xFF3987E5), Color(0xFFD95926))
      : const _Cores(Color(0xFF2A78D6), Color(0xFFEB6834));
}

/// Consumo e desperdício a partir do histórico: resumo, por mês e os rankings.
class TelaGraficos extends StatefulWidget {
  const TelaGraficos({super.key, required this.banco, this.agora});

  final Banco banco;

  /// Para os testes fixarem a data.
  final DateTime? agora;

  @override
  State<TelaGraficos> createState() => _TelaGraficosState();
}

class _TelaGraficosState extends State<TelaGraficos> {
  int _meses = 6;
  late Future<Estatisticas> _estatisticas = _calcular();

  Future<Estatisticas> _calcular() async {
    final agora = widget.agora ?? DateTime.now();
    final vazia = Estatisticas(const [], agora: agora, meses: _meses);
    final historico = await widget.banco.movimentosDesde(vazia.primeiroMes);
    return Estatisticas(historico, agora: agora, meses: _meses);
  }

  void _trocarPeriodo(int meses) {
    setState(() {
      _meses = meses;
      _estatisticas = _calcular();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráficos')),
      body: FutureBuilder<Estatisticas>(
        future: _estatisticas,
        builder: (context, retrato) {
          final e = retrato.data;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Filtro no topo, numa linha só.
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 3, label: Text('3 meses')),
                  ButtonSegment(value: 6, label: Text('6 meses')),
                  ButtonSegment(value: 12, label: Text('1 ano')),
                ],
                selected: {_meses},
                onSelectionChanged: (s) => _trocarPeriodo(s.first),
              ),
              const SizedBox(height: 16),
              if (retrato.hasError)
                Text('Não consegui ler o histórico: ${retrato.error}')
              else if (e == null)
                const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
              else if (e.vazio)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Ainda não há histórico neste período.\n'
                    'Os gráficos aparecem quando você der entrada, abrir e terminar produtos.',
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                _Resumo(e),
                const SizedBox(height: 24),
                _PorMes(e),
                const SizedBox(height: 24),
                _Ranking(
                  titulo: 'Mais consumidos',
                  vazio: 'Nada acabou neste período.',
                  itens: e.maisConsumidos,
                  cor: _Cores.de(context).consumo,
                  detalhe: (i) => '${i.quantidade}',
                ),
                const SizedBox(height: 24),
                _Ranking(
                  titulo: 'Mais desperdiçados',
                  vazio: 'Nada foi descartado neste período. 👏',
                  itens: e.maisDesperdicados,
                  cor: _Cores.de(context).desperdicio,
                  detalhe: (i) => '${i.quantidade} · ${(i.parteDesperdicada * 100).round()}% do que saiu',
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------- resumo

class _Resumo extends StatelessWidget {
  const _Resumo(this.e);

  final Estatisticas e;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: [
        _Numero('Entraram', '${e.entraram}'),
        _Numero('Consumidos', '${e.consumidos}'),
        _Numero('Descartados', '${e.descartados}'),
        _Numero('Desperdício', '${(e.desperdicio * 100).round()}%'),
      ],
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero(this.titulo, this.valor);

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final cores = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: textos.bodySmall?.copyWith(color: cores.onSurfaceVariant)),
            Text(valor, style: textos.headlineSmall),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- por mês

class _PorMes extends StatelessWidget {
  const _PorMes(this.e);

  final Estatisticas e;

  @override
  Widget build(BuildContext context) {
    final cores = _Cores.de(context);
    final tema = Theme.of(context);
    final linha = tema.colorScheme.outlineVariant;
    final maior = e.porMes.fold<int>(0, (m, mes) => [m, mes.consumidos, mes.descartados].reduce((a, b) => a > b ? a : b));
    // Barras finas: com 12 meses elas ficam mais estreitas.
    final largura = e.meses > 6 ? 6.0 : 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Por mês', style: tema.textTheme.titleMedium),
        const SizedBox(height: 4),
        Wrap(
          spacing: 16,
          children: [
            _Legenda(cor: cores.consumo, texto: 'Consumidos'),
            _Legenda(cor: cores.desperdicio, texto: 'Descartados'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: (maior == 0 ? 1 : maior) * 1.15,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: linha, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (valor, meta) => valor % 1 != 0 || valor > maior
                        ? const SizedBox.shrink()
                        : SideTitleWidget(
                            meta: meta,
                            child: Text('${valor.toInt()}', style: tema.textTheme.bodySmall),
                          ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (valor, meta) {
                      final mes = e.porMes[valor.toInt()].inicio;
                      // Com 12 meses, só um rótulo sim, outro não, para não amontoar.
                      if (e.meses > 6 && valor.toInt().isOdd) return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(nomesDosMeses[mes.month - 1], style: tema.textTheme.bodySmall),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => tema.colorScheme.inverseSurface,
                  getTooltipItem: (grupo, _, barra, indice) {
                    final mes = e.porMes[grupo.x].inicio;
                    final nome = indice == 0 ? 'Consumidos' : 'Descartados';
                    return BarTooltipItem(
                      '${nomesDosMeses[mes.month - 1]}/${mes.year % 100}\n$nome: ${barra.toY.toInt()}',
                      TextStyle(color: tema.colorScheme.onInverseSurface),
                    );
                  },
                ),
              ),
              barGroups: [
                for (final (i, mes) in e.porMes.indexed)
                  BarChartGroupData(
                    x: i,
                    // 2px de espaço entre as duas barras do mês.
                    barsSpace: 2,
                    barRods: [
                      _barra(mes.consumidos, cores.consumo, largura),
                      _barra(mes.descartados, cores.desperdicio, largura),
                    ],
                  ),
              ],
            ),
          ),
        ),
        // Os mesmos números em tabela, para quem prefere ler a ver.
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('Ver os números'),
          children: [
            Table(
              columnWidths: const {0: FlexColumnWidth(2)},
              children: [
                TableRow(children: [
                  for (final t in ['Mês', 'Consumidos', 'Descartados'])
                    Padding(padding: const EdgeInsets.all(4), child: Text(t, style: tema.textTheme.labelMedium)),
                ]),
                for (final mes in e.porMes.reversed)
                  TableRow(children: [
                    for (final t in [
                      '${nomesDosMeses[mes.inicio.month - 1]}/${mes.inicio.year}',
                      '${mes.consumidos}',
                      '${mes.descartados}',
                    ])
                      Padding(padding: const EdgeInsets.all(4), child: Text(t)),
                  ]),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static BarChartRodData _barra(int valor, Color cor, double largura) => BarChartRodData(
        toY: valor.toDouble(),
        color: cor,
        width: largura,
        // Ponta arredondada só em cima; a base fica reta no eixo.
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      );
}

class _Legenda extends StatelessWidget {
  const _Legenda({required this.cor, required this.texto});

  final Color cor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ------------------------------------------------------------------- rankings

class _Ranking extends StatelessWidget {
  const _Ranking({
    required this.titulo,
    required this.vazio,
    required this.itens,
    required this.cor,
    required this.detalhe,
  });

  final String titulo;
  final String vazio;
  final List<NoRanking> itens;
  final Color cor;
  final String Function(NoRanking) detalhe;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final maior = itens.isEmpty ? 1 : itens.first.quantidade;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (itens.isEmpty) Text(vazio),
        for (final item in itens)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(item.produto.nome, overflow: TextOverflow.ellipsis)),
                    Text(detalhe(item), style: tema.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                // Barra fina, do tamanho proporcional ao primeiro do ranking.
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: item.quantidade / maior,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
