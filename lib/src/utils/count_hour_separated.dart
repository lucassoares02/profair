String countHourSeparet(int hour, int minute) {
  final now = DateTime.now();

  // monta a data de hoje com hora/minuto informados
  final date = DateTime(now.year, now.month, now.day, hour, minute);

  final difference = now.difference(date);

  if (difference.inHours >= 1) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  } else {
    final minutes = difference.inMinutes;
    if (minutes <= 1) {
      return 'Agora mesmo';
    }
    return '$minutes minutos atrás';
  }
}
