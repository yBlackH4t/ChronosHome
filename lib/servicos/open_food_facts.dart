import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// O que o Open Food Facts sabe sobre um código de barras.
class ProdutoEncontrado {
  const ProdutoEncontrado({required this.nome, this.marca, this.categoria, this.foto});

  final String nome;
  final String? marca;
  final String? categoria;
  final String? foto;
}

/// Consulta a base aberta e gratuita do Open Food Facts (world.openfoodfacts.org).
/// Sem chave e sem custo; a regra deles é se identificar no User-Agent.
class OpenFoodFacts {
  OpenFoodFacts({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  static const _campos = 'product_name_pt,product_name,brands,categories,image_front_small_url';
  static const _identificacao = 'ChronosHome/1.0 (github.com/yBlackH4t/ChronosHome)';

  /// Devolve o produto, ou `null` se a base não conhece o código.
  /// Sem internet ou com erro no servidor, lança [FalhaNaConsulta].
  Future<ProdutoEncontrado?> buscar(String codigo) async {
    final endereco = Uri.https(
      'world.openfoodfacts.org',
      '/api/v2/product/${Uri.encodeComponent(codigo.trim())}.json',
      {'fields': _campos, 'lc': 'pt'},
    );

    final http.Response resposta;
    try {
      resposta = await _cliente
          .get(endereco, headers: {'User-Agent': _identificacao})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const FalhaNaConsulta('O Open Food Facts demorou demais para responder.');
    } catch (_) {
      throw const FalhaNaConsulta('Sem conexão com a internet.');
    }

    if (resposta.statusCode == 404) return null;
    if (resposta.statusCode != 200) {
      throw FalhaNaConsulta('O Open Food Facts respondeu com erro ${resposta.statusCode}.');
    }

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    if (dados['status'] != 1) return null;
    final produto = (dados['product'] as Map?)?.cast<String, dynamic>() ?? const {};

    final nome = _texto(produto['product_name_pt']) ?? _texto(produto['product_name']);
    if (nome == null) return null;

    return ProdutoEncontrado(
      nome: nome,
      marca: _primeiro(produto['brands']),
      categoria: _ultimo(produto['categories']),
      foto: _texto(produto['image_front_small_url']),
    );
  }

  void fechar() => _cliente.close();

  static String? _texto(Object? valor) {
    final texto = valor?.toString().trim();
    return (texto == null || texto.isEmpty) ? null : texto;
  }

  /// "Hellmann's, Unilever" → "Hellmann's".
  static String? _primeiro(Object? lista) => _texto(_texto(lista)?.split(',').first);

  /// As categorias vêm da mais geral para a mais específica; fica a mais específica.
  static String? _ultimo(Object? lista) => _texto(_texto(lista)?.split(',').last);
}

class FalhaNaConsulta implements Exception {
  const FalhaNaConsulta(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
