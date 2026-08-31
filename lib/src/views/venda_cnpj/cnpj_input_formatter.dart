import 'package:flutter/services.dart';

abstract class _DigitsMaskInputFormatter extends TextInputFormatter {
  const _DigitsMaskInputFormatter();

  int get maxDigits;

  String applyMask(String digits);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldDigits = _onlyDigits(oldValue.text);
    var digits = _onlyDigits(newValue.text);
    var cursorDigits = _digitsBeforeCursor(
      newValue.text,
      newValue.selection.extentOffset,
    );

    final deletedOnlyMask = newValue.text.length < oldValue.text.length &&
        digits == oldDigits &&
        oldValue.selection.isCollapsed &&
        newValue.selection.isCollapsed;

    if (deletedOnlyMask && cursorDigits > 0) {
      digits = digits.substring(0, cursorDigits - 1) +
          digits.substring(cursorDigits);
      cursorDigits--;
    }

    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    if (cursorDigits > digits.length) {
      cursorDigits = digits.length;
    }

    final formatted = applyMask(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _selectionOffset(formatted, cursorDigits),
      ),
    );
  }

  String _onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  int _digitsBeforeCursor(String text, int cursor) {
    final safeCursor = cursor < 0
        ? 0
        : cursor > text.length
            ? text.length
            : cursor;
    return _onlyDigits(text.substring(0, safeCursor)).length;
  }

  int _selectionOffset(String formatted, int digitCount) {
    if (digitCount <= 0) return 0;

    var seenDigits = 0;
    for (var index = 0; index < formatted.length; index++) {
      if (_onlyDigits(formatted[index]).isNotEmpty) {
        seenDigits++;
        if (seenDigits == digitCount) {
          return index + 1;
        }
      }
    }
    return formatted.length;
  }
}

/// Aplica a máscara de CNPJ: ##.###.###/####-##
class CnpjInputFormatter extends _DigitsMaskInputFormatter {
  const CnpjInputFormatter();

  @override
  int get maxDigits => 14;

  @override
  String applyMask(String digits) {
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index == 2 || index == 5) buffer.write('.');
      if (index == 8) buffer.write('/');
      if (index == 12) buffer.write('-');
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }
}

/// Aplica a máscara de telefone celular: (##) # ####-####
class PhoneInputFormatter extends _DigitsMaskInputFormatter {
  const PhoneInputFormatter();

  @override
  int get maxDigits => 11;

  @override
  String applyMask(String digits) {
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index == 0) buffer.write('(');
      if (index == 2) buffer.write(') ');
      if (index == 3) buffer.write(' ');
      if (index == 7) buffer.write('-');
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }
}

/// Extrai apenas os dígitos do CNPJ.
String cnpjDigits(String value) => value.replaceAll(RegExp(r'\D'), '');
