import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dados/banco.dart';

/// Painel com Abrir, Acabou e Descartar para um produto.
/// Usado na Cozinha (depois de bipar) e no Início (tocando no produto).
///
/// Depois da ação mostra um aviso com "Desfazer", para corrigir um toque errado.
Future<void> mostrarAcoesDoProduto(BuildContext context, Banco banco, Produto produto) async {
  final avisos = ScaffoldMessenger.of(context);
  final feito = await showModalBottomSheet<_AcaoFeita>(
    context: context,
    showDragHandle: true,
    builder: (_) => _PainelDeAcoes(banco: banco, produto: produto),
  );
  if (feito == null) return;

  await HapticFeedback.mediumImpact();
  avisos
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('${produto.nome}: ${feito.descricao}'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () => banco.desfazerUltimaAcao(feito.unidadeId),
      ),
    ));
}

class _AcaoFeita {
  const _AcaoFeita(this.unidadeId, this.descricao);

  final String unidadeId;
  final String descricao;
}

class _PainelDeAcoes extends StatefulWidget {
  const _PainelDeAcoes({required this.banco, required this.produto});

  final Banco banco;
  final Produto produto;

  @override
  State<_PainelDeAcoes> createState() => _PainelDeAcoesState();
}

class _PainelDeAcoesState extends State<_PainelDeAcoes> {
  late final Future<_Situacao> _situacao = _carregar();
  bool _ocupado = false;

  Future<_Situacao> _carregar() async {
    final id = widget.produto.id;
    return _Situacao(
      emCasa: await widget.banco.unidadesEmCasa(id),
      paraAbrir: await widget.banco.unidadeParaAbrir(id),
      paraAcabar: await widget.banco.unidadeParaAcabar(id),
    );
  }

  Future<void> _fazer(String unidadeId, Future<void> Function(String) acao, String descricao) async {
    setState(() => _ocupado = true);
    try {
      await acao(unidadeId);
    } on TransicaoInvalida catch (erro) {
      if (!mounted) return;
      setState(() => _ocupado = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro.mensagem)));
      return;
    }
    if (mounted) Navigator.of(context).pop(_AcaoFeita(unidadeId, descricao));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: FutureBuilder<_Situacao>(
          future: _situacao,
          builder: (context, retrato) {
            final s = retrato.data;
            if (s == null) {
              return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
            }
            final abertas = s.emCasa.where((u) => u.estado == EstadoUnidade.aberto).toList();
            final fechadas = s.emCasa.length - abertas.length;
            // Se já tem um aberto, o mais provável é que tenha acabado; senão, que vá abrir.
            final sugereAcabou = abertas.isNotEmpty;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.produto.nome, style: textos.headlineSmall),
                if (widget.produto.marca != null) Text(widget.produto.marca!, style: textos.bodyMedium),
                const SizedBox(height: 8),
                Text(_resumo(fechadas, abertas), style: textos.bodyLarge),
                const SizedBox(height: 20),
                if (s.emCasa.isEmpty)
                  const Text('Não tem nenhum em casa. Para dar entrada, use Compras.')
                else ...[
                  if (s.paraAbrir != null)
                    _Botao(
                      principal: !sugereAcabou,
                      icone: Icons.lock_open_rounded,
                      texto: 'Abrir',
                      aoTocar: _ocupado ? null : () => _fazer(s.paraAbrir!.id, widget.banco.abrir, 'aberto'),
                    ),
                  _Botao(
                    principal: sugereAcabou,
                    icone: Icons.check_circle_rounded,
                    texto: 'Acabou',
                    aoTocar: _ocupado ? null : () => _fazer(s.paraAcabar!.id, widget.banco.acabar, 'acabou'),
                  ),
                  _Botao(
                    principal: false,
                    icone: Icons.delete_outline_rounded,
                    texto: 'Descartar (estragou ou venceu)',
                    aoTocar: _ocupado
                        ? null
                        : () => _fazer(s.paraAcabar!.id, widget.banco.descartar, 'descartado'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  String _resumo(int fechadas, List<Unidade> abertas) {
    if (fechadas == 0 && abertas.isEmpty) return 'Nenhum em casa.';
    final partes = [
      if (fechadas > 0) '$fechadas fechado${fechadas > 1 ? 's' : ''}',
      if (abertas.isNotEmpty) '${abertas.length} aberto${abertas.length > 1 ? 's' : ''}',
    ];
    final maisAntigo = abertas.map((u) => u.abertoEm!).fold<DateTime?>(
          null,
          (antigo, d) => antigo == null || d.isBefore(antigo) ? d : antigo,
        );
    if (maisAntigo != null) {
      final dias = DateTime.now().difference(maisAntigo).inDays;
      partes.add(dias == 0 ? 'aberto hoje' : 'aberto há $dias dia${dias > 1 ? 's' : ''}');
    }
    return partes.join(' · ');
  }
}

class _Situacao {
  const _Situacao({required this.emCasa, required this.paraAbrir, required this.paraAcabar});

  final List<Unidade> emCasa;
  final Unidade? paraAbrir;
  final Unidade? paraAcabar;
}

class _Botao extends StatelessWidget {
  const _Botao({required this.principal, required this.icone, required this.texto, required this.aoTocar});

  final bool principal;
  final IconData icone;
  final String texto;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final estilo = ButtonStyle(minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: principal
          ? FilledButton.icon(style: estilo, icon: Icon(icone), label: Text(texto), onPressed: aoTocar)
          : OutlinedButton.icon(style: estilo, icon: Icon(icone), label: Text(texto), onPressed: aoTocar),
    );
  }
}
