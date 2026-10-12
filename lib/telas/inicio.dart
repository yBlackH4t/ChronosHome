import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../componentes/acoes_do_produto.dart';
import '../dados/avisos.dart';
import '../dados/banco.dart';
import '../dados/datas.dart';
import '../dados/resumo.dart';
import '../servicos/avisos_no_celular.dart';
import '../servicos/open_food_facts.dart';
import 'compras.dart';
import 'cozinha.dart';

/// Tela inicial, em três abas:
/// - Agora: o que está vencendo, o que está aberto (e há quantos dias) e o que está acabando;
/// - Comprar: a lista de compras pelo estoque mínimo;
/// - Estoque: tudo o que tem em casa.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key, required this.banco, required this.openFoodFacts, this.avisos});

  final Future<Banco> banco;
  final OpenFoodFacts openFoodFacts;
  final AvisosNoCelular? avisos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Banco>(
      future: banco,
      builder: (context, retrato) {
        if (retrato.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chronos Home')),
            body: _Mensagem(
              icone: Icons.error_rounded,
              texto: 'Não consegui abrir o banco de dados.\n${retrato.error}',
            ),
          );
        }
        final banco = retrato.data;
        if (banco == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chronos Home')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return _Abas(banco: banco, openFoodFacts: openFoodFacts, avisos: avisos);
      },
    );
  }
}

class _Abas extends StatefulWidget {
  const _Abas({required this.banco, required this.openFoodFacts, this.avisos});

  final Banco banco;
  final OpenFoodFacts openFoodFacts;
  final AvisosNoCelular? avisos;

  @override
  State<_Abas> createState() => _AbasState();
}

class _AbasState extends State<_Abas> {
  /// Criada uma vez só: refazer a consulta a cada redesenho pesa no A10s.
  /// A cada mudança no estoque, os avisos do celular são reagendados.
  late final Stream<List<ItemDoEstoque>> _estoque = widget.banco.observarEstoque().map((estoque) {
    widget.avisos?.agendar(planejarAvisos(estoque, agora: DateTime.now()));
    return estoque;
  });

  @override
  Widget build(BuildContext context) {
    final banco = widget.banco;
    return StreamBuilder<List<ItemDoEstoque>>(
      stream: _estoque,
      builder: (context, retrato) {
        final estoque = retrato.data;
        final resumo = estoque == null ? null : Resumo(estoque, agora: DateTime.now());
        final aComprar = resumo?.listaDeCompras.length ?? 0;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Chronos Home'),
              bottom: TabBar(
                tabs: [
                  const Tab(text: 'Agora'),
                  Tab(
                    child: Badge(
                      isLabelVisible: aComprar > 0,
                      label: Text('$aComprar'),
                      offset: const Offset(14, -6),
                      child: const Text('Comprar'),
                    ),
                  ),
                  const Tab(text: 'Estoque'),
                ],
              ),
            ),
            body: resumo == null
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _AbaAgora(banco: banco, resumo: resumo),
                      _AbaComprar(banco: banco, resumo: resumo),
                      _AbaEstoque(banco: banco, estoque: resumo.estoque),
                    ],
                  ),
            bottomNavigationBar: _BotoesDeBaixo(banco: banco, openFoodFacts: widget.openFoodFacts),
          ),
        );
      },
    );
  }
}

class _BotoesDeBaixo extends StatelessWidget {
  const _BotoesDeBaixo({required this.banco, required this.openFoodFacts});

  final Banco banco;
  final OpenFoodFacts openFoodFacts;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.shopping_cart_rounded),
                label: const Text('Compras'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TelaCompras(banco: banco, openFoodFacts: openFoodFacts),
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.kitchen_rounded),
                label: const Text('Cozinha'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TelaCozinha(banco: banco),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- Agora

class _AbaAgora extends StatelessWidget {
  const _AbaAgora({required this.banco, required this.resumo});

  final Banco banco;
  final Resumo resumo;

  @override
  Widget build(BuildContext context) {
    if (resumo.estoque.isEmpty) {
      return const _Mensagem(
        icone: Icons.inventory_2_rounded,
        texto: 'O estoque está vazio.\nToque em Compras e bipe o que chegou do mercado.',
      );
    }
    if (resumo.vencendo.isEmpty && resumo.abertos.isEmpty && resumo.acabando.isEmpty) {
      return const _Mensagem(
        icone: Icons.check_circle_rounded,
        texto: 'Nada vencendo, aberto ou acabando.\nQuando abrir algo, bipe na Cozinha.',
      );
    }
    final cores = Theme.of(context).colorScheme;
    return ListView(
      children: [
        if (resumo.vencendo.isNotEmpty) ...[
          const _Titulo('Vencendo', detalhe: 'próximos  dias'),
          for (final v in resumo.vencendo)
            ListTile(
              leading: Icon(
                v.diasRestantes < 0 ? Icons.warning_rounded : Icons.event_rounded,
                color: v.diasRestantes <= 0 ? cores.error : cores.tertiary,
              ),
              title: Text(v.item.produto.nome),
              subtitle: Text('${textoDaValidade(v.diasRestantes)} · ${diaEMes(v.item.venceEm!)}'),
              onTap: () => mostrarAcoesDoProduto(context, banco, v.item.produto),
            ),
        ],
        if (resumo.abertos.isNotEmpty) ...[
          const _Titulo('Abertos'),
          for (final a in resumo.abertos) _LinhaAberto(banco: banco, aberto: a),
        ],
        if (resumo.acabando.isNotEmpty) ...[
          const _Titulo('Acabando', detalhe: 'só sobrou o que está aberto'),
          for (final item in resumo.acabando)
            ListTile(
              leading: const Icon(Icons.hourglass_bottom_rounded),
              title: Text(item.produto.nome),
              subtitle: const Text('Último em casa'),
              onTap: () => mostrarAcoesDoProduto(context, banco, item.produto),
            ),
        ],
      ],
    );
  }
}

class _LinhaAberto extends StatelessWidget {
  const _LinhaAberto({required this.banco, required this.aberto});

  final Banco banco;
  final Aberto aberto;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final (icone, cor, aviso) = switch (aberto.prazo) {
      Prazo.passou => (Icons.warning_rounded, cores.error, 'passou do prazo de ${aberto.item.produto.diasValidadeAberto} dias'),
      Prazo.acabando => (
          Icons.schedule_rounded,
          cores.tertiary,
          aberto.diasRestantes == 0 ? 'use hoje' : 'use até amanhã',
        ),
      Prazo.dentro => (Icons.lock_open_rounded, cores.primary, 'ainda ${aberto.diasRestantes} dias'),
      Prazo.semPrazo => (Icons.lock_open_rounded, cores.onSurfaceVariant, null),
    };
    final ha = switch (aberto.dias) {
      0 => 'Aberto hoje',
      1 => 'Aberto há 1 dia',
      final n => 'Aberto há $n dias',
    };
    return ListTile(
      leading: Icon(icone, color: cor),
      title: Text(aberto.item.produto.nome),
      subtitle: Text(aviso == null ? ha : '$ha · $aviso'),
      onTap: () => mostrarAcoesDoProduto(context, banco, aberto.item.produto),
    );
  }
}

// ------------------------------------------------------------------- Comprar

class _AbaComprar extends StatelessWidget {
  const _AbaComprar({required this.banco, required this.resumo});

  final Banco banco;
  final Resumo resumo;

  @override
  Widget build(BuildContext context) {
    final lista = resumo.listaDeCompras;
    if (lista.isEmpty) {
      return const _Mensagem(
        icone: Icons.shopping_basket_rounded,
        texto: 'Nada para comprar.\nPara um produto entrar aqui, toque nele e defina o estoque mínimo.',
      );
    }
    return ListView(
      children: [
        for (final p in lista)
          ListTile(
            leading: CircleAvatar(child: Text('${p.quantidade}')),
            title: Text(p.item.produto.nome),
            subtitle: Text('Tem ${p.item.emCasa} · mínimo ${p.item.produto.estoqueMinimo}'),
            onTap: () => mostrarAcoesDoProduto(context, banco, p.item.produto),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copiar a lista'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: resumo.listaEmTexto()));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lista copiada. Cole no WhatsApp ou nas notas.')),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------- Estoque

class _AbaEstoque extends StatelessWidget {
  const _AbaEstoque({required this.banco, required this.estoque});

  final Banco banco;
  final List<ItemDoEstoque> estoque;

  @override
  Widget build(BuildContext context) {
    if (estoque.isEmpty) {
      return const _Mensagem(
        icone: Icons.inventory_2_rounded,
        texto: 'O estoque está vazio.\nToque em Compras e bipe o que chegou do mercado.',
      );
    }
    return ListView.separated(
      itemCount: estoque.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) => _LinhaDoEstoque(banco: banco, item: estoque[i]),
    );
  }
}

class _LinhaDoEstoque extends StatelessWidget {
  const _LinhaDoEstoque({required this.banco, required this.item});

  final Banco banco;
  final ItemDoEstoque item;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final p = item.produto;
    final detalhes = [
      if (p.marca != null) p.marca!,
      if (item.abertos > 0) '${item.abertos} aberto${item.abertos > 1 ? 's' : ''}',
    ];
    return ListTile(
      title: Text(p.nome),
      subtitle: detalhes.isEmpty ? null : Text(detalhes.join(' · ')),
      trailing: CircleAvatar(
        backgroundColor: item.emCasa == 0 ? cores.errorContainer : cores.primaryContainer,
        foregroundColor: item.emCasa == 0 ? cores.onErrorContainer : cores.onPrimaryContainer,
        child: Text('${item.emCasa}'),
      ),
      onTap: () => mostrarAcoesDoProduto(context, banco, p),
    );
  }
}

// ------------------------------------------------------------------- comuns

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto, {this.detalhe});

  final String texto;
  final String? detalhe;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: texto, style: textos.titleMedium),
        if (detalhe != null) TextSpan(text: '  $detalhe', style: textos.bodySmall),
      ])),
    );
  }
}

class _Mensagem extends StatelessWidget {
  const _Mensagem({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: cores.primary),
            const SizedBox(height: 16),
            Text(texto, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
