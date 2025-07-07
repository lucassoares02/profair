String formatHour(String isoString) {
  final date = DateTime.parse(isoString).toLocal();

  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}
