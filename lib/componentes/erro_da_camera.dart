import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Mostra um erro da câmera em português, em vez de uma tela preta.
class ErroDaCamera extends StatelessWidget {
  const ErroDaCamera({super.key, required this.erro});

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
