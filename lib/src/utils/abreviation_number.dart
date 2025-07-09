String abbreviateNumber(double value) {
  if (value >= 10000) {
    // ≥ 10 000 → sem casa decimal, só milhares
    final int thousands = (value / 1000).floor();
    return '${thousands}k';
  } else if (value >= 1000) {
    // entre 1 000 e 9 999 → uma casa decimal (removendo “.0”)
    final double thousands = value / 1000;
    final String text = thousands.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    return '${text}k';
  } else {
    // abaixo de 1 000 → mantém parte inteira ou até 2 decimais, sem zeros finais
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
  }
}
