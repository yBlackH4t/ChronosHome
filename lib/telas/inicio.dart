import 'package:flutter/material.dart';

import '../dados/banco.dart';
import '../servicos/open_food_facts.dart';
import 'compras.dart';

/// Tela inicial: o que tem em casa e o botão de Compras.
/// Os avisos e a lista de compras entram no passo 6.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key, required this.banco, required this.openFoodFacts});

  final Future<Banco> banco;
  final OpenFoodFacts openFoodFacts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Banco>(
      future: banco,
      builder: (context, retrato) {
        if (retrato.hasError) {
          return _Esqueleto(
            corpo: _Mensagem(
              icone: Icons.error_rounded,
              texto: 'Não consegui abrir o banco de dados.\n${retrato.error}',
            ),
          );
        }
        final banco = retrato.data;
        if (banco == null) {
          return const _Esqueleto(corpo: Center(child: CircularProgressIndicator()));
        }
        return _Esqueleto(
          corpo: _ListaDoEstoque(banco: banco),
          botao: FloatingActionButton.extended(
            icon: const Icon(Icons.shopping_cart_rounded),
            label: const Text('Compras'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TelaCompras(banco: banco, openFoodFacts: openFoodFacts),
            )),
          ),
        );
      },
    );
  }
}

class _Esqueleto extends StatelessWidget {
  const _Esqueleto({required this.corpo, this.botao});

  final Widget corpo;
  final Widget? botao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chronos Home')),
      body: corpo,
      floatingActionButton: botao,
    );
  }
}

class _ListaDoEstoque extends StatelessWidget {
  const _ListaDoEstoque({required this.banco});

  final Banco banco;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemDoEstoque>>(
      stream: banco.observarEstoque(),
      builder: (context, retrato) {
        final itens = retrato.data;
        if (itens == null) return const Center(child: CircularProgressIndicator());
        if (itens.isEmpty) {
          return const _Mensagem(
            icone: Icons.inventory_2_rounded,
            texto: 'O estoque está vazio.\nToque em Compras e bipe o que chegou do mercado.',
          );
        }
        return ListView.separated(
          // Espaço no fim para o botão não cobrir o último item.
          padding: const EdgeInsets.only(bottom: 88),
          itemCount: itens.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _LinhaDoEstoque(item: itens[i]),
        );
      },
    );
  }
}

class _LinhaDoEstoque extends StatelessWidget {
  const _LinhaDoEstoque({required this.item});

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
