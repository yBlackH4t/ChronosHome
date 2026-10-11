import 'package:flutter/material.dart';

import '../dados/banco.dart';
import 'animacao.dart';
import 'bipar.dart';
import 'prova_banco.dart';

/// Tela inicial provisória do passo 2: um atalho para cada prova.
/// Os cartões entram um depois do outro (animação de entrada escalonada).
class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.banco});

  final Future<Banco> banco;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  Future<void> _abrir(Widget Function(Banco banco) tela) async {
    final Banco banco;
    try {
      banco = await widget.banco;
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não consegui abrir o banco: $erro')),
      );
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela(banco)));
  }

  @override
  Widget build(BuildContext context) {
    final atalhos = [
      _Atalho(
        icone: Icons.qr_code_scanner_rounded,
        titulo: 'Bipar',
        descricao: 'Ler códigos de barras com a câmera e gravar no banco',
        aoTocar: () => _abrir((banco) => TelaBipar(banco: banco)),
      ),
      _Atalho(
        icone: Icons.lock_rounded,
        titulo: 'Banco criptografado',
        descricao: 'Conferir o SQLCipher e o que ficou gravado',
        aoTocar: () => _abrir((banco) => TelaProvaBanco(banco: banco)),
      ),
      _Atalho(
        icone: Icons.animation_rounded,
        titulo: 'Animação',
        descricao: 'Uma lista animada para medir a fluidez no celular',
        aoTocar: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TelaAnimacao()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Chronos Home')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: atalhos.length,
        itemBuilder: (context, i) {
          // Cada cartão começa um pouco depois do anterior.
          final inicio = i * 0.2;
          final curva = CurvedAnimation(
            parent: _entrada,
            curve: Interval(inicio, inicio + 0.6, curve: Curves.easeOutCubic),
          );
          return FadeTransition(
            opacity: curva,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(curva),
              child: atalhos[i],
            ),
          );
        },
      ),
    );
  }
}

class _Atalho extends StatelessWidget {
  const _Atalho({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: cores.primaryContainer,
          foregroundColor: cores.onPrimaryContainer,
          child: Icon(icone),
        ),
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: aoTocar,
      ),
    );
  }
}
