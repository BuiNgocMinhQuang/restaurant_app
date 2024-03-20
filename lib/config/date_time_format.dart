import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString).toUtc().toLocal();
  print('${dateTime.timeZoneName}');

  final DateFormat formatter =
      DateFormat('dd-MM-yyyy HH:mm:ss'); // Adjust format as needed
  return formatter.format(dateTime);
}
