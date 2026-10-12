/// Só a data, sem a hora: para contar dias de calendário.
DateTime soData(DateTime d) => DateTime(d.year, d.month, d.day);

/// Quantos dias de calendário de [de] até [ate] (negativo se [ate] já passou).
int diasEntre(DateTime de, DateTime ate) => soData(ate).difference(soData(de)).inDays;

/// "05/11".
String diaEMes(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

/// "vence hoje", "vence amanhã", "vence em 3 dias", "venceu ontem", "venceu há 4 dias".
String textoDaValidade(int diasRestantes) => switch (diasRestantes) {
      0 => 'vence hoje',
      1 => 'vence amanhã',
      -1 => 'venceu ontem',
      final n when n < 0 => 'venceu há ${-n} dias',
      final n => 'vence em $n dias',
    };
