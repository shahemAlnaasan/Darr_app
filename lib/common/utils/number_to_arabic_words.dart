/// Flutter function to convert numbers to Arabic words
/// Supports numbers from 0 to 999,999,999,999 (trillion range)

class NumberToArabicWords {
  // Basic numbers 0-19
  static const Map<int, String> _ones = {
    0: 'صفر',
    1: 'واحد',
    2: 'اثنان',
    3: 'ثلاثة',
    4: 'أربعة',
    5: 'خمسة',
    6: 'ستة',
    7: 'سبعة',
    8: 'ثمانية',
    9: 'تسعة',
    10: 'عشرة',
    11: 'أحد عشر',
    12: 'اثنا عشر',
    13: 'ثلاثة عشر',
    14: 'أربعة عشر',
    15: 'خمسة عشر',
    16: 'ستة عشر',
    17: 'سبعة عشر',
    18: 'ثمانية عشر',
    19: 'تسعة عشر',
  };

  // Tens 20-90
  static const Map<int, String> _tens = {
    20: 'عشرون',
    30: 'ثلاثون',
    40: 'أربعون',
    50: 'خمسون',
    60: 'ستون',
    70: 'سبعون',
    80: 'ثمانون',
    90: 'تسعون',
  };

  // Hundreds
  static const Map<int, String> _hundreds = {
    100: 'مائة',
    200: 'مائتان',
    300: 'ثلاثمائة',
    400: 'أربعمائة',
    500: 'خمسمائة',
    600: 'ستمائة',
    700: 'سبعمائة',
    800: 'ثمانمائة',
    900: 'تسعمائة',
  };

  // Scale words
  // ignore: unused_field
  static const Map<int, String> _scales = {1000: 'ألف', 1000000: 'مليون', 1000000000: 'مليار'};

  /// Main function to convert number to Arabic words
  ///
  /// Example usage:
  /// ```dart
  /// String result = NumberToArabicWords.convertToWords(123);
  /// print(result); // Output: مائة وثلاثة وعشرون
  /// ```
  static String convertToWords(int number) {
    if (number == 0) {
      return _ones[0]!;
    }

    if (number < 0) {
      return 'سالب ${convertToWords(-number)}';
    }

    return _convertPositiveNumber(number);
  }

  static String _convertPositiveNumber(int number) {
    if (number < 20) {
      return _ones[number]!;
    }

    if (number < 100) {
      return _convertTens(number);
    }

    if (number < 1000) {
      return _convertHundreds(number);
    }

    if (number < 1000000) {
      return _convertThousands(number);
    }

    if (number < 1000000000) {
      return _convertMillions(number);
    }

    if (number < 1000000000000) {
      return _convertBillions(number);
    }

    return 'الرقم كبير جداً';
  }

  static String _convertTens(int number) {
    int tensDigit = (number ~/ 10) * 10;
    int onesDigit = number % 10;

    if (onesDigit == 0) {
      return _tens[tensDigit]!;
    }

    return '${_ones[onesDigit]} و${_tens[tensDigit]}';
  }

  static String _convertHundreds(int number) {
    int hundredsDigit = (number ~/ 100) * 100;
    int remainder = number % 100;

    String result = _hundreds[hundredsDigit]!;

    if (remainder > 0) {
      result += ' و${_convertPositiveNumber(remainder)}';
    }

    return result;
  }

  static String _convertThousands(int number) {
    int thousands = number ~/ 1000;
    int remainder = number % 1000;

    String result;

    if (thousands == 1) {
      result = 'ألف';
    } else if (thousands == 2) {
      result = 'ألفان';
    } else if (thousands < 11) {
      result = '${_convertPositiveNumber(thousands)} آلاف';
    } else {
      result = '${_convertPositiveNumber(thousands)} ألف';
    }

    if (remainder > 0) {
      result += ' و${_convertPositiveNumber(remainder)}';
    }

    return result;
  }

  static String _convertMillions(int number) {
    int millions = number ~/ 1000000;
    int remainder = number % 1000000;

    String result;

    if (millions == 1) {
      result = 'مليون';
    } else if (millions == 2) {
      result = 'مليونان';
    } else if (millions < 11) {
      result = '${_convertPositiveNumber(millions)} ملايين';
    } else {
      result = '${_convertPositiveNumber(millions)} مليون';
    }

    if (remainder > 0) {
      result += ' و${_convertPositiveNumber(remainder)}';
    }

    return result;
  }

  static String _convertBillions(int number) {
    int billions = number ~/ 1000000000;
    int remainder = number % 1000000000;

    String result;

    if (billions == 1) {
      result = 'مليار';
    } else if (billions == 2) {
      result = 'ملياران';
    } else if (billions < 11) {
      result = '${_convertPositiveNumber(billions)} مليارات';
    } else {
      result = '${_convertPositiveNumber(billions)} مليار';
    }

    if (remainder > 0) {
      result += ' و${_convertPositiveNumber(remainder)}';
    }

    return result;
  }
}
