

import 'package:intl/intl.dart';

class HumanFormats {

  static String number( double number, [decimals = 0] ) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);
    return formattedNumber;
  }

}