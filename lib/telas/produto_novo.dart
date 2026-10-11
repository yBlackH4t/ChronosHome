import 'package:flutter/material.dart';

import '../dados/banco.dart';
import '../servicos/open_food_facts.dart';

/// O que a tela devolve depois de salvar.
class ProdutoCadastrado {
  const ProdutoCadastrado(this.produto, this.unidades);

  final Produto produto;
  final List<String> unidades;
}

/// Código que o app ainda não conhece: busca no Open Food Facts, a pessoa confere e salva.
/// Salvar cadastra o produto e já dá entrada nas unidades.
class TelaProdutoNovo extends StatefulWidget {
  const TelaProdutoNovo({
    super.key,
    required this.codigo,
    required this.banco,
    required this.openFoodFacts,
    this.localId,
    this.nomeDoLocal,
  });

  final String codigo;
  final Banco banco;
  final OpenFoodFacts openFoodFacts;
  final String? localId;
  final String? nomeDoLocal;

  @override
  State<TelaProdutoNovo> createState() => _TelaProdutoNovoState();
}

enum _Busca { procurando, encontrado, naoEncontrado, falhou }

class _TelaProdutoNovoState extends State<TelaProdutoNovo> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _marca = TextEditingController();
  final _categoria = TextEditingController();
  final _diasAberto = TextEditingController();
  final _estoqueMinimo = TextEditingController();

  _Busca _busca = _Busca.procurando;
  String? _erroDaBusca;
  String? _foto;
  int _quantidade = 1;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  @override
  void dispose() {
    for (final c in [_nome, _marca, _categoria, _diasAberto, _estoqueMinimo]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _buscar() async {
    setState(() => _busca = _Busca.procurando);
    try {
      final achado = await widget.openFoodFacts.buscar(widget.codigo);
      if (!mounted) return;
      setState(() {
        if (achado == null) {
          _busca = _Busca.naoEncontrado;
          return;
        }
        _busca = _Busca.encontrado;
        // Não apaga o que a pessoa já começou a digitar.
        if (_nome.text.isEmpty) _nome.text = achado.nome;
        if (_marca.text.isEmpty) _marca.text = achado.marca ?? '';
        if (_categoria.text.isEmpty) _categoria.text = achado.categoria ?? '';
        _foto = achado.foto;
      });
    } on FalhaNaConsulta catch (erro) {
      if (!mounted) return;
      setState(() {
        _busca = _Busca.falhou;
        _erroDaBusca = erro.mensagem;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _salvando = true);
    String? vazioVira(String texto) => texto.trim().isEmpty ? null : texto.trim();

    final produtoId = await widget.banco.cadastrarProduto(
      nome: _nome.text,
      marca: vazioVira(_marca.text),
      categoria: vazioVira(_categoria.text),
      foto: _foto,
      estoqueMinimo: int.tryParse(_estoqueMinimo.text) ?? 0,
      diasValidadeAberto: int.tryParse(_diasAberto.text),
      codigos: [widget.codigo],
    );
    final unidades = await widget.banco.darEntrada(
      produtoId,
      quantidade: _quantidade,
      localId: widget.localId,
    );
    final produto = (await widget.banco.produtoPorCodigo(widget.codigo))!;
    if (!mounted) return;
    Navigator.of(context).pop(ProdutoCadastrado(produto, unidades));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produto novo')),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _AvisoDaBusca(busca: _busca, erro: _erroDaBusca, tentarDeNovo: _buscar),
            const SizedBox(height: 16),
            if (_foto != null) ...[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _foto!,
                    height: 140,
                    // Foto pequena na memória: o A10s agradece.
                    cacheHeight: 280,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text('Código: ${widget.codigo}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(labelText: 'Nome *', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Digite o nome do produto' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _marca,
              decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoria,
              decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _diasAberto,
              decoration: const InputDecoration(
                labelText: 'Depois de aberto, dura quantos dias?',
                helperText: 'Opcional. Ex.: maionese, 5. Usado nos avisos.',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: _numeroOpcional,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _estoqueMinimo,
              decoration: const InputDecoration(
                labelText: 'Estoque mínimo',
                helperText: 'Opcional. Abaixo disso entra na lista de compras.',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: _numeroOpcional,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.nomeDoLocal == null ? 'Quantidade' : 'Quantidade (vai para ${widget.nomeDoLocal})',
                  ),
                ),
                IconButton(
                  tooltip: 'Menos',
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  onPressed: _quantidade > 1 ? () => setState(() => _quantidade--) : null,
                ),
                Text('$_quantidade', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  tooltip: 'Mais',
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () => setState(() => _quantidade++),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton.icon(
            icon: const Icon(Icons.save_rounded),
            label: const Text('Salvar e dar entrada'),
            onPressed: _salvando ? null : _salvar,
          ),
        ),
      ),
    );
  }

  static String? _numeroOpcional(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;
    final n = int.tryParse(valor.trim());
    return (n == null || n < 0) ? 'Use um número inteiro' : null;
  }
}

class _AvisoDaBusca extends StatelessWidget {
  const _AvisoDaBusca({required this.busca, required this.erro, required this.tentarDeNovo});

  final _Busca busca;
  final String? erro;
  final VoidCallback tentarDeNovo;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final (icone, texto) = switch (busca) {
      _Busca.procurando => (null, 'Procurando no Open Food Facts...'),
      _Busca.encontrado => (Icons.check_circle_rounded, 'Achei no Open Food Facts. Confira e salve.'),
      _Busca.naoEncontrado => (Icons.help_rounded, 'O Open Food Facts não conhece este código. Preencha o nome.'),
      _Busca.falhou => (Icons.cloud_off_rounded, '${erro ?? 'Falhou'} Preencha à mão ou tente de novo.'),
    };
    return Card(
      color: cores.secondaryContainer,
      child: ListTile(
        leading: icone == null
            ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3))
            : Icon(icone, color: cores.onSecondaryContainer),
        title: Text(texto, style: TextStyle(color: cores.onSecondaryContainer)),
        trailing: busca == _Busca.falhou
            ? IconButton(tooltip: 'Tentar de novo', icon: const Icon(Icons.refresh_rounded), onPressed: tentarDeNovo)
            : null,
      ),
    );
  }
}
