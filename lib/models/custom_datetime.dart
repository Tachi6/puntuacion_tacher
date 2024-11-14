import 'package:intl/intl.dart';

class CustomDatetime {
  // CustomDatetime({required this.datetime});

  // DateTime datetime;

  // factory CustomDatetime.fromDateTime(DateTime datetime) => datetime.toIso8601String().replaceAll('.', ':');

  String toTextToEndOfDay(DateTime datetime) =>'${datetime.year}-${datetime.month}-${datetime.day}T23:59:59:999';

  String toText(DateTime datetime) => datetime.toIso8601String().replaceAll('.', ':');
  
  DateTime toDateTime(String customDate) => DateTime.parse(customDate.replaceFirst(':', '.', 18));

  String toPlainText(String customDate) {
    Intl.defaultLocale = 'es_ES';
    final DateTime date = toDateTime(customDate);
    final weekDay = '${DateFormat('EEEE').format(date)[0].toUpperCase()}${DateFormat('EEEE').format(date).substring(1)}';
    final month = '${DateFormat('MMMM').format(date)[0].toUpperCase()}${DateFormat('MMMM').format(date).substring(1)}';

    return '$weekDay, ${date.day} de $month de ${date.year}';
  }

}