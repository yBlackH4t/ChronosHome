import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dados/abrir_banco.dart';
import 'dados/banco.dart';
import 'servicos/avisos_no_celular.dart';
import 'servicos/open_food_facts.dart';
import 'telas/inicio.dart';

/// Cor principal do Chronos Home (a mesma do fundo do ícone).
const corDaMarca = Color(0xFF1E5E57);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChronosHomeApp(
    banco: abrirBanco(),
    openFoodFacts: OpenFoodFacts(),
    avisos: AvisosNoCelular(),
  ));
}

class ChronosHomeApp extends StatelessWidget {
  const ChronosHomeApp({super.key, required this.banco, required this.openFoodFacts, this.avisos});

  /// O banco abre em segundo plano; a tela inicial mostra o erro se falhar.
  final Future<Banco> banco;
  final OpenFoodFacts openFoodFacts;

  /// Notificações do celular. Vazio nos testes.
  final AvisosNoCelular? avisos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronos Home',
      debugShowCheckedModeBanner: false,
      // Calendário e textos do Flutter em português.
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // Segue o tema claro ou escuro do celular.
      themeMode: ThemeMode.system,
      theme: _tema(Brightness.light),
      darkTheme: _tema(Brightness.dark),
      home: TelaInicial(banco: banco, openFoodFacts: openFoodFacts, avisos: avisos),
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
