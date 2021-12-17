import 'package:intl/intl.dart';

class DateTimeHelper {
  String dateFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  String timeFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }
}