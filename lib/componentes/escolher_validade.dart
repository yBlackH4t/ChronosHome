import 'package:flutter/material.dart';

/// Calendário para a validade impressa na embalagem. Devolve `null` se a pessoa cancelar.
Future<DateTime?> escolherValidade(BuildContext context, {DateTime? atual}) {
  final hoje = DateUtils.dateOnly(DateTime.now());
  return showDatePicker(
    context: context,
    helpText: 'Validade impressa na embalagem',
    initialDate: atual ?? hoje,
    // Aceita data passada para registrar algo que já chegou vencido.
    firstDate: hoje.subtract(const Duration(days: 365)),
    lastDate: hoje.add(const Duration(days: 365 * 5)),
  );
}
