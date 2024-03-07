import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateToString(DateTime date, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(date);
}

String formatTimeTaken(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);

  int hours = difference.inHours;
  int minutes = (difference.inMinutes % 60);
  int seconds = (difference.inSeconds % 60);

  String formattedTime = '$hours hours, $minutes minutes, $seconds seconds';
  return formattedTime;
}

String formatDuration(Duration duration) {
  return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

//SnackBar Widget
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
        ),
      ),
    );
}
