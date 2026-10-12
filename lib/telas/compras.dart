import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../componentes/erro_da_camera.dart';
import '../componentes/escolher_validade.dart';
import '../dados/banco.dart';
import '../dados/datas.dart';
import '../servicos/open_food_facts.dart';
import 'produto_novo.dart';

/// Chegou das compras: cada código bipado vira uma unidade no estoque.
/// Produto conhecido entra direto; produto novo abre o cadastro (com o Open Food Facts).
class TelaCompras extends StatefulWidget {
  const TelaCompras({super.key, required this.banco, required this.openFoodFacts});

  final Banco banco;
  final OpenFoodFacts openFoodFacts;

  @override
  State<TelaCompras> createState() => _TelaComprasState();
}

class _TelaComprasState extends State<TelaCompras> {
  final _camera = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );

  /// O mesmo código só conta de novo depois deste intervalo (a câmera lê várias vezes por segundo).
  static const _intervaloEntreLeituras = Duration(seconds: 2);

  List<Local> _locais = const [];
  String? _localId;
  bool _ocupado = false;
  String? _ultimoCodigo;
  DateTime _ultimaLeitura = DateTime(2000);

  /// O que entrou nesta compra, por produto (o mais recente no topo).
  final _nestaCompra = <_ItemDaCompra>[];

  @override
  void initState() {
    super.initState();
    widget.banco.listarLocais().then((locais) {
      if (!mounted) return;
      setState(() {
        _locais = locais;
        _localId = locais.where((l) => l.nome == 'Despensa').firstOrNull?.id ?? locais.firstOrNull?.id;
      });
    });
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  Future<void> _aoLer(BarcodeCapture captura) async {
    final codigo = captura.barcodes.firstOrNull?.rawValue;
    if (codigo == null || _ocupado) return;
    final agora = DateTime.now();
    if (codigo == _ultimoCodigo && agora.difference(_ultimaLeitura) < _intervaloEntreLeituras) return;
    _ultimoCodigo = codigo;
    _ultimaLeitura = agora;

    _ocupado = true;
    try {
      final produto = await widget.banco.produtoPorCodigo(codigo);
      if (produto != null) {
        await _darEntrada(produto, 1);
      } else {
        await _cadastrarNovo(codigo);
      }
    } on TransicaoInvalida catch (erro) {
      _avisar(erro.mensagem);
    } finally {
      _ocupado = false;
      _ultimaLeitura = DateTime.now();
    }
  }

  Future<void> _darEntrada(Produto produto, int quantidade) async {
    // Mais uma unidade do mesmo produto nesta compra herda a validade já escolhida.
    final venceEm = _nestaCompra.where((i) => i.produto.id == produto.id).firstOrNull?.venceEm;
    final ids = await widget.banco.darEntrada(
      produto.id,
      quantidade: quantidade,
      localId: _localId,
      venceEm: venceEm,
    );
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    setState(() {
      final existente = _nestaCompra.where((i) => i.produto.id == produto.id).firstOrNull;
      if (existente != null) {
        existente.unidades.addAll(ids);
        _nestaCompra
          ..remove(existente)
          ..insert(0, existente);
      } else {
        _nestaCompra.insert(0, _ItemDaCompra(produto, ids));
      }
    });
  }

  Future<void> _cadastrarNovo(String codigo) async {
    await _camera.stop();
    if (!mounted) return;
    final local = _locais.where((l) => l.id == _localId).firstOrNull;
    final resultado = await Navigator.of(context).push<ProdutoCadastrado>(MaterialPageRoute(
      builder: (_) => TelaProdutoNovo(
        codigo: codigo,
        banco: widget.banco,
        openFoodFacts: widget.openFoodFacts,
        localId: _localId,
        nomeDoLocal: local?.nome,
      ),
    ));
    if (resultado != null && mounted) {
      await HapticFeedback.mediumImpact();
      setState(() => _nestaCompra.insert(0, _ItemDaCompra(resultado.produto, [...resultado.unidades], venceEm: resultado.venceEm)));
    }
    if (mounted) await _camera.start();
  }

  Future<void> _escolherValidade(_ItemDaCompra item) async {
    final data = await escolherValidade(context, atual: item.venceEm);
    if (data == null) return;
    await widget.banco.definirValidade(item.unidades, data);
    if (mounted) setState(() => item.venceEm = data);
  }

  Future<void> _desfazerUma(_ItemDaCompra item) async {
    try {
      await widget.banco.desfazerEntrada(item.unidades.last);
    } on TransicaoInvalida catch (erro) {
      _avisar(erro.mensagem);
      return;
    }
    setState(() {
      item.unidades.removeLast();
      if (item.unidades.isEmpty) _nestaCompra.remove(item);
    });
  }

  void _avisar(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    final total = _nestaCompra.fold<int>(0, (soma, i) => soma + i.unidades.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        actions: [
          IconButton(
            tooltip: 'Lanterna',
            icon: const Icon(Icons.flashlight_on_rounded),
            onPressed: _camera.toggleTorch,
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRect(
              child: MobileScanner(
                controller: _camera,
                onDetect: _aoLer,
                errorBuilder: (context, erro) => ErroDaCamera(erro: erro),
              ),
            ),
          ),
          _EscolhaDoLocal(
            locais: _locais,
            selecionado: _localId,
            aoEscolher: (id) => setState(() => _localId = id),
          ),
          const Divider(height: 1),
          Expanded(
            child: _nestaCompra.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Aponte a câmera para o código de barras de cada item.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _nestaCompra.length,
                    itemBuilder: (context, i) {
                      final item = _nestaCompra[i];
                      return ListTile(
                        title: Text(item.produto.nome),
                        subtitle: Text(
                          item.venceEm == null
                              ? 'Toque para pôr a validade'
                              : 'Validade: ${diaEMes(item.venceEm!)}',
                        ),
                        onTap: () => _escolherValidade(item),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Tirar um',
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                              onPressed: () => _desfazerUma(item),
                            ),
                            Text('${item.unidades.length}', style: Theme.of(context).textTheme.titleMedium),
                            IconButton(
                              tooltip: 'Mais um',
                              icon: const Icon(Icons.add_circle_outline_rounded),
                              onPressed: () => _darEntrada(item.produto, 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: total == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: FilledButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: Text('Concluir ($total ${total == 1 ? 'item' : 'itens'})'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
    );
  }
}

class _ItemDaCompra {
  _ItemDaCompra(this.produto, this.unidades, {this.venceEm});

  DateTime? venceEm;

  final Produto produto;
  final List<String> unidades;
}

class _EscolhaDoLocal extends StatelessWidget {
  const _EscolhaDoLocal({required this.locais, required this.selecionado, required this.aoEscolher});

  final List<Local> locais;
  final String? selecionado;
  final ValueChanged<String> aoEscolher;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Text('Guardar em:'),
          const SizedBox(width: 8),
          for (final local in locais)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(local.nome),
                selected: local.id == selecionado,
                onSelected: (_) => aoEscolher(local.id),
              ),
            ),
        ],
      ),
    );
  }
}
