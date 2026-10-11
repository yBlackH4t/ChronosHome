import 'package:flutter/material.dart';

import '../dados/abrir_banco.dart';
import '../dados/banco.dart';

/// Prova do passo 2: confere que o banco é SQLCipher, que o arquivo está
/// criptografado e quantas leituras sobreviveram ao fechar e reabrir o app.
class TelaProvaBanco extends StatefulWidget {
  const TelaProvaBanco({super.key, required this.banco});

  final Banco banco;

  @override
  State<TelaProvaBanco> createState() => _TelaProvaBancoState();
}

class _TelaProvaBancoState extends State<TelaProvaBanco> {
  late Future<_Resultado> _resultado = _conferir();

  Future<_Resultado> _conferir() async {
    return _Resultado(
      versaoSqlcipher: await widget.banco.versaoDoSqlcipher(),
      arquivoCriptografado: await arquivoEstaCriptografado(),
      leituras: await widget.banco.contarLeituras(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banco criptografado'),
        actions: [
          IconButton(
            tooltip: 'Conferir de novo',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() => _resultado = _conferir()),
          ),
        ],
      ),
      body: FutureBuilder<_Resultado>(
        future: _resultado,
        builder: (context, retrato) {
          if (retrato.hasError) {
            return Center(child: Text('Erro ao conferir o banco: ${retrato.error}'));
          }
          final r = retrato.data;
          if (r == null) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Item(
                ok: r.versaoSqlcipher != null,
                titulo: 'SQLCipher carregado',
                detalhe: r.versaoSqlcipher == null ? 'não' : 'versão ${r.versaoSqlcipher}',
              ),
              _Item(
                ok: r.arquivoCriptografado,
                titulo: 'Arquivo do banco criptografado',
                detalhe: r.arquivoCriptografado
                    ? 'o arquivo não começa com "SQLite format 3"'
                    : 'o arquivo está legível ou ainda não existe',
              ),
              _Item(
                ok: r.leituras > 0,
                titulo: 'Leituras gravadas',
                detalhe: '${r.leituras}. Feche o app, abra de novo e confira se o número continua.',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Resultado {
  const _Resultado({
    required this.versaoSqlcipher,
    required this.arquivoCriptografado,
    required this.leituras,
  });

  final String? versaoSqlcipher;
  final bool arquivoCriptografado;
  final int leituras;
}

class _Item extends StatelessWidget {
  const _Item({required this.ok, required this.titulo, required this.detalhe});

  final bool ok;
  final String titulo;
  final String detalhe;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(
          ok ? Icons.check_circle_rounded : Icons.error_rounded,
          color: ok ? cores.primary : cores.error,
        ),
        title: Text(titulo),
        subtitle: Text(detalhe),
      ),
    );
  }
}
