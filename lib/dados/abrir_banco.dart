import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'banco.dart';

const _nomeDoArquivo = 'chronos_home.db';
const _nomeDaChave = 'chave_do_banco';

/// Abre o banco criptografado com SQLCipher.
///
/// A chave (32 bytes aleatórios) é criada na primeira vez e fica no Android Keystore,
/// pelo flutter_secure_storage. Sem ela o arquivo do banco é ilegível.
Future<Banco> abrirBanco() async {
  final chave = await _obterChave();
  final arquivo = await arquivoDoBanco();

  return Banco(
    NativeDatabase.createInBackground(
      arquivo,
      setup: (db) {
        final versao = db.select('PRAGMA cipher_version');
        if (versao.isEmpty) {
          throw StateError('O SQLCipher não foi carregado: o banco ficaria sem criptografia.');
        }
        db.execute("PRAGMA key = \"x'$chave'\";");
        // Falha aqui se a chave não abrir o arquivo.
        db.select('SELECT count(*) FROM sqlite_master;');
      },
    ),
  );
}

Future<File> arquivoDoBanco() async {
  final pasta = await getApplicationDocumentsDirectory();
  return File(p.join(pasta.path, _nomeDoArquivo));
}

/// Confere se o arquivo no disco está criptografado: um SQLite comum começa com
/// o texto "SQLite format 3"; um SQLCipher começa com bytes aleatórios.
Future<bool> arquivoEstaCriptografado() async {
  final arquivo = await arquivoDoBanco();
  if (!await arquivo.exists()) return false;
  final inicio = await arquivo.openRead(0, 15).expand((b) => b).toList();
  return String.fromCharCodes(inicio) != 'SQLite format 3';
}

Future<String> _obterChave() async {
  const armazenamento = FlutterSecureStorage();
  final existente = await armazenamento.read(key: _nomeDaChave);
  if (existente != null) return existente;

  final aleatorio = Random.secure();
  final nova = List.generate(32, (_) => aleatorio.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
  await armazenamento.write(key: _nomeDaChave, value: nova);
  return nova;
}
