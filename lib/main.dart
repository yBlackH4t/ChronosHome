import 'package:flutter/material.dart';

import 'dados/abrir_banco.dart';
import 'dados/banco.dart';
import 'servicos/open_food_facts.dart';
import 'telas/inicio.dart';

/// Cor principal do Chronos Home (a mesma do fundo do ícone).
const corDaMarca = Color(0xFF1E5E57);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChronosHomeApp(banco: abrirBanco(), openFoodFacts: OpenFoodFacts()));
}

class ChronosHomeApp extends StatelessWidget {
  const ChronosHomeApp({super.key, required this.banco, required this.openFoodFacts});

  /// O banco abre em segundo plano; a tela inicial mostra o erro se falhar.
  final Future<Banco> banco;
  final OpenFoodFacts openFoodFacts;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronos Home',
      debugShowCheckedModeBanner: false,
      // Segue o tema claro ou escuro do celular.
      themeMode: ThemeMode.system,
      theme: _tema(Brightness.light),
      darkTheme: _tema(Brightness.dark),
      home: TelaInicial(banco: banco, openFoodFacts: openFoodFacts),
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
