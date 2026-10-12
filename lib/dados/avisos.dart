import 'banco.dart';
import 'datas.dart';

/// Uma notificação a agendar no celular.
class AvisoPlanejado {
  const AvisoPlanejado({required this.quando, required this.titulo, required this.texto});

  final DateTime quando;
  final String titulo;
  final String texto;

  @override
  String toString() => '$quando $titulo: $texto';
}

/// Os avisos saem sempre neste horário.
const horaDosAvisos = 9;

/// O Android aguenta bem algumas dezenas de alarmes por app; os mais próximos bastam,
/// porque a lista é refeita sempre que o estoque muda ou o app abre.
const maximoDeAvisos = 40;

/// Calcula as notificações futuras a partir do estoque.
///
/// - Validade: um aviso na véspera ("vence amanhã") e outro no dia ("vence hoje").
/// - Prazo depois de aberto: um aviso no último dia ("use hoje") e outro no dia seguinte
///   ("passou do prazo").
///
/// Só entram avisos depois de [agora]; o que já passou aparece na aba Agora do Início.
List<AvisoPlanejado> planejarAvisos(List<ItemDoEstoque> estoque, {required DateTime agora}) {
  final avisos = <AvisoPlanejado>[];

  void avisar(DateTime dia, String titulo, String texto) {
    final quando = DateTime(dia.year, dia.month, dia.day, horaDosAvisos);
    if (quando.isAfter(agora)) avisos.add(AvisoPlanejado(quando: quando, titulo: titulo, texto: texto));
  }

  for (final item in estoque) {
    if (item.emCasa == 0) continue;
    final nome = item.produto.nome;

    final vence = item.venceEm;
    if (vence != null) {
      final dia = soData(vence);
      avisar(dia.subtract(const Duration(days: 1)), '$nome vence amanhã', 'Validade: ${diaEMes(dia)}.');
      avisar(dia, '$nome vence hoje', 'Use hoje ou descarte.');
    }

    final abertoDesde = item.abertoDesde;
    final prazo = item.produto.diasValidadeAberto;
    if (abertoDesde != null && prazo != null) {
      final ultimoDia = soData(abertoDesde).add(Duration(days: prazo));
      avisar(ultimoDia, '$nome: use hoje', 'Aberto há $prazo dias; hoje é o último dia do prazo.');
      avisar(
        ultimoDia.add(const Duration(days: 1)),
        '$nome passou do prazo',
        'Aberto há ${prazo + 1} dias. Confira antes de usar.',
      );
    }
  }

  avisos.sort((a, b) => a.quando.compareTo(b.quando));
  return avisos.take(maximoDeAvisos).toList();
}
