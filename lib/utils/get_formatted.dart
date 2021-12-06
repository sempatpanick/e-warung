import 'package:intl/intl.dart';

class GetFormatted {
  String number(int value) {
    var f = NumberFormat.decimalPattern('id');
    return f.format(value);
  }
}