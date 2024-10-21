class CustomDatetime {
  // CustomDatetime({required this.datetime});

  // DateTime datetime;

  // factory CustomDatetime.fromDateTime(DateTime datetime) => datetime.toIso8601String().replaceAll('.', ':');

  String toText(DateTime datetime) => datetime.toIso8601String().replaceAll('.', ':');
  
  DateTime toDateTime(String customDate) => DateTime.parse(customDate.replaceFirst(':', '.', 18));

}