import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString).toUtc().toLocal();

  final DateFormat formatter =
      DateFormat('dd-MM-yyyy HH:mm:ss'); // Adjust format as needed
  return formatter.format(dateTime);
}

int getMonthFromDateString({
  required String dateString,
  String customFormat = "MM-yyyy",
}) {
  // Define a date format
  DateFormat format = DateFormat(customFormat);

  // Parse the string to DateTime object
  DateTime dateTime = format.parse(dateString);

  // Extract the month
  int month = dateTime.month;

  return month;
}
