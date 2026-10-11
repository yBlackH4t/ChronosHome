import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../componentes/acoes_do_produto.dart';
import '../componentes/erro_da_camera.dart';
import '../dados/banco.dart';

/// Na cozinha: bipou → o app sugere Abrir ou Acabou → um toque.
class TelaCozinha extends StatefulWidget {
  const TelaCozinha({super.key, required this.banco});

  final Banco banco;

  @override
  State<TelaCozinha> createState() => _TelaCozinhaState();
}

class _TelaCozinhaState extends State<TelaCozinha> {
  final _camera = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );

  bool _ocupado = false;

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  Future<void> _aoLer(BarcodeCapture captura) async {
    final codigo = captura.barcodes.firstOrNull?.rawValue;
    if (codigo == null || _ocupado) return;
    _ocupado = true;
    try {
      final produto = await widget.banco.produtoPorCodigo(codigo);
      if (!mounted) return;
      if (produto == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('Este produto ainda não está cadastrado. Dê entrada nele pela tela Compras.'),
          ));
        await Future<void>.delayed(const Duration(seconds: 2));
        return;
      }
      // A câmera para enquanto o painel está aberto, para não ler de novo.
      await _camera.stop();
      if (!mounted) return;
      await mostrarAcoesDoProduto(context, widget.banco, produto);
      if (mounted) await _camera.start();
    } finally {
      _ocupado = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cozinha'),
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
          Expanded(
            child: ClipRect(
              child: MobileScanner(
                controller: _camera,
                onDetect: _aoLer,
                errorBuilder: (context, erro) => ErroDaCamera(erro: erro),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Bipe o que você abriu, terminou ou jogou fora.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
