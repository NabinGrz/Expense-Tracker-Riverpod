import 'package:intl/intl.dart';

extension CurrencyFormat on int? {
  String get toCurrency =>
      NumberFormat.currency(locale: 'en_US', symbol: '').format(this ?? 0);
}
