import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_dados;
import 'package:timezone/timezone.dart' as tz;

import '../dados/avisos.dart';

/// Agenda os avisos como notificações do Android. Tudo fica no celular: sem servidor e sem custo.
class AvisosNoCelular {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<bool>? _iniciando;
  String? _ultimoAgendado;

  static const _canal = AndroidNotificationDetails(
    'avisos_do_estoque',
    'Avisos do estoque',
    channelDescription: 'Validade perto e prazo depois de aberto.',
    importance: Importance.defaultImportance,
    // Ícone branco da casa com relógio (o da barra de status precisa ser de uma cor só).
    icon: '@drawable/ic_launcher_foreground',
  );

  /// Prepara o fuso horário e o plugin, e pede a permissão (só o Android 13+ pergunta).
  /// Devolve `false` se algo falhar; o app segue funcionando sem avisos.
  Future<bool> iniciar() => _iniciando ??= _iniciar();

  Future<bool> _iniciar() async {
    try {
      tz_dados.initializeTimeZones();
      final fuso = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(fuso.identifier));
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_launcher_foreground'),
        ),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return true;
    } catch (erro) {
      debugPrint('Avisos desligados: $erro');
      return false;
    }
  }

  /// Troca os avisos agendados por [avisos]. Não mexe nos que já estão na tela.
  Future<void> agendar(List<AvisoPlanejado> avisos) async {
    if (!await iniciar()) return;
    // A lista de avisos só muda quando o estoque muda; evita refazer tudo à toa.
    final assinatura = avisos.join('|');
    if (assinatura == _ultimoAgendado) return;
    _ultimoAgendado = assinatura;

    await _plugin.cancelAllPendingNotifications();
    for (final (i, aviso) in avisos.indexed) {
      await _plugin.zonedSchedule(
        id: i,
        scheduledDate: tz.TZDateTime.from(aviso.quando, tz.local),
        notificationDetails: const NotificationDetails(android: _canal),
        // Sem pedir a permissão de alarme exato: pode atrasar alguns minutos, mas sai no dia certo.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: aviso.titulo,
        body: aviso.texto,
      );
    }
  }
}
