String countHour(String isoString) {
  final date = DateTime.parse(isoString).toLocal();
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inHours >= 1) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  } else {
    final minutes = difference.inMinutes;
    if (minutes <= 1) {
      return 'Agora mesmo';
    }
    return '$minutes minutos atrás';
  }
}
