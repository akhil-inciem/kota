import 'package:intl/intl.dart';

DateTime parseDate(String dateString) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return DateFormat('dd MMM yyyy').parse(dateString);
  }
}

String formatDate(String date) {
  if (date == "0000-00-00 00:00:00") {
    return "No Date Available"; // Handle invalid or empty date string
  }
  try {
    // Parse the date string
    DateTime parsedDate = DateTime.parse(date);
    
    // Return the formatted time (e.g., "12:30 PM")
    return DateFormat('h:mm a').format(parsedDate); // Format the time
  } catch (e) {
    // If parsing fails, return a fallback message
    return "Invalid Date";
  }
}