import 'package:flutter/material.dart';

/// Cor principal do Chronos Home (a mesma do fundo do ícone).
const corDaMarca = Color(0xFF1E5E57);

void main() {
  runApp(const ChronosHomeApp());
}

class ChronosHomeApp extends StatelessWidget {
  const ChronosHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronos Home',
      debugShowCheckedModeBanner: false,
      // Segue o tema claro ou escuro do celular.
      themeMode: ThemeMode.system,
      theme: _tema(Brightness.light),
      darkTheme: _tema(Brightness.dark),
      home: const TelaInicial(),
    );
  }

  static ThemeData _tema(Brightness brilho) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: corDaMarca,
        brightness: brilho,
      ),
    );
  }
}

/// Tela provisória: as telas de verdade (Início, Compras, Cozinha...) vêm nos próximos passos.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Chronos Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home_rounded, size: 72, color: cores.primary),
              const SizedBox(height: 16),
              Text('Estoque da casa', style: textos.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Em breve: bipar as compras, abrir, acabou e a lista de compras.',
                textAlign: TextAlign.center,
                style: textos.bodyMedium?.copyWith(color: cores.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
