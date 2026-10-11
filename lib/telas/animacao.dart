import 'package:flutter/material.dart';

/// Prova do passo 2: uma lista parecida com a do estoque, com animações, para
/// medir a fluidez no A10s. Toque num item para "abrir"; segure para "acabou".
class TelaAnimacao extends StatefulWidget {
  const TelaAnimacao({super.key});

  @override
  State<TelaAnimacao> createState() => _TelaAnimacaoState();
}

enum _Estado { fechado, aberto, acabou }

class _TelaAnimacaoState extends State<TelaAnimacao> with SingleTickerProviderStateMixin {
  static const _nomes = [
    'Extrato de tomate', 'Maionese', 'Arroz', 'Feijão', 'Café', 'Leite', 'Iogurte',
    'Detergente', 'Sabão em pó', 'Azeite', 'Macarrão', 'Açúcar', 'Farinha', 'Manteiga',
  ];

  final _estados = List.generate(40, (_) => _Estado.fechado);

  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Animação')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _estados.length,
        itemBuilder: (context, i) {
          // Só os primeiros itens (os que aparecem na tela) entram escalonados.
          final inicio = (i.clamp(0, 9)) * 0.06;
          final curva = CurvedAnimation(
            parent: _entrada,
            curve: Interval(inicio, (inicio + 0.45).clamp(0, 1), curve: Curves.easeOutCubic),
          );
          final estado = _estados[i];
          final fundo = switch (estado) {
            _Estado.fechado => cores.surfaceContainerHighest,
            _Estado.aberto => cores.tertiaryContainer,
            _Estado.acabou => cores.errorContainer,
          };
          return FadeTransition(
            opacity: curva,
            child: SlideTransition(
              position: Tween(begin: const Offset(0.15, 0), end: Offset.zero).animate(curva),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: fundo,
                  borderRadius: BorderRadius.circular(estado == _Estado.fechado ? 12 : 24),
                ),
                child: ListTile(
                  title: Text(_nomes[i % _nomes.length]),
                  subtitle: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      switch (estado) {
                        _Estado.fechado => 'Fechado',
                        _Estado.aberto => 'Aberto agora',
                        _Estado.acabou => 'Acabou',
                      },
                      key: ValueKey(estado),
                    ),
                  ),
                  trailing: AnimatedRotation(
                    turns: estado == _Estado.fechado ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.expand_more_rounded),
                  ),
                  onTap: () => setState(() {
                    _estados[i] = estado == _Estado.fechado ? _Estado.aberto : _Estado.fechado;
                  }),
                  onLongPress: () => setState(() => _estados[i] = _Estado.acabou),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
