import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../dados/banco.dart';

/// Prova do passo 2: a câmera lê o código e ele vai direto para o banco.
class TelaBipar extends StatefulWidget {
  const TelaBipar({super.key, required this.banco});

  final Banco banco;

  @override
  State<TelaBipar> createState() => _TelaBiparState();
}

class _TelaBiparState extends State<TelaBipar> {
  final _camera = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.qrCode,
    ],
    // Não repete o mesmo código a cada quadro da câmera.
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  Future<void> _aoLer(BarcodeCapture captura) async {
    final codigo = captura.barcodes.firstOrNull;
    final valor = codigo?.rawValue;
    if (codigo == null || valor == null) return;

    await widget.banco.registrarLeitura(valor, codigo.format.name);
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Gravado: $valor')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bipar'),
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
                errorBuilder: (context, erro) => _ErroDaCamera(erro: erro),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Últimas leituras gravadas'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Leitura>>(
              stream: widget.banco.observarUltimas(),
              builder: (context, retrato) {
                final leituras = retrato.data ?? const [];
                if (leituras.isEmpty) {
                  return const Center(child: Text('Aponte a câmera para um código de barras.'));
                }
                return ListView.builder(
                  itemCount: leituras.length,
                  itemBuilder: (context, i) {
                    final l = leituras[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.qr_code_2_rounded),
                      title: Text(l.codigo),
                      subtitle: Text('${l.formato} · ${_hora(l.lidoEm)}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _hora(DateTime t) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(t.hour)}:${dois(t.minute)}:${dois(t.second)}';
  }
}

/// Mostra um erro da câmera em português, em vez de uma tela preta.
class _ErroDaCamera extends StatelessWidget {
  const _ErroDaCamera({required this.erro});

  final MobileScannerException erro;

  @override
  Widget build(BuildContext context) {
    final mensagem = switch (erro.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        'O Chronos Home não tem permissão para usar a câmera. '
            'Libere em Configurações > Aplicativos > Chronos Home > Permissões > Câmera.',
      MobileScannerErrorCode.unsupported => 'Este celular não tem uma câmera que leia códigos.',
      _ => 'Não consegui abrir a câmera (${erro.errorCode.name}). Feche a tela e tente de novo.',
    };
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_rounded, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(mensagem, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
