String formatCurrency(double amount) {
  String formattedAmount = amount.toStringAsFixed(2);
  formattedAmount = formattedAmount.replaceAll('.', ',');
  List<String> parts = formattedAmount.split(',');
  String integerPart = parts[0];
  String decimalPart = parts[1];

  String formattedIntegerPart = '';
  for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
    if (count != 0 && count % 3 == 0) {
      formattedIntegerPart = ".$formattedIntegerPart";
    }
    formattedIntegerPart = integerPart[i] + formattedIntegerPart;
  }

  return 'R\$$formattedIntegerPart,$decimalPart';
}
